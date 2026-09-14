#!/usr/bin/env bash

set -euo pipefail

readonly VM_REQUIRED_COMMANDS=(curl jq sha256sum virt-install virt-manager virsh)
VM_ROOT="$(cd "${BASH_SOURCE[0]%/*}/.." && pwd)"
readonly VM_ROOT
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

  if [ -z "$target" ] || [ "$target" = arch ] || [ "$target" = ubuntu ]; then
    for command in cloud-localds getfacl setfacl; do
      if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Missing host command: %s\n' "$command" >&2
        has_missing_command=true
      fi
    done
  fi

  if "$has_missing_command"; then
    return 1
  fi

  if [ "$target" = windows ]; then
    if ! command -v xorriso >/dev/null 2>&1; then
      printf '%s\n' 'Missing host command: xorriso' >&2
      return 1
    fi
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

  if [ -z "$iso_sha256" ]; then
    if [ -f "$iso_path" ]; then
      printf 'ISO is ready without checksum: %s\n' "$iso_name"
      return 0
    fi
    printf 'Windows ISO must be downloaded manually: %s\n' "$iso_url" >&2
    return 1
  fi

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

  IFS=$'\t' read -r "$2" "$3" "$4" <<<"$values"
}

verify_iso() {
  local iso_path="$1"
  local expected_sha256="$2"

  printf '%s  %s\n' "$expected_sha256" "${iso_path##*/}" | (
    cd "${iso_path%/*}"
    sha256sum --check --status -
  )
}

format_duration() {
  local total_seconds="$1"
  local hours=$((total_seconds / 3600))
  local minutes=$(((total_seconds % 3600) / 60))
  local seconds=$((total_seconds % 60))

  if [ "$hours" -gt 0 ]; then
    printf '%dh %02dm %02ds' "$hours" "$minutes" "$seconds"
  elif [ "$minutes" -gt 0 ]; then
    printf '%dm %02ds' "$minutes" "$seconds"
  else
    printf '%ds' "$seconds"
  fi
}

build_guest() {
  local target="$1"
  local start_seconds=$SECONDS
  local status

  case "$target" in
    arch)
      if build_arch_guest; then status=0; else status=$?; fi
      ;;
    windows)
      if build_windows_guest; then status=0; else status=$?; fi
      ;;
    fedora)
      if build_fedora_guest; then status=0; else status=$?; fi
      ;;
    ubuntu)
      if build_ubuntu_guest; then status=0; else status=$?; fi
      ;;
    *) printf 'Unsupported build target: %s\n' "$1" >&2; return 2 ;;
  esac

  if [ "$status" -eq 0 ]; then
    printf 'Build completed: %s in %s\n' "$target" "$(format_duration "$((SECONDS - start_seconds))")"
    return 0
  fi

  printf 'Build failed: %s after %s\n' "$target" "$(format_duration "$((SECONDS - start_seconds))")" >&2
  return "$status"
}

build_windows_guest() {
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local volume_name
  local seed_path="$VM_CACHE_DIR/seeds/windows.iso"
  local unattend_path="$VM_CACHE_DIR/scripts/Autounattend.xml"
  local build_domain_name="dot-v2-windows-base-build"
  local install_pid

  require_windows_build_commands || return $?
  read_target windows iso_name iso_url iso_sha256 || return $?
  volume_name="$(base_volume_name windows)"
  iso_path="$VM_CACHE_DIR/iso/$iso_name"

  if base_volume_exists windows; then
    if [ ! -t 0 ]; then
      printf 'Base image exists: windows. Run build from a terminal to confirm rebuild.\n' >&2
      return 1
    fi
    printf 'Base image is ready: windows. Rebuild? [y/N] '
    read -r response
    if [ "$response" != y ] && [ "$response" != Y ]; then
      printf '%s\n' 'Base image is ready: windows'
      return 0
    fi
  fi

  fetch_iso windows
  mkdir -p "${seed_path%/*}" "${unattend_path%/*}"
  cp "$VM_ROOT/data/windows/Autounattend.xml" "$unattend_path"
  xorriso -as mkisofs -o "$seed_path" -J -r -graft-points "Autounattend.xml=$unattend_path"
  prepare_qemu_access "$iso_path" "$seed_path"
  remove_build_domain "$build_domain_name"
  virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$volume_name" "$(target_disk_size windows)" --format qcow2; then
    rm -f "$seed_path" "$unattend_path"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Cannot create base volume: windows' >&2
    return 1
  fi

  virt-install \
    --connect qemu:///system \
    --name "$build_domain_name" \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$volume_name,format=qcow2,bus=sata" \
    --disk "path=$iso_path,device=cdrom,bus=sata,readonly=on" \
    --disk "path=$seed_path,device=cdrom,bus=sata,readonly=on" \
    --network network=default,model=e1000 \
    --boot uefi,cdrom \
    --os-variant detect=on,require=off \
    --events on_poweroff=destroy,on_reboot=destroy \
    --transient \
    --graphics spice \
    --noautoconsole \
    --wait -1 &
  install_pid=$!
  send_windows_boot_keys "$build_domain_name"
  virt-manager --connect qemu:///system --show-domain-console "$build_domain_name" >/dev/null 2>&1 &
  if ! wait "$install_pid"; then
    rm -f "$seed_path" "$unattend_path"
    remove_build_domain "$build_domain_name"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Image build failed: windows' >&2
    return 1
  fi

  rm -f "$seed_path" "$unattend_path"
  remove_build_domain "$build_domain_name"
  printf '%s\n' 'Base image is ready: windows'
}

send_windows_boot_keys() {
  local domain_name="$1"
  local attempts=0

  while [ "$attempts" -lt 3 ]; do
    sleep 2
    virsh -c qemu:///system send-key "$domain_name" KEY_ENTER >/dev/null 2>&1 || true
    attempts=$((attempts + 1))
  done
}

require_windows_build_commands() {
  if ! command -v xorriso >/dev/null 2>&1; then
    printf '%s\n' 'Missing host command: xorriso' >&2
    return 1
  fi
}

build_arch_guest() {
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local volume_name
  local seed_path="$VM_CACHE_DIR/seeds/arch.iso"
  local install_path="$VM_CACHE_DIR/scripts/arch-install.sh"
  local build_domain_name="dot-v2-arch-base-build"

  require_arch_build_commands || return $?
  read_target arch iso_name iso_url iso_sha256 || return $?
  volume_name="$(base_volume_name arch)"
  iso_path="$VM_CACHE_DIR/iso/$iso_name"

  if base_volume_exists arch; then
    if [ ! -t 0 ]; then
      printf 'Base image exists: arch. Run build from a terminal to confirm rebuild.\n' >&2
      return 1
    fi
    printf 'Base image is ready: arch. Rebuild? [y/N] '
    read -r response
    if [ "$response" != y ] && [ "$response" != Y ]; then
      printf '%s\n' 'Base image is ready: arch'
      return 0
    fi
  fi

  fetch_iso arch
  mkdir -p "${seed_path%/*}" "${install_path%/*}"
  cloud-localds "$seed_path" "$VM_ROOT/data/arch/user-data" "$VM_ROOT/data/arch/meta-data"
  cp "$VM_ROOT/data/arch/install.sh" "$install_path"
  prepare_qemu_access "$iso_path" "$seed_path" "$install_path"
  remove_build_domain "$build_domain_name"
  virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$volume_name" "$(target_disk_size arch)" --format qcow2; then
    rm -f "$seed_path"
    rm -f "$install_path"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Cannot create base volume: arch' >&2
    return 1
  fi

  if ! virt-install \
    --connect qemu:///system \
    --name "$build_domain_name" \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$volume_name,format=qcow2,bus=virtio" \
    --disk "path=$iso_path,device=cdrom,bus=sata,readonly=on" \
    --disk "path=$seed_path,device=cdrom,bus=sata,readonly=on" \
    --disk "path=$install_path,device=disk,bus=virtio,readonly=on" \
    --location "$iso_path,kernel=/arch/boot/x86_64/vmlinuz-linux,initrd=/arch/boot/x86_64/initramfs-linux.img" \
    --extra-args 'console=ttyS0 archisobasedir=arch archisodevice=/dev/sr0' \
    --boot uefi \
    --os-variant detect=on,require=off \
    --events on_poweroff=destroy,on_reboot=destroy \
    --transient \
    --graphics none \
    --autoconsole text \
    --wait -1; then
    rm -f "$seed_path"
    rm -f "$install_path"
    remove_build_domain "$build_domain_name"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Image build failed: arch' >&2
    return 1
  fi

  rm -f "$seed_path"
  rm -f "$install_path"
  remove_build_domain "$build_domain_name"
  printf '%s\n' 'Base image is ready: arch'
}

require_arch_build_commands() {
  if ! command -v cloud-localds >/dev/null 2>&1; then
    printf '%s\n' 'Missing host command: cloud-localds. Install cloud-utils-cloud-localds on Fedora or cloud-image-utils on Ubuntu.' >&2
    return 1
  fi
  if ! command -v getfacl >/dev/null 2>&1; then
    printf '%s\n' 'Missing host command: getfacl. Install acl.' >&2
    return 1
  fi
  if ! command -v setfacl >/dev/null 2>&1; then
    printf '%s\n' 'Missing host command: setfacl. Install acl.' >&2
    return 1
  fi
}

build_ubuntu_guest() {
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local volume_name
  local seed_path="$VM_CACHE_DIR/seeds/ubuntu.iso"
  local build_domain_name="dot-v2-ubuntu-base-build"
  local installer_log

  require_ubuntu_build_commands || return $?
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
  mkdir -p "${seed_path%/*}"
  cloud-localds "$seed_path" "$VM_ROOT/data/ubuntu/user-data" "$VM_ROOT/data/ubuntu/meta-data"
  prepare_qemu_access "$iso_path" "$seed_path"
  remove_build_domain "$build_domain_name"
  virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$volume_name" "$(target_disk_size ubuntu)" --format qcow2; then
    rm -f "$seed_path"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Cannot create base volume: ubuntu' >&2
    return 1
  fi

  mkdir -p "$VM_LOG_DIR"
  installer_log="$(mktemp "$VM_LOG_DIR/ubuntu-build.XXXXXX")"
  if ! virt-install \
    --connect qemu:///system \
    --name "$build_domain_name" \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$volume_name,format=qcow2,bus=virtio" \
    --disk "path=$iso_path,device=cdrom,bus=sata,readonly=on" \
    --disk "path=$seed_path,device=disk,bus=virtio,readonly=on" \
    --location "$iso_path,kernel=casper/vmlinuz,initrd=casper/initrd" \
    --extra-args 'autoinstall console=ttyS0' \
    --boot uefi \
    --os-variant detect=on,require=off \
    --events on_poweroff=destroy,on_reboot=destroy \
    --transient \
    --graphics none \
    --autoconsole text \
    --wait -1 2>&1 | tee "$installer_log"; then
    rm -f "$installer_log"
    rm -f "$seed_path"
    remove_build_domain "$build_domain_name"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Image build failed: ubuntu' >&2
    return 1
  fi

  if grep -Fq 'Installation aborted at user request' "$installer_log"; then
    rm -f "$installer_log"
    rm -f "$seed_path"
    remove_build_domain "$build_domain_name"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Image build failed: ubuntu' >&2
    return 1
  fi

  rm -f "$installer_log"
  rm -f "$seed_path"
  remove_build_domain "$build_domain_name"
  printf '%s\n' 'Base image is ready: ubuntu'
}

require_ubuntu_build_commands() {
  if ! command -v cloud-localds >/dev/null 2>&1; then
    printf '%s\n' 'Missing host command: cloud-localds. Install cloud-utils-cloud-localds on Fedora or cloud-image-utils on Ubuntu.' >&2
    return 1
  fi
  if ! command -v getfacl >/dev/null 2>&1; then
    printf '%s\n' 'Missing host command: getfacl. Install acl.' >&2
    return 1
  fi
  if ! command -v setfacl >/dev/null 2>&1; then
    printf '%s\n' 'Missing host command: setfacl. Install acl.' >&2
    return 1
  fi
}

build_fedora_guest() {
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local volume_name
  local build_domain_name="dot-v2-fedora-base-build"

  read_target fedora iso_name iso_url iso_sha256 || return $?
  volume_name="$(base_volume_name fedora)"
  iso_path="$VM_CACHE_DIR/iso/$iso_name"

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
  remove_build_domain "$build_domain_name"
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
    --events on_poweroff=destroy,on_reboot=destroy \
    --transient \
    --graphics none \
    --autoconsole text \
    --wait -1; then
    remove_build_domain "$build_domain_name"
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1 || true
    printf '%s\n' 'Image build failed: fedora' >&2
    return 1
  fi

  remove_build_domain "$build_domain_name"
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

remove_build_domain() {
  local domain_name="$1"

  virsh -c qemu:///system destroy "$domain_name" >/dev/null 2>&1 || true
  virsh -c qemu:///system undefine "$domain_name" --nvram >/dev/null 2>&1 ||
    virsh -c qemu:///system undefine "$domain_name" >/dev/null 2>&1 || true
}

stop_guest() {
  if [ "$1" = arch ]; then
    stop_arch_guest
    return
  fi

  if [ "$1" = windows ]; then
    stop_windows_guest
    return
  fi

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

stop_arch_guest() {
  stop_target_guest arch
}

stop_windows_guest() {
  stop_target_guest windows
}

stop_fedora_guest() {
  stop_target_guest fedora
}

stop_ubuntu_guest() {
  stop_target_guest ubuntu
}

stop_target_guest() {
  local target="$1"
  local domain_name="dot-v2-$target-test"
  local volume_name

  volume_name="$(test_volume_name "$target")"
  virsh -c qemu:///system destroy "$domain_name" >/dev/null 2>&1 || true
  virsh -c qemu:///system undefine "$domain_name" --nvram >/dev/null 2>&1 ||
    virsh -c qemu:///system undefine "$domain_name" >/dev/null 2>&1 || true
  if virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$volume_name" >/dev/null 2>&1; then
    printf 'Test guest stopped: %s\n' "$target"
    return 0
  fi
  printf 'No test guest exists: %s\n' "$target"
}

run_test_guest() {
  if [ "$1" = arch ]; then
    run_arch_test_guest
    return
  fi

  if [ "$1" = windows ]; then
    run_windows_test_guest
    return
  fi

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

run_arch_test_guest() {
  run_target_test_guest arch
}

run_windows_test_guest() {
  run_target_test_guest windows
}

run_fedora_test_guest() {
  run_target_test_guest fedora
}

run_ubuntu_test_guest() {
  run_target_test_guest ubuntu
}

run_target_test_guest() {
  local target="$1"
  local base_volume
  local test_volume
  local log_path
  local disk_bus=virtio
  local network_model=virtio
  local -a video_args=()
  local -a graphics_args=(--graphics spice)

  base_volume="$(base_volume_name "$target")"
  test_volume="$(test_volume_name "$target")"
  log_path="$VM_LOG_DIR/$target-test.log"

  if [ "$target" = arch ]; then
    video_args=(--video virtio,accel3d=yes)
    graphics_args=(--graphics spice,gl=on)
  fi

  if [ "$target" = windows ]; then
    disk_bus=sata
    network_model=e1000
  fi

  if ! base_volume_exists "$target"; then
    printf 'Base image is not ready: %s\n' "$target" >&2
    return 1
  fi
  if virsh -c qemu:///system vol-info --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1; then
    printf 'Test overlay already exists: %s. Run stop first.\n' "$target" >&2
    return 1
  fi

  mkdir -p "$VM_LOG_DIR"
  if ! virsh -c qemu:///system vol-create-as "$VM_STORAGE_POOL" "$test_volume" "$(target_disk_size "$target")" \
    --format qcow2 --backing-vol "$base_volume" --backing-vol-format qcow2; then
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1 || true
    printf 'Cannot create test volume: %s\n' "$target" >&2
    return 1
  fi
  if ! virt-install \
    --connect qemu:///system \
    --name "dot-v2-$target-test" \
    --memory 4096 \
    --vcpus 2 \
    --disk "vol=$VM_STORAGE_POOL/$test_volume,format=qcow2,bus=$disk_bus" \
    --network "network=default,model=$network_model" \
    --boot uefi \
    --os-variant detect=on,require=off \
    "${graphics_args[@]}" \
    "${video_args[@]}" \
    --import \
    --noautoconsole >"$log_path" 2>&1; then
    virsh -c qemu:///system destroy "dot-v2-$target-test" >/dev/null 2>&1 || true
    virsh -c qemu:///system undefine "dot-v2-$target-test" --nvram >/dev/null 2>&1 || true
    virsh -c qemu:///system vol-delete --pool "$VM_STORAGE_POOL" "$test_volume" >/dev/null 2>&1 || true
    printf 'Test guest failed: %s. Log: %s\n' "$target" "$log_path" >&2
    return 1
  fi

  rm -f "$log_path"
  printf 'Test guest is running: %s\n' "$target"
  virt-manager --connect qemu:///system --show-domain-console "dot-v2-$target-test" >/dev/null 2>&1 &
}

prepare_qemu_access() {
  local file_path
  local parent_path
  local qemu_uid

  qemu_uid="$(id -u qemu)"

  for file_path in "$@"; do
    parent_path="${file_path%/*}"
    while [ -n "$parent_path" ] && [ "$parent_path" != / ]; do
      setfacl -m "u:$qemu_uid:--x" "$parent_path"
      if [ "$parent_path" = "$VM_USER_HOME" ]; then
        break
      fi
      parent_path="${parent_path%/*}"
    done
    if ! getfacl --absolute-names --omit-header "$file_path" | grep -Eq '^other::r'; then
      setfacl -m "u:$qemu_uid:r--" "$file_path"
    fi
  done
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

Targets: arch, fedora, ubuntu, windows

Examples:
  v2/bin/vm check
  v2/bin/vm build arch
  v2/bin/vm build windows
  v2/bin/vm build fedora
  v2/bin/vm run fedora
  v2/bin/vm stop fedora

Fedora uses a Kickstart file during build.
Run build from a terminal to confirm replacement of a ready base image.
Run stop to discard the test overlay after each test.
EOF
}
