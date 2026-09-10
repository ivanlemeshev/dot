#!/usr/bin/env bash

set -euo pipefail

readonly VM_REQUIRED_COMMANDS=(curl jq sha256sum qemu-img virt-install virt-manager virsh)
readonly VM_ROOT="$(cd "${BASH_SOURCE[0]%/*}/.." && pwd)"
readonly VM_CACHE_DIR="${VM_CACHE_DIR:-$VM_ROOT/.cache/vms}"
readonly VM_TARGETS_CONFIG="$VM_ROOT/config/targets.json"

main() {
  case "${1:-}" in
    check)
      check_host
      ;;
    fetch)
      fetch_iso "${2:-}"
      ;;
    build)
      build_guest "${2:-}"
      ;;
    rebuild)
      rebuild_guest "${2:-}"
      ;;
    open)
      open_guest "${2:-}"
      ;;
    *)
      print_usage >&2
      return 2
      ;;
  esac
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

  read_target "$target" iso_name iso_url iso_sha256 || return $?
  image_path="$VM_CACHE_DIR/images/$target.qcow2"
  ready_path="$image_path.ready"

  if [ -f "$image_path" ] && [ -f "$ready_path" ]; then
    printf 'Base image is ready: %s\n' "$target"
    return 0
  fi
  if [ -e "$image_path" ]; then
    printf 'Incomplete base image exists: %s. Run rebuild to replace it.\n' "$target" >&2
    return 1
  fi

  fetch_iso "$target"
  iso_path="$VM_CACHE_DIR/iso/$iso_name"
  disk_size="$(target_disk_size "$target")"
  mkdir -p "${image_path%/*}"
  qemu-img create -f qcow2 "$image_path" "$disk_size"

  if ! install_guest "$target" "$iso_path" "$image_path"; then
    printf 'Installation did not complete: %s\n' "$target" >&2
    return 1
  fi

  : >"$ready_path"
  printf 'Base image is ready: %s\n' "$target"
}

rebuild_guest() {
  local target="$1"
  local iso_name
  local iso_url
  local iso_sha256
  local image_path
  local ready_path
  local domain_name
  local domain_state

  read_target "$target" iso_name iso_url iso_sha256 || return $?
  image_path="$VM_CACHE_DIR/images/$target.qcow2"
  ready_path="$image_path.ready"
  domain_name="dot-v2-$target"
  domain_state="$(virsh -c qemu:///system domstate "$domain_name" 2>/dev/null || true)"

  if [ -n "$domain_state" ] && [ "$domain_state" != 'shut off' ]; then
    printf 'Guest must be shut off before rebuild: %s\n' "$target" >&2
    return 1
  fi

  if [ -n "$domain_state" ]; then
    virsh -c qemu:///system undefine "$domain_name" --nvram
  fi

  rm -f "$image_path" "$ready_path"
  build_guest "$target"
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
  local -a install_source=()
  local -a install_data=()
  local -a install_args=()

  case "$target" in
    fedora)
      install_source=(--location "$(target_install_url "$target")")
      install_data=(--initrd-inject "$VM_ROOT/data/fedora/kickstart.cfg")
      install_args=(--extra-args 'inst.ks=file:/kickstart.cfg')
      ;;
    ubuntu)
      install_source=(--location "$iso_path")
      install_data=(
        --initrd-inject "$VM_ROOT/data/ubuntu/user-data"
        --initrd-inject "$VM_ROOT/data/ubuntu/meta-data"
      )
      install_args=(--extra-args 'autoinstall ds=nocloud;s=file:///')
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
    --noautoconsole \
    --wait -1 \
    "${install_source[@]}" \
    "${install_data[@]}" \
    "${install_args[@]}"
}

open_guest() {
  local target="$1"
  local iso_name
  local iso_url
  local iso_sha256

  read_target "$target" iso_name iso_url iso_sha256 || return $?
  exec virt-manager --connect qemu:///system --show-domain "dot-v2-$target"
}

print_usage() {
  printf '%s\n' 'Usage: v2/bin/vm <check|fetch|build|rebuild|open> [target]'
}
