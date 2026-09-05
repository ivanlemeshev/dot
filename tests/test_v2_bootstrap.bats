#!/usr/bin/env bats

setup() {
  export BOOTSTRAP="$BATS_TEST_DIRNAME/../v2/bootstrap.sh"
}

require_fedora() {
  if ! grep -qx 'ID=fedora' /etc/os-release; then
    skip "requires Fedora"
  fi
}

require_fedora_kde_with_sudo() {
  require_fedora

  if ! /usr/bin/pgrep -u "$(/usr/bin/id -u)" -x plasmashell >/dev/null; then
    skip "requires a KDE Plasma session"
  fi

  if ! /usr/bin/sudo -n -v; then
    skip "requires active sudo access"
  fi
}

@test "Bootstrap previews Fedora KDE Plasma privileged actions" {
  require_fedora_kde_with_sudo

  run "$BOOTSTRAP"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Target platform: Fedora KDE Plasma"* ]]
  [[ "$output" == *"Planned privileged actions:"* ]]
  [[ "$output" == *"No changes were made."* ]]
}

@test "Bootstrap refuses an unsupported platform before changes" {
  run env XDG_CURRENT_DESKTOP=GNOME "$BOOTSTRAP"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Unsupported target platform"* ]]
  [[ "$output" == *"No changes were made."* ]]
}

@test "Bootstrap refuses a non-KDE Fedora desktop before changes" {
  require_fedora

  run env XDG_CURRENT_DESKTOP=GNOME "$BOOTSTRAP"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Unsupported target platform"* ]]
  [[ "$output" == *"No changes were made."* ]]
}

@test "Bootstrap refuses a desktop name that only contains KDE" {
  require_fedora

  run env XDG_CURRENT_DESKTOP=NOTKDE "$BOOTSTRAP"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Unsupported target platform"* ]]
  [[ "$output" == *"No changes were made."* ]]
}

@test "Bootstrap refuses to run as root" {
  require_fedora_kde_with_sudo

  run /usr/bin/sudo -n env XDG_CURRENT_DESKTOP=KDE "$BOOTSTRAP"

  [ "$status" -ne 0 ]
  [[ "$output" == *"normal user"* ]]
  [[ "$output" == *"No changes were made."* ]]
}
