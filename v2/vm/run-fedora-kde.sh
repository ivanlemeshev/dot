#!/usr/bin/env bash

set -euo pipefail

readonly vm_memory_mib=4096
readonly vm_disk_gib=30
readonly vm_vcpus=2
readonly vm_network=default
readonly test_user=dotfiles-test
readonly ssh_wait_attempts=540
readonly libvirt_pool=default
readonly fedora_download_root=https://download.fedoraproject.org/pub/fedora/linux/releases
readonly os_release_file=/etc/os-release

dry_run=false
run_mode=overlay
fedora_release="${FEDORA_RELEASE:-}"
iso_url=""
checksum_url=""
install_tree_url=""
evidence_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-v2/vm-evidence"
iso_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-v2/iso"
vm_name=""
work_dir=""
vm_created=false
iso_volume=""
primary_volume=""
preserve_primary_volume=false
previous_base_volume=""
libvirt_iso_file=""
ssh_key_file=""

stop() {
  printf 'VM runner stopped: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: run-fedora-kde.sh [--base-build | --base-rebuild] [--release RELEASE] \
  [--evidence-dir DIRECTORY] [--iso-cache DIRECTORY] [--dry-run]

The default run starts a new overlay from a Fedora KDE base disk. --base-build
creates that disk. --base-rebuild replaces it. Base creation verifies the signed
checksum. Each run retains evidence and runs an SSH check.
EOF
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        dry_run=true
        ;;
      --base-build)
        [[ "$run_mode" == overlay ]] || stop "Only one base-disk action is allowed."
        run_mode=base
        ;;
      --base-rebuild)
        [[ "$run_mode" == overlay ]] || stop "Only one base-disk action is allowed."
        run_mode=rebuild
        ;;
      --release | --evidence-dir | --iso-cache)
        [[ $# -ge 2 ]] || stop "Missing value for $1."
        case "$1" in
          --release) fedora_release="$2" ;;
          --evidence-dir) evidence_dir="$2" ;;
          --iso-cache) iso_cache="$2" ;;
        esac
        shift
        ;;
      --help | -h)
        usage
        exit 0
        ;;
      *)
        stop "Unknown argument: $1."
        ;;
    esac
    shift
  done

  if [[ -z "$fedora_release" ]]; then
    [[ -r "$os_release_file" ]] || stop "Cannot read Fedora release data."
    fedora_release="$(awk -F= '$1 == "VERSION_ID" { gsub(/"/, "", $2); print $2 }' "$os_release_file")"
  fi
  [[ "$fedora_release" =~ ^[0-9]+$ ]] || stop "Fedora release must be a number."
}

print_plan() {
  local base_volume

  base_volume="$(base_volume_name)"
  cat <<EOF
Fedora KDE Plasma VM plan
Fedora release: $fedora_release
Run mode: $run_mode
Base volume: $base_volume
Provider: libvirt/QEMU
Firmware: UEFI
Secure Boot: disabled
Memory: $vm_memory_mib MiB
Disk: $vm_disk_gib GiB
vCPUs: $vm_vcpus
Network: $vm_network
Non-root test user: $test_user
SDDM KDE Plasma auto-login: enabled
Installer display: graphical
SSH check: pgrep plasmashell as $test_user
SSH timeout: 45 minutes
Cleanup: remove VM and overlay disk after the run
Evidence directory: $evidence_dir
EOF

  if [[ "$run_mode" == base || "$run_mode" == rebuild ]]; then
    printf 'Base disk: retained after a successful run\n'
  fi
  if [[ "$run_mode" == rebuild ]]; then
    printf 'Current base disk: retained until the new base passes\n'
  fi
}

require_commands() {
  local command
  for command in awk curl gpg grep sha256sum sort ssh ssh-keygen stat virsh virt-install; do
    command -v "$command" >/dev/null || stop "Required command is unavailable: $command."
  done
}

cleanup() {
  local status=$?

  if [[ "$vm_created" == true ]]; then
    virsh -c qemu:///system destroy "$vm_name" >/dev/null 2>&1 || true
    virsh -c qemu:///system undefine "$vm_name" --nvram >/dev/null 2>&1 || true
  fi

  if [[ -n "$iso_volume" ]]; then
    virsh -c qemu:///system vol-delete "$iso_volume" --pool "$libvirt_pool" >/dev/null 2>&1 || true
  fi

  if [[ -n "$primary_volume" && ( "$preserve_primary_volume" == false || "$status" -ne 0 ) ]]; then
    virsh -c qemu:///system vol-delete "$primary_volume" --pool "$libvirt_pool" >/dev/null 2>&1 || true
  fi

  [[ -z "$work_dir" ]] || rm -rf "$work_dir"
  exit "$status"
}

download() {
  local source_url="$1"
  local target_file="$2"

  printf 'download %s\n' "$source_url" >>"$evidence_dir/acquisition.log"
  curl --fail --location --retry 3 --output "$target_file" "$source_url" >>"$evidence_dir/acquisition.log" 2>&1
}

select_installer_media() {
  local release_directory
  local listing_file
  local iso_name
  local checksum_name

  release_directory="$fedora_download_root/$fedora_release/Everything/x86_64/iso"
  listing_file="$work_dir/release-directory.html"
  download "$release_directory/" "$listing_file"
  iso_name="$(grep -oE "Fedora-Everything-netinst-x86_64-$fedora_release-[0-9]+(\\.[0-9]+)*\\.iso" "$listing_file" | sort -Vu | tail -n 1)"
  checksum_name="$(grep -oE "Fedora-Everything-$fedora_release-[0-9]+(\\.[0-9]+)*-x86_64-CHECKSUM" "$listing_file" | sort -Vu | tail -n 1)"
  [[ -n "$iso_name" ]] || stop "Cannot find a Fedora Everything installer ISO for release $fedora_release."
  [[ -n "$checksum_name" ]] || stop "Cannot find a Fedora checksum file for release $fedora_release."
  iso_url="$release_directory/$iso_name"
  checksum_url="$release_directory/$checksum_name"
  install_tree_url="$fedora_download_root/$fedora_release/Everything/x86_64/os/"
}

upload_iso_to_libvirt() {
  local iso_file="$1"
  local iso_size

  iso_size="$(stat --format=%s "$iso_file")"
  iso_volume="$vm_name-installer.iso"
  virsh -c qemu:///system vol-create-as "$libvirt_pool" "$iso_volume" "$iso_size" --format raw >/dev/null
  virsh -c qemu:///system vol-upload "$iso_volume" "$iso_file" --pool "$libvirt_pool" >/dev/null
  libvirt_iso_file="$(virsh -c qemu:///system vol-path "$iso_volume" --pool "$libvirt_pool")"
}

base_volume_name() {
  local pointer_file
  local active_base_volume

  pointer_file="$(base_key_directory)/base-volume"
  if [[ -r "$pointer_file" ]] && read -r active_base_volume <"$pointer_file"; then
    printf '%s\n' "$active_base_volume"
    return
  fi
  printf 'dotfiles-v2-fedora-kde-base-%s.qcow2\n' "$fedora_release"
}

base_key_directory() {
  printf '%s/dotfiles-v2/vm-base/fedora-%s\n' "${XDG_STATE_HOME:-$HOME/.local/state}" "$fedora_release"
}

candidate_base_volume_name() {
  printf '%s-base.qcow2\n' "$vm_name"
}

prepare_ssh_key() {
  local base_key

  if [[ "$run_mode" == overlay ]]; then
    base_key="$(base_key_directory)/id_ed25519"
    [[ -r "$base_key" && -r "$base_key.pub" ]] || stop "Build the Fedora KDE base disk first: make vm-base-build."
    ssh_key_file="$base_key"
    return
  fi

  base_key="$(base_key_directory)/id_ed25519"
  mkdir -p "$(base_key_directory)"
  if [[ ! -f "$base_key" ]]; then
    ssh-keygen -q -t ed25519 -N '' -f "$base_key"
  fi
  ssh_key_file="$base_key"
}

create_primary_volume() {
  local base_volume

  base_volume="$(base_volume_name)"
  if [[ "$run_mode" == overlay ]]; then
    virsh -c qemu:///system vol-info "$base_volume" --pool "$libvirt_pool" >/dev/null || stop "Build the Fedora KDE base disk first: make vm-base-build."
    primary_volume="$vm_name.qcow2"
    virsh -c qemu:///system vol-create-as "$libvirt_pool" "$primary_volume" "${vm_disk_gib}G" --format qcow2 --backing-vol "$base_volume" --backing-vol-format qcow2 >/dev/null
    return
  fi

  if virsh -c qemu:///system vol-info "$base_volume" --pool "$libvirt_pool" >/dev/null 2>&1; then
    [[ "$run_mode" == rebuild ]] || stop "Fedora KDE base disk already exists. Use make vm-base-rebuild to rebuild it."
    previous_base_volume="$base_volume"
  fi
  primary_volume="$(candidate_base_volume_name)"
  preserve_primary_volume=true
  virsh -c qemu:///system vol-create-as "$libvirt_pool" "$primary_volume" "${vm_disk_gib}G" --format qcow2 >/dev/null
}

activate_base_volume() {
  local pointer_file
  local pointer_temp_file

  pointer_file="$(base_key_directory)/base-volume"
  pointer_temp_file="$work_dir/base-volume"
  printf '%s\n' "$primary_volume" >"$pointer_temp_file"
  mv "$pointer_temp_file" "$pointer_file"
  if [[ -n "$previous_base_volume" ]]; then
    virsh -c qemu:///system vol-delete "$previous_base_volume" --pool "$libvirt_pool" >/dev/null
  fi
  printf 'active_base_volume=%s\n' "$primary_volume" >>"$evidence_dir/run-metadata.env"
}

write_kickstart() {
  local public_key

  public_key="$(<"$ssh_key_file.pub")"
  cat >"$work_dir/fedora-kde.ks" <<EOF
lang en_US.UTF-8
keyboard us
timezone UTC --utc
network --bootproto=dhcp --device=link --activate
rootpw --lock
user --name=$test_user --groups=wheel --iscrypted --password='!'
reboot
autopart --type=lvm
clearpart --all --initlabel
%packages
@kde-desktop-environment
openssh-server
qemu-guest-agent
%end
%post
mkdir -p /home/$test_user/.ssh /etc/sddm.conf.d
printf '%s\\n' '$public_key' > /home/$test_user/.ssh/authorized_keys
chmod 700 /home/$test_user/.ssh
chmod 600 /home/$test_user/.ssh/authorized_keys
chown -R $test_user:$test_user /home/$test_user/.ssh
cat > /etc/sddm.conf.d/dotfiles-v2-autologin.conf <<'AUTLOGIN'
[Autologin]
User=$test_user
Session=plasma.desktop
Relogin=false
AUTLOGIN
systemctl enable sshd qemu-guest-agent
%end
EOF
}

verify_iso() {
  local iso_file="$1"
  local checksum_file="$2"
  local key_file="$3"
  local expected_checksum
  local actual_checksum
  local gpg_home
  local iso_name

  iso_name="$(basename "$iso_file")"
  gpg_home="$work_dir/gnupg"
  mkdir -m 700 "$gpg_home"
  gpg --batch --homedir "$gpg_home" --import "$key_file" >/dev/null
  gpg --batch --homedir "$gpg_home" --verify "$checksum_file" >"$evidence_dir/checksum-signature.log" 2>&1
  expected_checksum="$(awk -v name="$iso_name" '$0 ~ "SHA256.*\\(" name "\\)" { print $NF }' "$checksum_file")"
  [[ -n "$expected_checksum" ]] || stop "Checksum file has no SHA256 value for $iso_name."
  actual_checksum="$(sha256sum "$iso_file" | awk '{print $1}')"
  [[ "$actual_checksum" == "$expected_checksum" ]] || stop "ISO checksum verification failed."

  printf 'iso_sha256=%s\n' "$actual_checksum" >>"$evidence_dir/run-metadata.env"
}

wait_for_ssh() {
  local address=""
  local attempt
  local elapsed_minutes
  local remaining_minutes
  local status_key=""
  local previous_status_key=""
  local status_message
  local vm_state

  printf 'Waiting for VM readiness. Status updates appear after each change or every minute.\n'
  for attempt in $(seq 1 "$ssh_wait_attempts"); do
    elapsed_minutes=$((attempt * 5 / 60))
    remaining_minutes=$(((ssh_wait_attempts - attempt) * 5 / 60))
    vm_state="$(virsh -c qemu:///system domstate "$vm_name" 2>/dev/null || printf unknown)"
    address="$(virsh -c qemu:///system domifaddr "$vm_name" --source lease 2>/dev/null | awk '/ipv4/ && address == "" { sub("/.*", "", $4); address = $4 } END { print address }')"
    if [[ -z "$address" ]]; then
      status_key="lease:$vm_state"
      status_message="VM state: $vm_state. Waiting for a DHCP lease."
    elif ! ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new -i "$ssh_key_file" "$test_user@$address" true >>"$evidence_dir/ssh-check.log" 2>&1; then
      status_key="ssh:$address"
      status_message="VM address: $address. Waiting for SSH."
    elif ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new -i "$ssh_key_file" "$test_user@$address" 'pgrep -x plasmashell >/dev/null' >>"$evidence_dir/ssh-check.log" 2>&1; then
      printf '{"result":"passed","check":"KDE Plasma session available through SSH"}\n' >"$evidence_dir/ssh-check.json"
      return 0
    else
      status_key="plasma:$address"
      status_message="VM address: $address. SSH is ready. Waiting for the KDE Plasma session."
    fi
    if [[ "$status_key" != "$previous_status_key" || $((attempt % 12)) -eq 0 ]]; then
      printf '%s Elapsed: %s minutes. Remaining: %s minutes.\n' "$status_message" "$elapsed_minutes" "$remaining_minutes"
      printf '%s Elapsed: %s minutes. Remaining: %s minutes.\n' "$status_message" "$elapsed_minutes" "$remaining_minutes" >>"$evidence_dir/ssh-check.log"
      previous_status_key="$status_key"
    fi
    sleep 5
  done

  printf '{"result":"failed","check":"KDE Plasma session available through SSH"}\n' >"$evidence_dir/ssh-check.json"
  stop "SSH check did not find a KDE Plasma session."
}

run_vm() {
  local timestamp
  local iso_name
  local iso_file
  local checksum_file
  local key_file
  local primary_disk_file
  local -a install_arguments

  require_commands
  timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
  vm_name="dotfiles-v2-fedora-kde-$timestamp"
  evidence_dir="$evidence_dir/$vm_name"
  mkdir -p "$evidence_dir" "$iso_cache"
  work_dir="$(mktemp -d)"
  trap cleanup EXIT
  printf 'run_started_at=%s\nvm_name=%s\nrun_mode=%s\nprovider=libvirt/QEMU\nfirmware=UEFI\nfedora_release=%s\nvcpus=%s\nmemory_mib=%s\ndisk_gib=%s\nnetwork=%s\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$vm_name" "$run_mode" "$fedora_release" "$vm_vcpus" "$vm_memory_mib" "$vm_disk_gib" "$vm_network" >"$evidence_dir/run-metadata.env"

  prepare_ssh_key
  create_primary_volume
  primary_disk_file="$(virsh -c qemu:///system vol-path "$primary_volume" --pool "$libvirt_pool")"

  if [[ "$run_mode" == overlay ]]; then
    install_arguments=(--import)
  else
    select_installer_media
    iso_name="$(basename "$iso_url")"
    iso_file="$iso_cache/$iso_name"
    checksum_file="$work_dir/CHECKSUM"
    key_file="/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$fedora_release-primary"
    [[ -r "$key_file" ]] || stop "Local Fedora release key is unavailable: $key_file."
    printf 'iso_url=%s\nchecksum_url=%s\ninstall_tree_url=%s\ntrusted_key_file=%s\n' "$iso_url" "$checksum_url" "$install_tree_url" "$key_file" >>"$evidence_dir/run-metadata.env"
    download "$checksum_url" "$checksum_file"
    [[ -f "$iso_file" ]] || download "$iso_url" "$iso_file"
    verify_iso "$iso_file" "$checksum_file" "$key_file"
    upload_iso_to_libvirt "$iso_file"
    write_kickstart
    install_arguments=(
      --install "kernel=${install_tree_url}images/pxeboot/vmlinuz,initrd=${install_tree_url}images/pxeboot/initrd.img,kernel_args=inst.repo=${install_tree_url} inst.ks=file:/fedora-kde.ks"
      --disk "path=$libvirt_iso_file,device=cdrom,readonly=on"
      --initrd-inject "$work_dir/fedora-kde.ks"
    )
  fi

  vm_created=true
  virt-install \
    --connect qemu:///system \
    --name "$vm_name" \
    --memory "$vm_memory_mib" \
    --vcpus "$vm_vcpus" \
    --disk "path=$primary_disk_file,format=qcow2" \
    --network "network=$vm_network" \
    --os-variant fedora-unknown \
    --boot uefi,firmware.feature0.name=secure-boot,firmware.feature0.enabled=no,hd \
    --graphics spice \
    --noautoconsole \
    "${install_arguments[@]}" \
    --wait 0 >"$evidence_dir/virt-install.log" 2>&1
  wait_for_ssh
  if [[ "$run_mode" == base || "$run_mode" == rebuild ]]; then
    activate_base_volume
  fi
}

main() {
  parse_arguments "$@"
  print_plan
  if [[ "$dry_run" == true ]]; then
    printf 'No changes were made.\n'
    return
  fi
  run_vm
}

main "$@"
