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
  [[ "$output" == *"Non-root test user: dotfiles-test"* ]]
  [[ "$output" == *"SDDM KDE Plasma auto-login: enabled"* ]]
  [[ "$output" == *"Cleanup: remove VM and disk after the run"* ]]
  [[ "$output" == *"No changes were made."* ]]
}

@test "Fedora KDE Plasma VM runner requires a selected Fedora release" {
  run "$VM_RUNNER" --dry-run

  [ "$status" -ne 0 ]
  [[ "$output" == *"A Fedora release is required"* ]]
}
