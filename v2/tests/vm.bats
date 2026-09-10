#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="${BATS_TEST_DIRNAME}/../.."
  VM="$PROJECT_ROOT/v2/bin/vm"
  STUB_BIN="$(mktemp -d)"
}

teardown() {
  rm -rf "$STUB_BIN"
}

stub_command() {
  local name="$1"
  local body="$2"

  printf '%s\n' '#!/usr/bin/env bash' "$body" >"$STUB_BIN/$name"
  chmod +x "$STUB_BIN/$name"
}

@test "check reports missing host dependencies" {
  run env PATH="$STUB_BIN" /bin/bash "$VM" check

  [ "$status" -eq 1 ]
  [[ "$output" == *"Missing host command: curl"* ]]
  [[ "$output" == *"Missing host command: virsh"* ]]
}

@test "check verifies the system libvirt connection" {
  for command in curl jq sha256sum qemu-img virt-install virt-manager; do
    stub_command "$command" 'exit 0'
  done
  stub_command virsh 'test "$1" = "-c" && test "$2" = "qemu:///system" && test "$3" = "uri"'

  run env PATH="$STUB_BIN:/bin" /bin/bash "$VM" check

  [ "$status" -eq 0 ]
  [ "$output" = "Host checks pass." ]
}

@test "fetch reuses a verified cached ISO" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command curl 'exit 99'
  stub_command sha256sum 'test "$1" = "--check" && exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" fetch fedora

  rm -rf "$cache_dir"
  [ "$status" -eq 0 ]
  [ "$output" = "ISO is ready: Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso" ]
}

@test "fetch rejects an unknown target" {
  run /bin/bash "$VM" fetch debian

  [ "$status" -eq 2 ]
  [ "$output" = "Unknown target: debian" ]
}

@test "Fedora target uses the official release filename" {
  run jq -r '.targets.fedora.iso.name' "$PROJECT_ROOT/v2/config/targets.json"

  [ "$status" -eq 0 ]
  [ "$output" = "Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso" ]
}

@test "build reuses a completed base image" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/images/fedora.qcow2.ready"

  run env VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build fedora

  rm -rf "$cache_dir"
  [ "$status" -eq 0 ]
  [ "$output" = "Base image is ready: fedora" ]
}
