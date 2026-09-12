#!/usr/bin/env bash

set -euo pipefail

readonly VM_REQUIRED_COMMANDS=(curl jq setfacl sha256sum qemu-img virt-install virt-manager virsh)
readonly VM_ROOT="$(cd "${BASH_SOURCE[0]%/*}/.." && pwd)"
readonly VM_CACHE_DIR="${VM_CACHE_DIR:-$VM_ROOT/.cache/vms}"
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

  if [ "$target" = windows ]; then
    verify_windows_iso "$iso_path"
    return $?
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

verify_windows_iso() {
  local iso_path="$1"
  local checksum_path="$iso_path.sha256"

  if [ ! -f "$iso_path" ] || [ ! -f "$checksum_path" ]; then
    printf '%s\n' "Download the Windows ISO from $(target_iso_url windows)." >&2
    printf 'Rename it to %s and save its official SHA-256 in %s.\n' "${iso_path##*/}" "$checksum_path" >&2
    return 1
  fi
  verify_iso "$iso_path" "$(<"$checksum_path")"
  printf 'ISO is ready: %s\n' "${iso_path##*/}"
}

build_guest() {
  local target="$1"
  local iso_name
  local iso_url
  local iso_sha256
  local iso_path
  local image_path
  local ready_path
  local disk_size
  local install_log_path

  read_target "$target" iso_name iso_url iso_sha256 || return $?
  image_path="$VM_CACHE_DIR/images/$target.qcow2"
  ready_path="$image_path.ready"
  install_log_path="$VM_CACHE_DIR/logs/$target-install.log"

  if [ -f "$image_path" ] && [ -f "$ready_path" ]; then
    if [ ! -t 0 ]; then
      printf 'Base image exists: %s. Run build from a terminal to confirm rebuild.\n' "$target" >&2
      return 1
    fi
    printf 'Base image is ready: %s. Rebuild? [y/N] ' "$target"
    read -r response
    if [ "$response" != y ] && [ "$response" != Y ]; then
      printf 'Base image is ready: %s\n' "$target"
      return 0
    fi
  fi

  replace_base_guest "$target" "$image_path" "$ready_path"

  fetch_iso "$target"
  iso_path="$VM_CACHE_DIR/iso/$iso_name"
  disk_size="$(target_disk_size "$target")"
  mkdir -p "${image_path%/*}" "${install_log_path%/*}"
  : >"$install_log_path"
  qemu-img create -f qcow2 "$image_path" "$disk_size"
  prepare_qemu_access

  if ! run_guest_install "$target" "$iso_path" "$image_path" "$install_log_path"; then
    remove_base_guest "$target" "$image_path" "$ready_path"
    printf 'Installation failed: %s. See %s\n' "$target" "$install_log_path" >&2
    return 1
  fi

  stop_base_guest "$target"
  : >"$ready_path"
  printf 'Base image is ready: %s\n' "$target"
}

replace_base_guest() {
  local target="$1"
  local image_path="$2"
  local ready_path="$3"

  remove_base_guest "$target" "$image_path" "$ready_path"
}

remove_base_guest() {
  local target="$1"
  local image_path="$2"
  local ready_path="$3"
  local domain_name="dot-v2-$target"

  if virsh -c qemu:///system domstate "$domain_name" >/dev/null 2>&1; then
    virsh -c qemu:///system destroy "$domain_name" >/dev/null 2>&1 || true
    virsh -c qemu:///system undefine "$domain_name" --nvram >/dev/null 2>&1 || \
      virsh -c qemu:///system undefine "$domain_name" >/dev/null 2>&1 || true
  fi

  rm -f "$image_path" "$ready_path"
}

stop_base_guest() {
  virsh -c qemu:///system destroy "dot-v2-$1" >/dev/null 2>&1 || true
}

stop_guest() {
  local target="$1"
  local iso_name
  local iso_url
  local iso_sha256
  local test_domain_name
  local test_image_path

  read_target "$target" iso_name iso_url iso_sha256 || return $?
  test_domain_name="dot-v2-$target-test"
  test_image_path="$VM_CACHE_DIR/overlays/$target.qcow2"

  if ! virsh -c qemu:///system domstate "$test_domain_name" >/dev/null 2>&1 && [ ! -e "$test_image_path" ]; then
    printf 'No test guest exists: %s\n' "$target"
    return 0
  fi
  virsh -c qemu:///system destroy "$test_domain_name" >/dev/null 2>&1 || true
  virsh -c qemu:///system undefine "$test_domain_name" --nvram >/dev/null 2>&1 || \
    virsh -c qemu:///system undefine "$test_domain_name" >/dev/null 2>&1 || true
  rm -f "$test_image_path"
  printf 'Test guest stopped: %s\n' "$target"
}

run_test_guest() {
  local target="$1"
  local iso_name
  local iso_url
  local iso_sha256
  local base_image_path
  local base_ready_path
  local test_image_path
  local base_domain_state

  read_target "$target" iso_name iso_url iso_sha256 || return $?
  base_image_path="$VM_CACHE_DIR/images/$target.qcow2"
  base_ready_path="$base_image_path.ready"
  test_image_path="$VM_CACHE_DIR/overlays/$target.qcow2"
  base_domain_state="$(virsh -c qemu:///system domstate "dot-v2-$target" 2>/dev/null || true)"

  if [ ! -f "$base_image_path" ] || [ ! -f "$base_ready_path" ]; then
    printf 'Base image is not ready: %s\n' "$target" >&2
    return 1
  fi
  if [ -n "$base_domain_state" ] && [ "$base_domain_state" != 'shut off' ]; then
    printf 'Base guest must be shut off before run: %s\n' "$target" >&2
    return 1
  fi
  if [ -e "$test_image_path" ]; then
    printf 'Test overlay already exists: %s. Run stop first.\n' "$target" >&2
    return 1
  fi

  mkdir -p "${test_image_path%/*}"
  qemu-img create -f qcow2 -F qcow2 -b "$base_image_path" "$test_image_path"
  prepare_qemu_access
  virt-install \
    --connect qemu:///system \
    --name "dot-v2-$target-test" \
    --memory 4096 \
    --vcpus 2 \
    --disk "path=$test_image_path,format=qcow2,bus=virtio" \
    --network network=default \
    --os-variant detect=on,require=off \
    --graphics spice \
    --import \
    --noautoconsole
  printf 'Test guest is running: %s\n' "$target"
  exec virt-manager --connect qemu:///system --show-domain-console "dot-v2-$target-test"
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

target_iso_url() {
  jq -er --arg target "$1" '.targets[$target].iso.url' "$VM_TARGETS_CONFIG"
}

target_install_url() {
  jq -er --arg target "$1" '.targets[$target].install_url' "$VM_TARGETS_CONFIG"
}

install_guest() {
  local target="$1"
  local iso_path="$2"
  local image_path="$3"
  local install_log_path="$4"
  local -a console_options=(--noautoconsole)
  local -a install_source=()
  local -a install_data=()
  local -a install_args=()
  local -a serial_options=()

  case "$target" in
    fedora)
      install_source=(--location "$(target_install_url "$target")")
      install_data=(--initrd-inject "$VM_ROOT/data/fedora/kickstart.cfg")
      install_args=(--noreboot --extra-args "console=ttyS0 inst.cmdline inst.repo=$(target_install_url "$target") inst.ks=file:/kickstart.cfg")
      serial_options=(--serial pty)
      ;;
    ubuntu)
      install_source=(--location "$iso_path,kernel=casper/vmlinuz,initrd=casper/initrd")
      install_data=(
        --initrd-inject "$VM_ROOT/data/ubuntu/user-data"
        --initrd-inject "$VM_ROOT/data/ubuntu/meta-data"
      )
      install_args=(--extra-args 'autoinstall ds=nocloud;s=file:/// console=ttyS0')
      serial_options=(--serial pty)
      ;;
    arch)
      install_source=(--location "$iso_path")
      ;;
    windows)
      install_source=(--cdrom "$iso_path")
      install_args=(--boot uefi,loader_secure=yes --tpm backend.type=emulator,backend.version=2.0,model=tpm-crb)
      ;;
  esac

  virt-install \
    --connect qemu:///system \
    --name "dot-v2-$target" \
    --memory 4096 \
    --vcpus 2 \
    --disk "path=$image_path,format=qcow2,bus=virtio" \
    --network network=default \
    --os-variant detect=on,require=off \
    --graphics spice \
    "${console_options[@]}" \
    "${serial_options[@]}" \
    --wait -1 \
    "${install_source[@]}" \
    "${install_data[@]}" \
    "${install_args[@]}"
}

run_guest_install() {
  local target="$1"
  local iso_path="$2"
  local image_path="$3"
  local install_log_path="$4"
  local install_pid
  local log_pid
  local install_status
  local domain_name

  if [ "$target" != fedora ] && [ "$target" != ubuntu ]; then
    install_guest "$target" "$iso_path" "$image_path" "$install_log_path"
    return $?
  fi

  install_guest "$target" "$iso_path" "$image_path" "$install_log_path" &
  install_pid=$!
  domain_name="dot-v2-$target"

  while ! virsh -c qemu:///system domstate "$domain_name" >/dev/null 2>&1; do
    if ! kill -0 "$install_pid" 2>/dev/null; then
      break
    fi
    sleep 1
  done
  if virsh -c qemu:///system domstate "$domain_name" >/dev/null 2>&1; then
    virsh -c qemu:///system console "$domain_name" --force >"$install_log_path" 2>&1 &
    log_pid=$!
  fi

  if wait "$install_pid"; then
    install_status=0
  else
    install_status=$?
  fi
  if [ -n "${log_pid:-}" ]; then
    kill "$log_pid" 2>/dev/null || true
    wait "$log_pid" || true
  fi
  return "$install_status"
}

print_help() {
  cat <<'EOF'
Usage: v2/bin/vm <command> [target]

Create disposable virtual machines for dotfiles checks.

Commands:
  check           Check host dependencies and libvirt access.
  fetch <target>  Download and verify the target ISO.
  build <target>  Create a stopped base image.
  run <target>    Boot and open a disposable test overlay.
  stop <target>   Remove the disposable test overlay.

Targets: fedora, ubuntu, arch, windows

Examples:
  v2/bin/vm check
  v2/bin/vm build fedora
  v2/bin/vm run fedora
  v2/bin/vm stop fedora

Run build from a terminal to confirm replacement of a ready base image.
Run stop to discard the test overlay after each test.
EOF
}
