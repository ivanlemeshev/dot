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

@test "help describes the VM lifecycle" {
  run /bin/bash "$VM" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: v2/bin/vm <command> [target]"* ]]
  [[ "$output" == *"build <target>"* ]]
  [[ "$output" == *"run <target>"* ]]
  [[ "$output" == *"stop <target>"* ]]
}

@test "commands accept a help option" {
  run /bin/bash "$VM" build --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"build <target>"* ]]
}

@test "unknown commands explain how to get help" {
  run /bin/bash "$VM" unknown

  [ "$status" -eq 2 ]
  [ "$output" = $'Unknown command: unknown\nRun v2/bin/vm --help for usage.' ]
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

@test "stop removes a disposable test overlay and preserves its base image" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images" "$cache_dir/overlays"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/images/fedora.qcow2.ready"
  : >"$cache_dir/overlays/fedora.qcow2"
  stub_command virsh '
    test "$1" = "-c" && test "$2" = "qemu:///system"
    case "$3" in
      domstate) exit 0 ;;
      destroy) test "$4" = "dot-v2-fedora-test" ;;
      undefine) test "$4" = "dot-v2-fedora-test" ;;
    esac
  '

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" stop fedora

  [ "$status" -eq 0 ]
  [ "$output" = "Test guest stopped: fedora" ]
  [ -f "$cache_dir/images/fedora.qcow2" ]
  [ -f "$cache_dir/images/fedora.qcow2.ready" ]
  [ ! -e "$cache_dir/overlays/fedora.qcow2" ]
  rm -rf "$cache_dir"
}

@test "stop succeeds when no disposable test guest exists" {
  cache_dir="$(mktemp -d)"
  stub_command virsh 'exit 1'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" stop fedora

  [ "$status" -eq 0 ]
  [ "$output" = "No test guest exists: fedora" ]
  rm -rf "$cache_dir"
}

@test "run creates a disposable test overlay" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/images/fedora.qcow2.ready"
  stub_command qemu-img ': >"${@: -1}"'
  stub_command virt-install 'sleep 1'
  stub_command virsh 'exit 1'
  stub_command setfacl 'exit 0'
  manager_log="$cache_dir/virt-manager.log"
  stub_command virt-manager 'printf "%s\\n" "$*" >"$VM_MANAGER_LOG"'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_MANAGER_LOG="$manager_log" /bin/bash "$VM" run fedora

  [ "$status" -eq 0 ]
  [ "$output" = "Test guest is running: fedora" ]
  [ -f "$cache_dir/overlays/fedora.qcow2" ]
  [ "$(<"$manager_log")" = "--connect qemu:///system --show-domain-console dot-v2-fedora-test" ]
  rm -rf "$cache_dir"
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

@test "Fedora Kickstart sets the US keyboard, UTC, and virtual disk" {
  kickstart="$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"

  grep -Fx 'keyboard us' "$kickstart"
  grep -Fx 'timezone UTC --utc' "$kickstart"
  grep -Fx 'firstboot --disable' "$kickstart"
  grep -Fx 'ignoredisk --only-use=vda' "$kickstart"
  grep -Fx 'clearpart --all --initlabel' "$kickstart"
}

@test "Fedora Kickstart uses the command-line installer and starts KDE" {
  kickstart="$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"

  grep -Fx 'cmdline' "$kickstart"
  grep -Fx 'services --enabled=plasmalogin' "$kickstart"
  grep -Fx 'systemctl set-default graphical.target' "$kickstart"
  grep -Fx 'plasma-login-manager' "$kickstart"
  grep -Fx -- '-plasma-welcome' "$kickstart"
  grep -Fx "printf '[General]\\nColorScheme=BreezeDark\\n' >/etc/xdg/kdeglobals" "$kickstart"
  ! grep -Fx 'sddm' "$kickstart"
}

@test "Fedora Kickstart sends error logs to the serial console" {
  kickstart="$PROJECT_ROOT/v2/data/fedora/kickstart.cfg"

  grep -Fx '%onerror --interpreter=/bin/bash' "$kickstart"
  grep -Fx 'exec >/dev/ttyS0 2>&1' "$kickstart"
  grep -Fx '  tail -n 200 "$log_path"' "$kickstart"
}

@test "Ubuntu autoinstall powers off after setup" {
  run grep -Fx '  shutdown: poweroff' "$PROJECT_ROOT/v2/data/ubuntu/user-data"

  [ "$status" -eq 0 ]
}

@test "Ubuntu target uses the official 26.04 desktop ISO" {
  run jq -r '[.targets.ubuntu.iso.name, .targets.ubuntu.iso.url, .targets.ubuntu.iso.sha256] | @tsv' "$PROJECT_ROOT/v2/config/targets.json"

  [ "$status" -eq 0 ]
  [ "$output" = $'ubuntu-26.04-desktop-amd64.iso\thttps://releases.ubuntu.com/26.04/ubuntu-26.04-desktop-amd64.iso\t487f87faaf547ea30e0aba4d5b53346292571256b25333a978db1692bcee9dd2' ]
}

@test "Ubuntu autoinstall selects the standard desktop source" {
  user_data="$PROJECT_ROOT/v2/data/ubuntu/user-data"

  grep -Fx '  source:' "$user_data"
  grep -Fx '    id: ubuntu-desktop' "$user_data"
  ! grep -Fx '  packages:' "$user_data"
}

@test "Ubuntu build replaces an incomplete image and injects NoCloud autoinstall data" {
  cache_dir="$(mktemp -d)"
  virt_log="$cache_dir/virt-install.log"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/ubuntu.qcow2"
  : >"$cache_dir/iso/ubuntu-26.04-desktop-amd64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'printf "%s\\n" "$*" >"$VM_VIRT_LOG"'
  stub_command virsh 'exit 0'
  stub_command setfacl 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRT_LOG="$virt_log" /bin/bash "$VM" build ubuntu

  [ "$status" -eq 0 ]
  grep -q -- "--location $cache_dir/iso/ubuntu-26.04-desktop-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd" "$virt_log"
  grep -q -- '--initrd-inject .*/data/ubuntu/user-data' "$virt_log"
  grep -q -- '--initrd-inject .*/data/ubuntu/meta-data' "$virt_log"
  grep -q -- '--serial pty' "$virt_log"
  grep -q -- 'autoinstall ds=nocloud;s=file:/// console=ttyS0' "$virt_log"
  rm -rf "$cache_dir"
}

@test "Ubuntu build stores installer progress in its log" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/logs/ubuntu-install.log"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/ubuntu.qcow2"
  : >"$cache_dir/iso/ubuntu-26.04-desktop-amd64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virsh '
    case "$3" in
      domstate)
        exit 0
        ;;
      console)
        printf "%s\\n" "Installing Ubuntu packages"
        ;;
    esac
  '
  stub_command setfacl 'exit 0'
  stub_command virt-install 'sleep 1'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build ubuntu

  [ "$status" -eq 0 ]
  [ "$output" = "ISO is ready: ubuntu-26.04-desktop-amd64.iso"$'\n'"Base image is ready: ubuntu" ]
  [ "$(<"$install_log")" = "Installing Ubuntu packages" ]
  rm -rf "$cache_dir"
}

@test "build rejects a ready base without an interactive terminal" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/images/fedora.qcow2.ready"

  run env VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build fedora

  rm -rf "$cache_dir"
  [ "$status" -eq 1 ]
  [ "$output" = "Base image exists: fedora. Run build from a terminal to confirm rebuild." ]
}

@test "build replaces an incomplete base image" {
  cache_dir="$(mktemp -d)"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'exit 0'
  stub_command virsh 'exit 0'
  stub_command setfacl 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build fedora

  rm -rf "$cache_dir"
  [ "$status" -eq 0 ]
  [ "$output" = $'ISO is ready: Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso\nBase image is ready: fedora' ]
}

@test "failed build removes its base guest and partial image" {
  cache_dir="$(mktemp -d)"
  virsh_log="$cache_dir/virsh.log"
  install_log="$cache_dir/logs/fedora-install.log"
  mkdir -p "$cache_dir/iso"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'exit 1'
  stub_command virsh 'printf "%s\\n" "$*" >>"$VM_VIRSH_LOG"; test "$3" = "domstate" && exit 0'
  stub_command setfacl 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRSH_LOG="$virsh_log" /bin/bash "$VM" build fedora

  [ "$status" -eq 1 ]
  [ "$output" = "ISO is ready: Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"$'\n'"Installation failed: fedora. See $install_log" ]
  grep -Fx -- '-c qemu:///system destroy dot-v2-fedora' "$virsh_log"
  grep -Fx -- '-c qemu:///system undefine dot-v2-fedora --nvram' "$virsh_log"
  [ ! -e "$cache_dir/images/fedora.qcow2" ]
  [ -f "$install_log" ]
  rm -rf "$cache_dir"
}

@test "build powers off the base guest after installation" {
  cache_dir="$(mktemp -d)"
  virsh_log="$cache_dir/virsh.log"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virt-install 'exit 0'
  stub_command virsh 'printf "%s\\n" "$*" >>"$VM_VIRSH_LOG"; test "$3" = "domstate" && exit 1'
  stub_command setfacl 'exit 0'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRSH_LOG="$virsh_log" /bin/bash "$VM" build fedora

  [ "$status" -eq 0 ]
  grep -Fx -- '-c qemu:///system destroy dot-v2-fedora' "$virsh_log"
  rm -rf "$cache_dir"
}

@test "build grants qemu access to the cache" {
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

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_ACCESS_LOG="$access_log" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build fedora

  [ "$status" -eq 0 ]
  grep -q -- "u:$(id -u qemu):rwX" "$access_log"
  rm -rf "$cache_dir"
}

@test "build does not change ACLs above the user home directory" {
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

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_ACCESS_LOG="$access_log" VM_CACHE_DIR="$cache_dir" VM_USER_HOME="$test_home" /bin/bash "$VM" build fedora

  [ "$status" -eq 0 ]
  grep -q -- "$test_home$" "$access_log"
  ! grep -q -- '/tmp$' "$access_log"
  rm -rf "$test_home"
}

@test "Fedora build records command-line installer progress" {
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

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" VM_VIRT_LOG="$virt_log" /bin/bash "$VM" build fedora

  [ "$status" -eq 0 ]
  grep -q -- '--noautoconsole' "$virt_log"
  ! grep -q -- '--autoconsole text' "$virt_log"
  grep -q -- '--serial pty' "$virt_log"
  grep -q -- '--noreboot' "$virt_log"
  ! grep -q -- 'log.file=' "$virt_log"
  grep -q -- 'console=ttyS0 inst.cmdline' "$virt_log"
  rm -rf "$cache_dir"
}

@test "Fedora build stores installer progress in its log" {
  cache_dir="$(mktemp -d)"
  install_log="$cache_dir/logs/fedora-install.log"
  mkdir -p "$cache_dir/images" "$cache_dir/iso"
  : >"$cache_dir/images/fedora.qcow2"
  : >"$cache_dir/iso/Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"
  stub_command sha256sum 'test "$1" = "--check" && exit 0'
  stub_command qemu-img ': >"$4"'
  stub_command virsh '
    case "$3" in
      domstate)
        exit 0
        ;;
      console)
        printf "%s\\n" "Installing Fedora packages"
        ;;
    esac
  '
  stub_command setfacl 'exit 0'
  stub_command virt-install 'sleep 1'

  run env PATH="$STUB_BIN:/usr/bin:/bin" VM_CACHE_DIR="$cache_dir" /bin/bash "$VM" build fedora

  [ "$status" -eq 0 ]
  [ "$output" = "ISO is ready: Fedora-KDE-Desktop-Live-44-1.7.x86_64.iso"$'\n'"Base image is ready: fedora" ]
  [ "$(<"$install_log")" = "Installing Fedora packages" ]
  rm -rf "$cache_dir"
}
