#!/usr/bin/env bash

set -euo pipefail

readonly VM_REQUIRED_COMMANDS=(curl jq sha256sum virt-install virt-manager virsh)
readonly VM_ROOT="$(cd "${BASH_SOURCE[0]%/*}/.." && pwd)"
readonly VM_CACHE_DIR="${VM_CACHE_DIR:-$VM_ROOT/.cache/vms}"
readonly VM_LOG_DIR="${VM_LOG_DIR:-$VM_CACHE_DIR/logs}"
readonly VM_STORAGE_POOL="${VM_STORAGE_POOL:-default}"
readonly VM_TARGETS_CONFIG="$VM_ROOT/config/targets.json"
readonly VM_USER_HOME="${VM_USER_HOME:-$HOME}"

main() {
  case "${1:-}" in
    '' | help | -h | --help)
      print_help
      ;;
    check)
      run_or_print_help check_host "${2:-}"
      ;;
    fetch)
      run_or_print_help fetch_iso "${2:-}" "${3:-}"
      ;;
    build)
      run_or_print_help build_guest "${2:-}" "${3:-}"
      ;;
    stop)
      run_or_print_help stop_guest "${2:-}" "${3:-}"
      ;;
    run)
      run_or_print_help run_test_guest "${2:-}" "${3:-}"
      ;;
    *)
      printf 'Unknown command: %s\n' "$1" >&2
      printf '%s\n' 'Run v2/bin/vm --help for usage.' >&2
      return 2
      ;;
  esac
}

run_or_print_help() {
  local command="$1"
  local target="$2"
  local option="${3:-}"

  if [ "$target" = --help ] || [ "$target" = -h ] || [ "$option" = --help ] || [ "$option" = -h ]; then
    print_help
    return 0
  fi
  "$command" "$target"
}

check_host() {
  local target="${1:-}"
  local command
  local has_missing_command=false

  for command in "${VM_REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$command" >/dev/null 2>&1; then
      printf 'Missing host command: %s\n' "$command" >&2
      has_missing_command=true
    fi
  done

  if "$has_missing_command"; then
    return 1
  fi

  if [ -z "$target" ] || [ "$target" = ubuntu ]; then
    for command in cloud-localds setfacl; do
      if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Missing host command: %s\n' "$command" >&2
        has_missing_command=true
      fi
    done
  fi

  if "$has_missing_command"; then
    return 1
  fi

  if ! virsh -c qemu:///system uri >/dev/null 2>&1; then
    printf '%s\n' 'Cannot connect to qemu:///system.' >&2
    return 1
  fi

  printf '%s\n' 'Host checks pass.'
}

fetch_iso() {
  local target="$1"
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local partial_path

  read_target "$target" iso_name iso_url iso_sha256 || return $?
  iso_path="$VM_CACHE_DIR/iso/$iso_name"

  if [ -f "$iso_path" ] && verify_iso "$iso_path" "$iso_sha256"; then
    printf 'ISO is ready: %s\n' "$iso_name"
    return 0
  fi

  mkdir -p "${iso_path%/*}"
  partial_path="$iso_path.part"
  rm -f "$partial_path"
  curl --fail --location --output "$partial_path" "$iso_url"

  if ! verify_iso "$partial_path" "$iso_sha256"; then
    rm -f "$partial_path"
    printf 'ISO checksum does not match: %s\n' "$iso_name" >&2
    return 1
  fi

  mv "$partial_path" "$iso_path"
  printf 'ISO is ready: %s\n' "$iso_name"
}

read_target() {
  local target="$1"
  local -n name_ref="$2"
  local -n url_ref="$3"
  local -n sha256_ref="$4"
  local values

  if ! values="$(jq -er --arg target "$target" '
    .targets[$target] as $target_config |
    if $target_config == null then error("unknown target")
    else [$target_config.iso.name, $target_config.iso.url, ($target_config.iso.sha256 // "")] | @tsv
    end
  ' "$VM_TARGETS_CONFIG" 2>/dev/null)"; then
    printf 'Unknown target: %s\n' "$target" >&2
    return 2
  fi

  IFS=$'\t' read -r name_ref url_ref sha256_ref <<<"$values"
}

verify_iso() {
  local iso_path="$1"
  local expected_sha256="$2"

  printf '%s  %s\n' "$expected_sha256" "${iso_path##*/}" | (
    cd "${iso_path%/*}"
    sha256sum --check --status -
  )
}

build_guest() {
  case "$1" in
    fedora) build_fedora_guest ;;
    ubuntu) build_ubuntu_guest ;;
    *) printf 'Unsupported build target: %s\n' "$1" >&2; return 2 ;;
  esac
}

build_ubuntu_guest() {
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local volume_name
  local seed_path="$VM_CACHE_DIR/seeds/ubuntu.iso"
  local build_domain_name="dot-v2-ubuntu-base-build"
  local log_path="$VM_LOG_DIR/ubuntu-build.log"

  read_target ubuntu iso_name iso_url iso_sha256 || return $?
  volume_name="$(base_volume_name ubuntu)"
  iso_path="$VM_CACHE_DIR/iso/$iso_name"

  if base_volume_exists ubuntu; then
    if [ ! -t 0 ]; then
      printf '%s\n' 'Base image exists: ubuntu. Run build from a terminal to confirm rebuild.' >&2
      return 1
    fi
    printf 'Base image is ready: ubuntu. Rebuild? [y/N] '
    read -r response
    if [ "$response" != y ] && [ "$response" != Y ]; then
      printf '%s\n' 'Base image is ready: ubuntu'
      return 0
    fi
  fi

  fetch_iso ubuntu
  mkdir -p "${seed_path%/*}" "$VM_LOG_DIR"
  cloud-localds "$seed_path" "$VM_ROOT/data/ubuntu/user-data" "$VM_ROOT/data/ubuntu/meta-data"
  prepare_qemu_access
  remove_fedora_build_domain "$build_domain_name"
  virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$volume_name" "$(target_disk_size ubuntu)" --format qcow2; then
    rm -f "$seed_path"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Cannot create base volume: ubuntu' >&2
    return 1
  fi

  if ! virt-install \
    --connect qemu:///system \
    --name "$build_domain_name" \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$volume_name,format=qcow2,bus=virtio" \
    --disk "path=$seed_path,device=cdrom,readonly=on" \
    --location "$iso_path,kernel=casper/vmlinuz,initrd=casper/initrd" \
    --extra-args autoinstall \
    --boot uefi \
    --graphics none \
    --noautoconsole \
    --wait -1 2>&1 | tee "$log_path"; then
    rm -f "$seed_path"
    remove_fedora_build_domain "$build_domain_name"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf 'Image build failed: ubuntu. Log: %s\n' "$log_path" >&2
    return 1
  fi

  rm -f "$seed_path" "$log_path"
  remove_fedora_build_domain "$build_domain_name"
  printf '%s\n' 'Base image is ready: ubuntu'
}

build_fedora_guest() {
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local volume_name
  local build_domain_name="dot-v2-fedora-base-build"
  local log_path

  read_target fedora iso_name iso_url iso_sha256 || return $?
  volume_name="$(base_volume_name fedora)"
  iso_path="$VM_CACHE_DIR/iso/$iso_name"
  log_path="$VM_LOG_DIR/fedora-build.log"

  if base_volume_exists fedora; then
    if [ ! -t 0 ]; then
      printf 'Base image exists: fedora. Run build from a terminal to confirm rebuild.\n' >&2
      return 1
    fi
    printf 'Base image is ready: fedora. Rebuild? [y/N] '
    read -r response
    if [ "$response" != y ] && [ "$response" != Y ]; then
      printf '%s\n' 'Base image is ready: fedora'
      return 0
    fi
  fi

  fetch_iso fedora
  mkdir -p "$VM_LOG_DIR"
  remove_fedora_build_domain "$build_domain_name"
  virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$volume_name" "$(target_disk_size fedora)" --format qcow2; then
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Cannot create base volume: fedora' >&2
    return 1
  fi

  if ! virt-install \
    --connect qemu:///system \
    --name "$build_domain_name" \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$volume_name,format=qcow2,bus=virtio" \
    --location "$iso_path" \
    --initrd-inject "$VM_ROOT/data/fedora/kickstart.cfg" \
    --extra-args 'inst.ks=file:/kickstart.cfg inst.cmdline console=ttyS0' \
    --boot uefi \
    --graphics none \
    --noautoconsole \
    --wait -1 2>&1 | tee "$log_path"; then
    remove_fedora_build_domain "$build_domain_name"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf 'Image build failed: fedora. Log: %s\n' "$log_path" >&2
    return 1
  fi

  remove_fedora_build_domain "$build_domain_name"
  rm -f "$log_path"
  printf '%s\n' 'Base image is ready: fedora'
}

base_volume_name() {
  printf 'dot-v2-%s-base.qcow2' "$1"
}

test_volume_name() {
  printf 'dot-v2-%s-test.qcow2' "$1"
}

base_volume_exists() {
  virsh -c qemu:///system vol-info --pool "$VM_STORAGE_POOL" "$(base_volume_name "$1")" >/dev/null 2>&1
}

remove_fedora_build_domain() {
  local domain_name="$1"

  virsh -c qemu:///system destroy "$domain_name" >/dev/null 2>&1 || true
  virsh -c qemu:///system undefine "$domain_name" --nvram >/dev/null 2>&1 ||
    virsh -c qemu:///system undefine "$domain_name" >/dev/null 2>&1 || true
}

stop_guest() {
  if [ "$1" = fedora ]; then
    stop_fedora_guest
    return
  fi

  if [ "$1" = ubuntu ]; then
    stop_ubuntu_guest
    return
  fi

  printf 'Unsupported stop target: %s\n' "$1" >&2
  return 2
}

stop_fedora_guest() {
  local domain_name="dot-v2-fedora-test"
  local volume_name

  volume_name="$(test_volume_name fedora)"
  virsh -c qemu:///system destroy "$domain_name" >/dev/null 2>&1 || true
  virsh -c qemu:///system undefine "$domain_name" --nvram >/dev/null 2>&1 ||
    virsh -c qemu:///system undefine "$domain_name" >/dev/null 2>&1 || true
  if virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1; then
    printf '%s\n' 'Test guest stopped: fedora'
    return 0
  fi
  printf '%s\n' 'No test guest exists: fedora'
}

stop_ubuntu_guest() {
  local domain_name="dot-v2-ubuntu-test"
  local volume_name

  volume_name="$(test_volume_name ubuntu)"
  virsh -c qemu:///system destroy "$domain_name" >/dev/null 2>&1 || true
  virsh -c qemu:///system undefine "$domain_name" --nvram >/dev/null 2>&1 ||
    virsh -c qemu:///system undefine "$domain_name" >/dev/null 2>&1 || true
  if virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1; then
    printf '%s\n' 'Test guest stopped: ubuntu'
    return 0
  fi
  printf '%s\n' 'No test guest exists: ubuntu'
}

run_test_guest() {
  if [ "$1" = fedora ]; then
    run_fedora_test_guest
    return
  fi

  if [ "$1" = ubuntu ]; then
    run_ubuntu_test_guest
    return
  fi

  printf 'Unsupported run target: %s\n' "$1" >&2
  return 2
}

run_fedora_test_guest() {
  local base_volume
  local test_volume
  local log_path

  base_volume="$(base_volume_name fedora)"
  test_volume="$(test_volume_name fedora)"
  log_path="$VM_LOG_DIR/fedora-test.log"

  if ! base_volume_exists fedora; then
    printf '%s\n' 'Base image is not ready: fedora' >&2
    return 1
  fi
  if virsh -c qemu:///system vol-info --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1; then
    printf '%s\n' 'Test overlay already exists: fedora. Run stop first.' >&2
    return 1
  fi

  mkdir -p "$VM_LOG_DIR"
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$test_volume" "$(target_disk_size fedora)" \
    --format qcow2 --backing-vol "$base_volume" --backing-vol-format qcow2; then
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1 || true
    printf '%s\n' 'Cannot create test volume: fedora' >&2
    return 1
  fi
  if ! virt-install \
    --connect qemu:///system \
    --name dot-v2-fedora-test \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$test_volume,format=qcow2,bus=virtio" \
    --network network=default,model=virtio \
    --boot uefi \
    --os-variant detect=on,require=off \
    --graphics spice \
    --import \
    --noautoconsole >"$log_path" 2>&1; then
    virsh -c qemu:///system destroy dot-v2-fedora-test >/dev/null 2>&1 || true
    virsh -c qemu:///system undefine dot-v2-fedora-test --nvram >/dev/null 2>&1 || true
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1 || true
    printf 'Test guest failed: fedora. Log: %s\n' "$log_path" >&2
    return 1
  fi

  rm -f "$log_path"
  printf '%s\n' 'Test guest is running: fedora'
  virt-manager --connect qemu:///system --show-domain-console dot-v2-fedora-test >/dev/null 2>&1 &
}

run_ubuntu_test_guest() {
  local base_volume
  local test_volume
  local log_path

  base_volume="$(base_volume_name ubuntu)"
  test_volume="$(test_volume_name ubuntu)"
  log_path="$VM_LOG_DIR/ubuntu-test.log"

  if ! base_volume_exists ubuntu; then
    printf '%s\n' 'Base image is not ready: ubuntu' >&2
    return 1
  fi
  if virsh -c qemu:///system vol-info --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1; then
    printf '%s\n' 'Test overlay already exists: ubuntu. Run stop first.' >&2
    return 1
  fi

  mkdir -p "$VM_LOG_DIR"
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$test_volume" "$(target_disk_size ubuntu)" \
    --format qcow2 --backing-vol "$base_volume" --backing-vol-format qcow2; then
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1 || true
    printf '%s\n' 'Cannot create test volume: ubuntu' >&2
    return 1
  fi
  if ! virt-install \
    --connect qemu:///system \
    --name dot-v2-ubuntu-test \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$test_volume,format=qcow2,bus=virtio" \
    --network network=default,model=virtio \
    --boot uefi \
    --os-variant detect=on,require=off \
    --graphics spice \
    --import \
    --noautoconsole >"$log_path" 2>&1; then
    virsh -c qemu:///system destroy dot-v2-ubuntu-test >/dev/null 2>&1 || true
    virsh -c qemu:///system undefine dot-v2-ubuntu-test --nvram >/dev/null 2>&1 || true
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1 || true
    printf 'Test guest failed: ubuntu. Log: %s\n' "$log_path" >&2
    return 1
  fi

  rm -f "$log_path"
  printf '%s\n' 'Test guest is running: ubuntu'
  virt-manager --connect qemu:///system --show-domain-console dot-v2-ubuntu-test >/dev/null 2>&1 &
}

prepare_qemu_access() {
  local parent_path="${VM_CACHE_DIR%/*}"
  local qemu_uid

  qemu_uid="$(id -u qemu)"

  while [ -n "$parent_path" ] && [ "$parent_path" != / ]; do
    setfacl -m "u:$qemu_uid:--x" "$parent_path"
    if [ "$parent_path" = "$VM_USER_HOME" ]; then
      break
    fi
    parent_path="${parent_path%/*}"
  done
  setfacl -R -m "u:$qemu_uid:rwX" "$VM_CACHE_DIR"
}

target_disk_size() {
  jq -er --arg target "$1" '.targets[$target].disk_size' "$VM_TARGETS_CONFIG"
}

print_help() {
  cat <<'EOF'
Usage: v2/bin/vm <command> [target]

Create disposable virtual machines for dotfiles checks.

Commands:
  check [target]  Check host dependencies and libvirt access.
  fetch <target>  Download and verify the target ISO.
  build <target>  Create a stopped libvirt base image.
  run <target>    Boot and open a disposable test overlay.
  stop <target>   Remove the disposable test overlay.

Targets: fedora, ubuntu

Examples:
  v2/bin/vm check
  v2/bin/vm build fedora
  v2/bin/vm run fedora
  v2/bin/vm stop fedora

Fedora uses a Kickstart file during build.
Run build from a terminal to confirm replacement of a ready base image.
Run stop to discard the test overlay after each test.
EOF
}
