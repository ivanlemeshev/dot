#!/usr/bin/env bats
# shellcheck disable=SC2016

bats_require_minimum_version 1.5.0

setup() {
  PROJECT_ROOT="${BATS_TEST_DIRNAME}/../.."
  VM="$PROJECT_ROOT/v2/bin/vm"
  STUB_BIN="$(mktemp -d)"
}

teardown() {
  rm -rf "$STUB_BIN"
}

stub_command() {
  printf '%s\n' '#!/bin/bash' "$2" >"$STUB_BIN/$1"
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
  for command in curl jq sha256sum virt-install virt-manager getfacl setfacl; do
    stub_command "$command" 'exit 0'
  done
  stub_command virsh 'test "$1" = "-c" && test "$2" = "qemu:///system" && test "$3" = "uri"'

  run env PATH="$STUB_BIN" /bin/bash "$VM" check

  [ "$status" -eq 1 ]
  [ "$output" = "Missing host command: cloud-localds" ]
}

@test "check Windows requires the unattended CD tool" {
  for command in curl jq sha256sum virt-install virt-manager cloud-localds getfacl setfacl; do
    stub_command "$command" 'exit 0'
  done
  stub_command virsh 'test "$1" = "-c" && test "$2" = "qemu:///system" && test "$3" = "uri"'

  run env PATH="$STUB_BIN" /bin/bash "$VM" check windows

  [ "$status" -eq 1 ]
  [ "$output" = "Missing host command: xorriso" ]
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

@test "fetch uses curl's detailed transfer meter" {
  cache_dir="$(mktemp -d)"
  curl_log="$cache_dir/curl.log"
  stub_command curl 'printf "%s\\n" "$*" >"$VM_CURL_LOG"; exit 22'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_CURL_LOG="$curl_log" /bin/bash "$VM" fetch ubuntu

  [ "$status" -eq 22 ]
  grep -Fx -- '--fail --location --output /tmp/placeholder https://releases.ubuntu.com/26.04/ubuntu-26.04-live-server-amd64.iso' <(sed "s|$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso.part|/tmp/placeholder|" "$curl_log")
  rm -rf "$cache_dir"
}

@test "fetch requires a manually downloaded Windows ISO" {
  cache_dir="$(mktemp -d)"

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" fetch windows

  [ "$status" -eq 1 ]
  [ "$output" = "Windows ISO must be downloaded manually: https://www.microsoft.com/software-download/windows11" ]
  rm -rf "$cache_dir"
}

@test "fetch accepts a manually downloaded Windows ISO" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Win11_25H2_English_x64_v2.iso"

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" fetch windows

  [ "$status" -eq 0 ]
  [ "$output" = "ISO is ready without checksum: Win11_25H2_English_x64_v2.iso" ]
  rm -rf "$cache_dir"
}

@test "Windows unattended setup selects an unactivated Pro image" {
  run rg -F '<Key>/IMAGE/INDEX</Key>' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"

  [ "$status" -eq 0 ]

  run rg -F '<Value>6</Value>' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"

  [ "$status" -eq 0 ]

  run rg -F '<ProductKey>' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"

  [ "$status" -eq 1 ]
}

@test "Windows unattended setup selects the Windows PE locale" {
  run rg -F 'Microsoft-Windows-International-Core-WinPE' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"

  [ "$status" -eq 0 ]

  run rg -F '<UILanguage>en-US</UILanguage>' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"

  [ "$status" -eq 0 ]
}

@test "Windows unattended setup bypasses the TPM requirement" {
  run rg -F 'BypassTPMCheck' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"

  [ "$status" -eq 0 ]
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
  [[ "$output" == *"Build completed: fedora in "* ]]
  grep -q -- '--name dot-v2-fedora-base-build' "$install_log"
  grep -q -- "--location $cache_dir/iso/Fedora-Everything-netinst-x86_64-44-1.7.iso" "$install_log"
  grep -q -- '--initrd-inject .*/v2/data/fedora/kickstart.cfg' "$install_log"
  grep -q -- '--boot uefi' "$install_log"
  grep -q -- '--events on_poweroff=destroy,on_reboot=destroy' "$install_log"
  grep -q -- '--graphics none' "$install_log"
  grep -q -- '--autoconsole text' "$install_log"
  rm -rf "$cache_dir"
}

@test "build creates a headless Arch Hyprland base with libvirt" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  seed_log="$cache_dir/cloud-localds.log"
  acl_log="$cache_dir/setfacl.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/archlinux-2026.09.01-x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command cloud-localds 'printf "%s\\n" "$*" >"$VM_SEED_LOG"; : >"$1"; chmod 600 "$1"'
  stub_command id 'printf "%s\\n" 107'
  stub_command setfacl 'printf "%s\\n" "$*" >>"$VM_ACL_LOG"'
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_ACL_LOG="$acl_log" VM_INSTALL_LOG="$install_log" VM_SEED_LOG="$seed_log" /bin/bash "$VM" build arch

  [ "$status" -eq 0 ]
  grep -q -- '--name dot-v2-arch-base-build' "$install_log"
  grep -q -- "--location $cache_dir/iso/archlinux-2026.09.01-x86_64.iso,kernel=/arch/boot/x86_64/vmlinuz-linux,initrd=/arch/boot/x86_64/initramfs-linux.img" "$install_log"
  grep -q -- "--disk path=$cache_dir/seeds/arch.iso,device=cdrom,bus=sata,readonly=on" "$install_log"
  grep -q -- "--disk path=$cache_dir/scripts/arch-install.sh,device=disk,bus=virtio,readonly=on" "$install_log"
  grep -q -- 'archisobasedir=arch archisodevice=/dev/sr0' "$install_log"
  grep -q -- '--boot uefi' "$install_log"
  grep -q -- "$cache_dir/seeds/arch.iso .*data/arch/user-data .*data/arch/meta-data" "$seed_log"
  rm -rf "$cache_dir"
}

@test "build creates a Windows base with an unattended CD" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  key_log="$cache_dir/send-key.log"
  viewer_log="$cache_dir/virt-manager.log"
  xorriso_log="$cache_dir/xorriso.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Win11_25H2_English_x64_v2.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *"send-key"*) printf "%s\\n" "$*" >>"$VM_KEY_LOG" ;;
      *) exit 0 ;;
    esac
  '
  stub_command sleep 'exit 0'
  stub_command virt-manager 'printf "%s\\n" "$*" >>"$VM_VIEWER_LOG"'
  stub_command xorriso 'printf "%s\\n" "$*" >"$VM_XORRISO_LOG"; : >"$4"'
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" VM_KEY_LOG="$key_log" VM_VIEWER_LOG="$viewer_log" VM_XORRISO_LOG="$xorriso_log" /bin/bash "$VM" build windows

  [ "$status" -eq 0 ]
  grep -q -- '--name dot-v2-windows-base-build' "$install_log"
  grep -q -- 'vol=default/dot-v2-windows-base.qcow2,format=qcow2,bus=sata' "$install_log"
  grep -q -- "--disk path=$cache_dir/seeds/windows.iso,device=cdrom,bus=sata,readonly=on" "$install_log"
  grep -q -- '--boot uefi,cdrom' "$install_log"
  grep -q -- '--graphics spice' "$install_log"
  [ "$(grep -c -- 'send-key dot-v2-windows-base-build KEY_ENTER' "$key_log")" -eq 3 ]
  grep -q -- '--show-domain-console dot-v2-windows-base-build' "$viewer_log"
  grep -q -- 'network=default,model=e1000' "$install_log"
  grep -q -- "-as mkisofs -o $cache_dir/seeds/windows.iso -J -r -graft-points Autounattend.xml=$cache_dir/scripts/Autounattend.xml" "$xorriso_log"
  rm -rf "$cache_dir"
}

@test "build makes the Fedora installer transient after shutdown" {
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
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" /bin/bash "$VM" build fedora

  [ "$status" -eq 0 ]
  grep -q -- '--transient' "$install_log"
  grep -q -- '--events on_poweroff=destroy,on_reboot=destroy' "$install_log"
  rm -rf "$cache_dir"
}

@test "build preserves Fedora installer terminal output" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Fedora-Everything-netinst-x86_64-44-1.7.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'printf "\\033[0;32m  [  OK  ] Started network.service\\033[0m\\n"; exit 1'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build fedora

  [ "$status" -eq 1 ]
  [[ "$output" == *$'\033[0;32m  [  OK  ] Started network.service\033[0m'* ]]
  [ ! -e "$cache_dir/logs/fedora-build.log" ]
  rm -rf "$cache_dir"
}

@test "build streams Fedora installer progress to the terminal" {
  cache_dir="$(mktemp -d)"
  terminal_log="$cache_dir/terminal.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Fedora-Everything-netinst-x86_64-44-1.7.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'printf "first\\r"; sleep 1; printf "second\\n"; exit 1'

  env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build fedora >"$terminal_log" 2>&1 &
  build_pid=$!
  sleep 0.2

  grep -q 'first' "$terminal_log"
  if wait "$build_pid"; then
    false
  fi
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

@test "build creates an Ubuntu Desktop base from the Server ISO and NoCloud seed" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  seed_log="$cache_dir/cloud-localds.log"
  acl_log="$cache_dir/setfacl.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso"
  chmod 600 "$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command cloud-localds 'printf "%s\\n" "$*" >"$VM_SEED_LOG"; : >"$1"; chmod 600 "$1"'
  stub_command id 'printf "%s\\n" 107'
  stub_command setfacl 'printf "%s\\n" "$*" >>"$VM_ACL_LOG"'
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_ACL_LOG="$acl_log" VM_INSTALL_LOG="$install_log" VM_SEED_LOG="$seed_log" /bin/bash "$VM" build ubuntu

  [ "$status" -eq 0 ]
  grep -q -- '--name dot-v2-ubuntu-base-build' "$install_log"
  grep -q -- "--disk path=$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso,device=cdrom,bus=sata,readonly=on" "$install_log"
  grep -q -- "--disk path=$cache_dir/seeds/ubuntu.iso,device=disk,bus=virtio,readonly=on" "$install_log"
  grep -q -- "--location $cache_dir/iso/ubuntu-26.04-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd" "$install_log"
  grep -q -- '--extra-args autoinstall console=ttyS0' "$install_log"
  grep -q -- '--os-variant detect=on,require=off' "$install_log"
  grep -q -- '--events on_poweroff=destroy,on_reboot=destroy' "$install_log"
  grep -q -- '--transient' "$install_log"
  grep -q -- '--autoconsole text' "$install_log"
  grep -q -- "$cache_dir/seeds/ubuntu.iso .*data/ubuntu/user-data .*data/ubuntu/meta-data" "$seed_log"
  grep -Fx -- "-m u:107:r-- $cache_dir/iso/ubuntu-26.04-live-server-amd64.iso" "$acl_log"
  grep -Fx -- "-m u:107:r-- $cache_dir/seeds/ubuntu.iso" "$acl_log"
  run grep -q -- '-R' "$acl_log"
  [ "$status" -eq 1 ]
  rm -rf "$cache_dir"
}

@test "build accepts a readable Ubuntu ISO when its ACL cannot change" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso"
  chmod 644 "$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command cloud-localds ': >"$1"'
  stub_command id 'printf "%s\\n" 107'
  stub_command setfacl '
    case "$*" in
      *"ubuntu-26.04-live-server-amd64.iso")
        printf "%s\\n" "setfacl: Operation not permitted" >&2
        exit 1
        ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build ubuntu

  [ "$status" -eq 0 ]
  [[ "$output" == *"Base image is ready: ubuntu"* ]]
  [[ "$output" != *"Operation not permitted"* ]]
  rm -rf "$cache_dir"
}

@test "build rejects an Ubuntu installer console abort that exits zero" {
  cache_dir="$(mktemp -d)"
  virsh_log="$cache_dir/virsh.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command virsh '
    printf "%s\\n" "$*" >>"$VM_VIRSH_LOG"
    case "$*" in
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command cloud-localds ': >"$1"'
  stub_command id 'printf "%s\\n" 107'
  stub_command setfacl 'exit 0'
  stub_command virt-install 'printf "%s\\n" "Installation aborted at user request"; exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRSH_LOG="$virsh_log" /bin/bash "$VM" build ubuntu

  [ "$status" -eq 1 ]
  [[ "$output" == *"Image build failed: ubuntu"* ]]
  grep -q -- 'vol-delete --pool default dot-v2-ubuntu-base.qcow2' "$virsh_log"
  rm -rf "$cache_dir"
}

@test "build explains a missing Ubuntu seed tool" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/ubuntu-26.04-live-server-amd64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'

  run env PATH="$STUB_BIN" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build ubuntu

  [ "$status" -eq 1 ]
  [[ "$output" == *"Missing host command: cloud-localds. Install cloud-utils-cloud-localds on Fedora or cloud-image-utils on Ubuntu."* ]]
  [[ "$output" == *"Build failed: ubuntu after "* ]]
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

@test "run creates a UEFI Arch overlay from the managed base" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  stub_command virsh '
    case "$*" in
      *"vol-info"*"dot-v2-arch-base.qcow2"*) exit 0 ;;
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'
  stub_command virt-manager 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" /bin/bash "$VM" run arch

  [ "$status" -eq 0 ]
  grep -q -- 'vol=default/dot-v2-arch-test.qcow2,format=qcow2,bus=virtio' "$install_log"
  grep -q -- '--video virtio,accel3d=yes' "$install_log"
  grep -q -- '--graphics spice,gl=on' "$install_log"
  grep -q -- '--boot uefi' "$install_log"
  rm -rf "$cache_dir"
}

@test "run creates a UEFI Windows overlay from the managed base" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/virt-install.log"
  stub_command virsh '
    case "$*" in
      *"vol-info"*"dot-v2-windows-base.qcow2"*) exit 0 ;;
      *"vol-info"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_INSTALL_LOG"'
  stub_command virt-manager 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_INSTALL_LOG="$install_log" /bin/bash "$VM" run windows

  [ "$status" -eq 0 ]
  grep -q -- 'vol=default/dot-v2-windows-test.qcow2,format=qcow2,bus=sata' "$install_log"
  grep -q -- 'network=default,model=e1000' "$install_log"
  grep -q -- '--boot uefi' "$install_log"
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

@test "stop removes the managed Windows overlay" {
  cache_dir="$(mktemp -d)"
  virsh_log="$cache_dir/virsh.log"
  stub_command virsh 'printf "%s\\n" "$*" >>"$VM_VIRSH_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRSH_LOG="$virsh_log" /bin/bash "$VM" stop windows

  [ "$status" -eq 0 ]
  [ "$output" = "Test guest stopped: windows" ]
  grep -q -- 'undefine dot-v2-windows-test --nvram' "$virsh_log"
  grep -q -- 'vol-delete --pool default dot-v2-windows-test.qcow2' "$virsh_log"
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

@test "Linux install data creates the test account" {
  grep -Fx '    username: tester' "$PROJECT_ROOT/v2/data/ubuntu/user-data"
  grep -Fx '    password: "$6$0vQfY9V3QziQBBqX$6/rOgYG2rwjvKNn4nAtqUdd42Nk4.kx0bxGFwHdzpKXjktFuH/.zMPE8GuaAPD6xhPQ32v41GVsuhYKoeN3tT."' "$PROJECT_ROOT/v2/data/ubuntu/user-data"
  grep -Fx '    - ubuntu-desktop' "$PROJECT_ROOT/v2/data/ubuntu/user-data"
  grep -Fx '    - |' "$PROJECT_ROOT/v2/data/ubuntu/user-data"
  grep -Fx "      curtin in-target --target=/target -- sh -c 'echo \"tester ALL=(ALL) NOPASSWD: ALL\" >/etc/sudoers.d/tester'" "$PROJECT_ROOT/v2/data/ubuntu/user-data"
  run grep -q '^  source:' "$PROJECT_ROOT/v2/data/ubuntu/user-data"
  [ "$status" -eq 1 ]
  grep -Fx 'user --name=tester --password=tester --plaintext --groups=wheel' "$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"
  grep -Fx "useradd --create-home --groups wheel tester" "$PROJECT_ROOT/v2/data/arch/install.sh"
  grep -Fx "printf 'tester:tester\\n' | chpasswd" "$PROJECT_ROOT/v2/data/arch/install.sh"
  grep -Fx '  hyprland foot greetd greetd-tuigreet mesa noto-fonts polkit hyprpolkitagent \' "$PROJECT_ROOT/v2/data/arch/install.sh"
  grep -Fx '  pipewire wireplumber xdg-desktop-portal-hyprland xorg-xwayland' "$PROJECT_ROOT/v2/data/arch/install.sh"
}

@test "Windows install data creates the test account" {
  grep -Fx '            <Name>tester</Name>' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"
  grep -Fx '              <Value>tester</Value>' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"
  grep -Fx '          <CommandLine>shutdown /s /t 5</CommandLine>' "$PROJECT_ROOT/v2/data/windows/Autounattend.xml"
}
