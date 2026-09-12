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

stub_packer() {
  stub_command packer '
    printf "%s\\n" "$*" >>"$VM_PACKER_LOG"
    [ "$1" = build ] || exit 0
    for argument in "$@"; do
      case "$argument" in -only=qemu.*) target="${argument#-only=qemu.}" ;; esac
      case "$argument" in -var=output_directory=*) output_root="${argument#-var=output_directory=}" ;; esac
    done
    mkdir -p "$output_root/$target"
    : >"$output_root/$target/$target.qcow2"
  '
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

@test "check without a target requires Packer for remaining targets" {
  for command in curl jq sha256sum virt-install virt-manager qemu-img setfacl; do
    stub_command "$command" 'exit 0'
  done
  stub_command virsh 'test "$1" = "-c" && test "$2" = "qemu:///system" && test "$3" = "uri"'

  run env PATH="$STUB_BIN:/usr/bin" /bin/bash "$VM" check

  [ "$status" -eq 1 ]
  [ "$output" = "Missing host command: packer" ]
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

@test "build delegates the Windows image factory to Packer" {
  cache_dir="$(mktemp -d)"
  packer_log="$cache_dir/packer.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Windows_11_Enterprise_25H2_x64.iso"
  printf '%s\n' 'checksum' >"$cache_dir/iso/Windows_11_Enterprise_25H2_x64.iso.sha256"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_packer
  stub_command setfacl 'exit 0'
  stub_command virsh 'exit 1'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_PACKER_LOG="$packer_log" /bin/bash "$VM" build windows

  [ "$status" -eq 0 ]
  grep -q -- '-only=qemu.windows' "$packer_log"
  grep -q -- 'iso_checksum=checksum' "$packer_log"
  [ -f "$cache_dir/images/windows.qcow2" ]
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

@test "run uses Windows-compatible devices for its overlay" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  mkdir -p "$cache_dir/images"
  : >"$cache_dir/images/windows.qcow2"
  : >"$cache_dir/images/windows.qcow2.ready"
  stub_command qemu-img ': >"${@: -1}"'
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'
  stub_command virsh 'exit 1'
  stub_command setfacl 'exit 0'
  stub_command virt-manager 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" /bin/bash "$VM" run windows

  [ "$status" -eq 0 ]
  grep -q -- 'bus=sata' "$install_log"
  grep -q -- 'network=default,model=e1000' "$install_log"
  rm -rf "$cache_dir"
}

@test "Packer uses native unattended installers for all targets" {
  packer_file="$PROJECT_ROOT/v2/packer/images.pkr.hcl"

  grep -Fx 'source "qemu" "fedora" {' "$packer_file"
  grep -Fx 'source "qemu" "ubuntu" {' "$packer_file"
  grep -Fx 'source "qemu" "arch" {' "$packer_file"
  grep -Fx 'source "qemu" "windows" {' "$packer_file"
  grep -F 'Autounattend.xml' "$packer_file"
  grep -Fx '  disk_interface   = "sata"' "$packer_file"
  grep -Fx '  shutdown_timeout = "45m"' "$packer_file"
  grep -F '"c<wait>"' "$packer_file"
  grep -F 'linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=Fedora-E-dvd-x86_64-44' "$packer_file"
  grep -F 'initrd /images/pxeboot/initrd.img' "$packer_file"
  grep -F 'inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/fedora/kickstart.cfg' "$packer_file"
}
