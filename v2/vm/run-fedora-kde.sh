#!/usr/bin/env bash

set -euo pipefail

readonly vm_memory_mib=4096
readonly vm_disk_gib=30
readonly vm_vcpus=2
readonly vm_network=default
readonly test_user=dotfiles-test
readonly fedora_key_url=https://fedoraproject.org/fedora.gpg

dry_run=false
fedora_release=""
iso_url=""
checksum_url=""
checksum_signature_url=""
fedora_key_fingerprint=""
evidence_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-v2/vm-evidence"
iso_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-v2/iso"
vm_name=""
work_dir=""
vm_created=false

stop() {
  printf 'VM runner stopped: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: run-fedora-kde.sh --release RELEASE --iso-url URL --checksum-url URL \
  --checksum-signature-url URL --fedora-key-fingerprint FINGERPRINT \
  [--evidence-dir DIRECTORY] [--iso-cache DIRECTORY]

Provision one fresh Fedora KDE Plasma VM from an Anaconda installer ISO with
libvirt/QEMU. The command verifies the signed ISO checksum, retains evidence,
runs an SSH check, then removes the VM and its disk.
EOF
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        dry_run=true
        ;;
      --release|--iso-url|--checksum-url|--checksum-signature-url|--fedora-key-fingerprint|--evidence-dir|--iso-cache)
        [[ $# -ge 2 ]] || stop "Missing value for $1."
        case "$1" in
          --release) fedora_release="$2" ;;
          --iso-url) iso_url="$2" ;;
          --checksum-url) checksum_url="$2" ;;
          --checksum-signature-url) checksum_signature_url="$2" ;;
          --fedora-key-fingerprint) fedora_key_fingerprint="${2^^}" ;;
          --evidence-dir) evidence_dir="$2" ;;
          --iso-cache) iso_cache="$2" ;;
        esac
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        stop "Unknown argument: $1."
        ;;
    esac
    shift
  done

  [[ -n "$fedora_release" ]] || stop "A Fedora release is required."
  [[ "$fedora_release" =~ ^[0-9]+$ ]] || stop "Fedora release must be a number."
}

print_plan() {
  cat <<EOF
Fedora KDE Plasma VM plan
Fedora release: $fedora_release
Provider: libvirt/QEMU
Firmware: UEFI
Memory: $vm_memory_mib MiB
Disk: $vm_disk_gib GiB
vCPUs: $vm_vcpus
Network: $vm_network
Non-root test user: $test_user
SDDM KDE Plasma auto-login: enabled
SSH check: pgrep plasmashell as $test_user
Cleanup: remove VM and disk after the run
Evidence directory: $evidence_dir
EOF
}

require_arguments_for_run() {
  [[ -n "$iso_url" ]] || stop "An ISO URL is required."
  [[ -n "$checksum_url" ]] || stop "A checksum URL is required."
  [[ -n "$checksum_signature_url" ]] || stop "A checksum signature URL is required."
  [[ "$fedora_key_fingerprint" =~ ^[0-9A-F]{40}$ ]] || stop "A 40-character Fedora signing-key fingerprint is required."
}

require_commands() {
  local command
  for command in awk curl gpg sha256sum ssh ssh-keygen virsh virt-install; do
    command -v "$command" >/dev/null || stop "Required command is unavailable: $command."
  done
}

cleanup() {
  local status=$?

  if [[ "$vm_created" == true ]]; then
    virsh destroy "$vm_name" >/dev/null 2>&1 || true
    virsh undefine "$vm_name" --nvram --remove-all-storage >/dev/null 2>&1 || true
  fi

  [[ -z "$work_dir" ]] || rm -rf "$work_dir"
  exit "$status"
}

download() {
  local source_url="$1"
  local target_file="$2"

  printf 'download %s\n' "$source_url" >> "$evidence_dir/acquisition.log"
  curl --fail --location --retry 3 --output "$target_file" "$source_url" >> "$evidence_dir/acquisition.log" 2>&1
}

write_kickstart() {
  local public_key

  public_key="$(<"$work_dir/id_ed25519.pub")"
  cat > "$work_dir/fedora-kde.ks" <<EOF
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
  local signature_file="$3"
  local key_file="$4"
  local expected_checksum
  local actual_checksum
  local iso_name

  iso_name="$(basename "$iso_file")"
  gpg --no-default-keyring --keyring "$work_dir/fedora-release-keys.gpg" --import "$key_file" >/dev/null
  gpg --no-default-keyring --keyring "$work_dir/fedora-release-keys.gpg" --with-colons --list-keys "$fedora_key_fingerprint" | awk -F: -v expected="$fedora_key_fingerprint" '$1 == "fpr" && $10 == expected { found = 1 } END { exit !found }' || stop "Fedora signing key does not match the selected fingerprint."
  gpg --no-default-keyring --keyring "$work_dir/fedora-release-keys.gpg" --verify "$signature_file" "$checksum_file" > "$evidence_dir/checksum-signature.log" 2>&1
  expected_checksum="$(awk -v name="$iso_name" '$0 ~ "SHA256.*\\(" name "\\)" { print $NF }' "$checksum_file")"
  [[ -n "$expected_checksum" ]] || stop "Checksum file has no SHA256 value for $iso_name."
  actual_checksum="$(sha256sum "$iso_file" | awk '{print $1}')"
  [[ "$actual_checksum" == "$expected_checksum" ]] || stop "ISO checksum verification failed."

  printf 'iso_sha256=%s\n' "$actual_checksum" >> "$evidence_dir/run-metadata.env"
}

wait_for_ssh() {
  local address=""
  local attempt

  for attempt in $(seq 1 60); do
    address="$(virsh domifaddr "$vm_name" --source lease 2>/dev/null | awk '/ipv4/ { sub("/.*", "", $4); print $4; exit }')"
    if [[ -n "$address" ]] && ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new -i "$work_dir/id_ed25519" "$test_user@$address" 'pgrep -x plasmashell >/dev/null' >> "$evidence_dir/ssh-check.log" 2>&1; then
      printf '{"result":"passed","check":"KDE Plasma session available through SSH"}\n' > "$evidence_dir/ssh-check.json"
      return 0
    fi
    sleep 5
  done

  printf '{"result":"failed","check":"KDE Plasma session available through SSH"}\n' > "$evidence_dir/ssh-check.json"
  stop "SSH check did not find a KDE Plasma session."
}

run_vm() {
  local timestamp
  local iso_name
  local iso_file
  local checksum_file
  local signature_file
  local key_file

  require_arguments_for_run
  require_commands
  timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
  vm_name="dotfiles-v2-fedora-kde-$timestamp"
  evidence_dir="$evidence_dir/$vm_name"
  mkdir -p "$evidence_dir" "$iso_cache"
  work_dir="$(mktemp -d)"
  trap cleanup EXIT
  printf 'run_started_at=%s\nvm_name=%s\nprovider=libvirt/QEMU\nfirmware=UEFI\nfedora_release=%s\niso_url=%s\nchecksum_url=%s\nchecksum_signature_url=%s\nfedora_key_fingerprint=%s\nvcpus=%s\nmemory_mib=%s\ndisk_gib=%s\nnetwork=%s\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$vm_name" "$fedora_release" "$iso_url" "$checksum_url" "$checksum_signature_url" "$fedora_key_fingerprint" "$vm_vcpus" "$vm_memory_mib" "$vm_disk_gib" "$vm_network" > "$evidence_dir/run-metadata.env"

  iso_name="$(basename "${iso_url%%\?*}")"
  iso_file="$iso_cache/$iso_name"
  checksum_file="$work_dir/CHECKSUM"
  signature_file="$work_dir/CHECKSUM.asc"
  key_file="$work_dir/fedora.gpg"
  download "$checksum_url" "$checksum_file"
  download "$checksum_signature_url" "$signature_file"
  download "$fedora_key_url" "$key_file"
  [[ -f "$iso_file" ]] || download "$iso_url" "$iso_file"
  verify_iso "$iso_file" "$checksum_file" "$signature_file" "$key_file"
  ssh-keygen -q -t ed25519 -N '' -f "$work_dir/id_ed25519"
  write_kickstart

  vm_created=true
  virt-install \
    --name "$vm_name" \
    --memory "$vm_memory_mib" \
    --vcpus "$vm_vcpus" \
    --disk "size=$vm_disk_gib" \
    --network "network=$vm_network" \
    --os-variant fedora-unknown \
    --boot uefi \
    --graphics spice \
    --noautoconsole \
    --location "$iso_file" \
    --initrd-inject "$work_dir/fedora-kde.ks" \
    --extra-args 'inst.ks=file:/fedora-kde.ks console=ttyS0,115200n8' \
    --wait 0 > "$evidence_dir/virt-install.log" 2>&1
  wait_for_ssh
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
