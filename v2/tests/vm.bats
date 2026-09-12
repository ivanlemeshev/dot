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
  printf '%s\n' '#!/usr/bin/env bash' "$2" >"$STUB_BIN/$1"
  chmod +x "$STUB_BIN/$1"
}

@test "help describes the direct libvirt image lifecycle" {
  run /bin/bash "$VM" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"build <target>  Create a stopped libvirt base image."* ]]
}

@test "check requires direct libvirt tools and system libvirt" {
  for command in curl jq sha256sum virt-install virt-manager; do
    stub_command "$command" 'exit 0'
  done
  stub_command virsh 'test "$1" = "-c" && test "$2" = "qemu:///system" && test "$3" = "uri"'

  run env PATH="$STUB_BIN:/usr/bin" /bin/bash "$VM" check fedora

  [ "$status" -eq 0 ]
  [ "$output" = "Host checks pass." ]
}

@test "check without a target requires the Ubuntu seed tool" {
  for command in curl jq sha256sum virt-install virt-manager setfacl; do
    stub_command "$command" 'exit 0'
  done
  stub_command virsh 'test "$1" = "-c" && test "$2" = "qemu:///system" && test "$3" = "uri"'

  run env PATH="$STUB_BIN:/usr/bin" /bin/bash "$VM" check

  [ "$status" -eq 1 ]
  [ "$output" = "Missing host command: cloud-localds" ]
}

@test "fetch reuses a verified cached ISO" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Fedora-Everything-netinst-x86_64-44-1.7.iso"
  stub_command curl 'exit 99'
  stub_command sha256sum 'test "$1" = "--check" && exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" fetch fedora

  [ "$status" -eq 0 ]
  [ "$output" = "ISO is ready: Fedora-Everything-netinst-x86_64-44-1.7.iso" ]
  rm -rf "$cache_dir"
}

@test "build creates a headless Fedora base with libvirt" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Fedora-Everything-netinst-x86_64-44-1.7.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"; printf "%s\\n" "installer status"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" /bin/bash "$VM" build fedora

  [ "$status" -eq 0 ]
  [[ "$output" == *"installer status"* ]]
  grep -q -- '--name dot-v2-fedora-base-build' "$install_log"
  grep -q -- "--location $cache_dir/iso/Fedora-Everything-netinst-x86_64-44-1.7.iso" "$install_log"
  grep -q -- '--initrd-inject .*/v2/data/fedora/kickstart.cfg' "$install_log"
  grep -q -- '--boot uefi' "$install_log"
  grep -q -- '--graphics none' "$install_log"
  rm -rf "$cache_dir"
}

@test "build removes a Fedora volume when libvirt cannot create it" {
  cache_dir="$(mktemp -d)"
  virsh_log="$cache_dir/virsh.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Fedora-Everything-netinst-x86_64-44-1.7.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    printf "%s\\n" "$*" >>"$VM_VIRSH_LOG"
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *"vol-create-as"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRSH_LOG="$virsh_log" /bin/bash "$VM" build fedora

  [ "$status" -eq 1 ]
  [[ "$output" == *"Cannot create base volume: fedora"* ]]
  grep -q -- 'vol-delete --pool default dot-v2-fedora-base.qcow2' "$virsh_log"
  rm -rf "$cache_dir"
}

@test "build creates an Ubuntu base with libvirt and a NoCloud seed" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  seed_log="$cache_dir/cloud-localds.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/ubuntu-26.04-desktop-amd64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command cloud-localds 'printf "%s\\n" "$*" >"$VM_SEED_LOG"; : >"$1"'
  stub_command id 'printf "%s\\n" 107'
  stub_command setfacl 'exit 0'
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" VM_SEED_LOG="$seed_log" /bin/bash "$VM" build ubuntu

  [ "$status" -eq 0 ]
  grep -q -- '--name dot-v2-ubuntu-base-build' "$install_log"
  grep -q -- "--location $cache_dir/iso/ubuntu-26.04-desktop-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd" "$install_log"
  grep -q -- '--extra-args autoinstall' "$install_log"
  grep -q -- "$cache_dir/seeds/ubuntu.iso .*data/ubuntu/user-data .*data/ubuntu/meta-data" "$seed_log"
  rm -rf "$cache_dir"
}

@test "run creates a UEFI Fedora overlay from the managed base" {
  cache_dir="$(mktemp -d)"
  manager_log="$cache_dir/virt-manager.log"
  install_log="$cache_dir/virt-install.log"
  stub_command virsh '
    case "$*" in
      *"vol-info"*"dot-v2-fedora-base.qcow2"*) exit 0 ;;
      *"vol-info"*) exit 1 ;;
      *"domstate"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'
  stub_command virt-manager 'printf "%s\\n" "$*" >"$VM_MANAGER_LOG"; sleep 2'

  run timeout 1 env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_MANAGER_LOG="$manager_log" VM_INSTALL_LOG="$install_log" /bin/bash "$VM" run fedora

  [ "$status" -eq 0 ]
  grep -q -- 'vol=default/dot-v2-fedora-test.qcow2,format=qcow2,bus=virtio' "$install_log"
  grep -q -- '--boot uefi' "$install_log"
  [ "$(<"$manager_log")" = "--connect qemu:///system --show-domain-console dot-v2-fedora-test" ]
  rm -rf "$cache_dir"
}

@test "stop removes the managed Fedora overlay" {
  cache_dir="$(mktemp -d)"
  virsh_log="$cache_dir/virsh.log"
  stub_command virsh 'printf "%s\\n" "$*" >>"$VM_VIRSH_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRSH_LOG="$virsh_log" /bin/bash "$VM" stop fedora

  [ "$status" -eq 0 ]
  [ "$output" = "Test guest stopped: fedora" ]
  grep -q -- 'undefine dot-v2-fedora-test --nvram' "$virsh_log"
  grep -q -- 'vol-delete --pool default dot-v2-fedora-test.qcow2' "$virsh_log"
  rm -rf "$cache_dir"
}

@test "run creates a UEFI Ubuntu overlay from the managed base" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  stub_command virsh '
    case "$*" in
      *"vol-info"*"dot-v2-ubuntu-base.qcow2"*) exit 0 ;;
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'
  stub_command virt-manager 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" /bin/bash "$VM" run ubuntu

  [ "$status" -eq 0 ]
  grep -q -- 'vol=default/dot-v2-ubuntu-test.qcow2,format=qcow2,bus=virtio' "$install_log"
  grep -q -- '--boot uefi' "$install_log"
  rm -rf "$cache_dir"
}

@test "Ubuntu and Fedora install data creates the test account" {
  grep -Fx '    username: tester' "$PROJECT_ROOT/v2/data/ubuntu/user-data"
  grep -Fx 'user --name=tester --password=tester --groups=wheel' "$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"
}
