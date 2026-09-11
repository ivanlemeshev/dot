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
  for command in curl jq setfacl sha256sum qemu-img virt-install virt-manager; do
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

@test "stop force powers off the named guest" {
  stub_command virsh 'test "$1" = "-c" && test "$2" = "qemu:///system" && test "$3" = "destroy" && test "$4" = "dot-v2-fedora"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" /bin/bash "$VM" stop fedora

  [ "$status" -eq 0 ]
  [ "$output" = "Guest stopped: fedora" ]
}

@test "run creates a disposable test overlay" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/images/fedora.qcow2.ready"
  stub_command qemu-img ': >"${@: -1}"'
  stub_command virt-install 'exit 0'
  stub_command virsh 'exit 1'
  stub_command setfacl 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" run fedora

  [ "$status" -eq 0 ]
  [ "$output" = "Test guest is running: fedora" ]
  [ -f "$cache_dir/overlays/fedora.qcow2" ]
  rm -rf "$cache_dir"
}

@test "remove deletes a test overlay and preserves its base image" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images" "$cache_dir/overlays"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/images/fedora.qcow2.ready"
  : >"$cache_dir/overlays/fedora.qcow2"
  stub_command virsh 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" remove fedora

  [ "$status" -eq 0 ]
  [ "$output" = "Test guest removed: fedora" ]
  [ -f "$cache_dir/images/fedora.qcow2" ]
  [ -f "$cache_dir/images/fedora.qcow2.ready" ]
  [ ! -e "$cache_dir/overlays/fedora.qcow2" ]
  rm -rf "$cache_dir"
}

@test "open shows the guest graphical console" {
  stub_command virt-manager 'test "$1" = "--connect" && test "$2" = "qemu:///system" && test "$3" = "--show-domain-console" && test "$4" = "dot-v2-fedora"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" /bin/bash "$VM" open fedora

  [ "$status" -eq 0 ]
}

@test "Fedora target uses the official release filename" {
  run jq -r '.targets.fedora.iso.name' "$PROJECT_ROOT/v2/config/targets.json"

  [ "$status" -eq 0 ]
  [ "$output" = "Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso" ]
}

@test "Fedora target uses an install tree for unattended setup" {
  run jq -r '.targets.fedora.install_url' "$PROJECT_ROOT/v2/config/targets.json"

  [ "$status" -eq 0 ]
  [ "$output" = "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/" ]
}

@test "Fedora Kickstart does not use the removed install command" {
  run grep -Ex 'install' "$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"

  [ "$status" -eq 1 ]
}

@test "Fedora Kickstart does not require a CD-ROM source" {
  run grep -Ex 'cdrom' "$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"

  [ "$status" -eq 1 ]
}

@test "Fedora Kickstart selects the virtual disk and UTC" {
  kickstart="$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"

  grep -Fx 'timezone UTC --utc' "$kickstart"
  grep -Fx 'ignoredisk --only-use=vda' "$kickstart"
  grep -Fx 'clearpart --all --initlabel' "$kickstart"
}

@test "Fedora Kickstart starts the KDE graphical login" {
  kickstart="$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"

  grep -Fx 'graphical' "$kickstart"
  grep -Fx 'services --enabled=plasmalogin' "$kickstart"
  grep -Fx 'plasma-login-manager' "$kickstart"
  ! grep -Fx 'sddm' "$kickstart"
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

@test "rebuild replaces an incomplete base image" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'exit 0'
  stub_command virsh 'exit 0'
  stub_command setfacl 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" rebuild fedora

  rm -rf "$cache_dir"
  [ "$status" -eq 0 ]
  [ "$output" = $'ISO is ready: Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso\nBase image is ready: fedora' ]
}

@test "rebuild grants qemu access to the cache" {
  cache_dir="$(mktemp -d)"
  access_log="$cache_dir/access.log"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'exit 0'
  stub_command virsh 'exit 0'
  stub_command setfacl 'printf "%s\n" "$*" >>"$VM_ACCESS_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_ACCESS_LOG="$access_log" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" rebuild fedora

  [ "$status" -eq 0 ]
  grep -q -- 'u:qemu:rwX' "$access_log"
  rm -rf "$cache_dir"
}

@test "rebuild does not change ACLs above the user home directory" {
  test_home="$(mktemp -d)"
  cache_dir="$test_home/project/cache"
  access_log="$test_home/access.log"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'exit 0'
  stub_command virsh 'exit 0'
  stub_command setfacl 'printf "%s\n" "$*" >>"$VM_ACCESS_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_ACCESS_LOG="$access_log" VM_CACHE_DIR="$cache_dir" VM_USER_HOME="$test_home" /bin/bash "$VM" rebuild fedora

  [ "$status" -eq 0 ]
  grep -q -- "$test_home$" "$access_log"
  ! grep -q -- '/tmp$' "$access_log"
  rm -rf "$test_home"
}

@test "Fedora rebuild does not open an installer console" {
  cache_dir="$(mktemp -d)"
  virt_log="$cache_dir/virt-install.log"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'printf "%s\n" "$*" >"$VM_VIRT_LOG"'
  stub_command virsh 'exit 0'
  stub_command setfacl 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRT_LOG="$virt_log" /bin/bash "$VM" rebuild fedora

  [ "$status" -eq 0 ]
  grep -q -- '--noautoconsole' "$virt_log"
  ! grep -q -- '--autoconsole text' "$virt_log"
  rm -rf "$cache_dir"
}
