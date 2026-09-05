#!/usr/bin/env bats

setup() {
  export VM_RUNNER="$BATS_TEST_DIRNAME/../v2/vm/run-fedora-kde.sh"
}

@test "Fedora KDE Plasma VM runner previews a safe fresh VM plan" {
  run "$VM_RUNNER" \
    --dry-run \
    --release 42 \
    --evidence-dir "$BATS_TEST_TMPDIR/evidence" \
    --iso-cache "$BATS_TEST_TMPDIR/iso-cache"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Fedora release: 42"* ]]
  [[ "$output" == *"Memory: 4096 MiB"* ]]
  [[ "$output" == *"Disk: 30 GiB"* ]]
  [[ "$output" == *"Network: default"* ]]
  [[ "$output" == *"Provider: libvirt/QEMU"* ]]
  [[ "$output" == *"Firmware: UEFI"* ]]
  [[ "$output" == *"Secure Boot: disabled"* ]]
  [[ "$output" == *"Non-root test user: dotfiles-test"* ]]
  [[ "$output" == *"SDDM KDE Plasma auto-login: enabled"* ]]
  [[ "$output" == *"Installer display: graphical"* ]]
  [[ "$output" == *"SSH timeout: 45 minutes"* ]]
  [[ "$output" == *"Cleanup: remove VM and disk after the run"* ]]
  [[ "$output" == *"No changes were made."* ]]
}

@test "Fedora KDE Plasma VM runner detects the Fedora release for a dry run" {
  run env FEDORA_RELEASE=42 "$VM_RUNNER" --dry-run

  [ "$status" -eq 0 ]
  [[ "$output" == *"Fedora release: 42"* ]]
}

@test "Fedora KDE Plasma VM runner previews a base build" {
  run "$VM_RUNNER" --dry-run --base-build --release 42

  [ "$status" -eq 0 ]
  [[ "$output" == *"Run mode: base"* ]]
  [[ "$output" == *"Base volume: dotfiles-v2-fedora-kde-base-42.qcow2"* ]]
}

@test "Fedora KDE Plasma VM runner rejects conflicting installation modes" {
  run "$VM_RUNNER" --dry-run --base-build --full-install --release 42

  [ "$status" -ne 0 ]
  [[ "$output" == *"Only one installation mode is allowed."* ]]
}

@test "Make exposes Fedora base and full VM runs" {
  run make -n vm-base-build vm-test-full

  [ "$status" -eq 0 ]
  [[ "$output" == *"--base-build"* ]]
  [[ "$output" == *"--full-install"* ]]
}
