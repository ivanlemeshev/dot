#!/usr/bin/env bats

setup() {
  TEST_ROOT="$(mktemp -d)"
  ADAPTER="$BATS_TEST_DIRNAME/../packages/apt.sh"
  MANIFEST="$TEST_ROOT/common.txt"
  MOCK_BIN="$TEST_ROOT/bin"
  export TEST_ROOT

  mkdir -p "$MOCK_BIN"
  printf '%s\n' git >"$MANIFEST"
  printf '%s\n' '#!/usr/bin/env bash' 'exec "$@"' >"$MOCK_BIN/sudo"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "$*" >>"$TEST_ROOT/commands"' >"$MOCK_BIN/apt-get"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "$*" >>"$TEST_ROOT/commands"' >"$MOCK_BIN/dnf"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "$*" >>"$TEST_ROOT/commands"' >"$MOCK_BIN/pacman"
  printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "$*" >>"$TEST_ROOT/commands"' >"$MOCK_BIN/brew"
  chmod +x "$MOCK_BIN/sudo" "$MOCK_BIN/apt-get" "$MOCK_BIN/dnf" "$MOCK_BIN/pacman" "$MOCK_BIN/brew"
}

@test "dnf adapter installs manifest capabilities" {
  run env PATH="$MOCK_BIN:$PATH" "$BATS_TEST_DIRNAME/../packages/dnf.sh" "$MANIFEST"

  [ "$status" -eq 0 ]
  [ "$(<"$TEST_ROOT/commands")" = "install -y git" ]
}

@test "pacman adapter installs manifest capabilities" {
  run env PATH="$MOCK_BIN:$PATH" "$BATS_TEST_DIRNAME/../packages/pacman.sh" "$MANIFEST"

  [ "$status" -eq 0 ]
  [ "$(<"$TEST_ROOT/commands")" = "-S --needed --noconfirm git" ]
}

@test "brew adapter installs manifest capabilities" {
  run env PATH="$MOCK_BIN:$PATH" "$BATS_TEST_DIRNAME/../packages/brew.sh" "$MANIFEST"

  [ "$status" -eq 0 ]
  [ "$(<"$TEST_ROOT/commands")" = "install git" ]
}

@test "brew adapter reports a missing Homebrew prerequisite" {
  run env PATH="/usr/bin:/bin" "$BATS_TEST_DIRNAME/../packages/brew.sh" "$MANIFEST"

  [ "$status" -eq 2 ]
  [[ "$output" == *"Homebrew is required"* ]]
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "apt adapter installs manifest capabilities" {
  run env PATH="$MOCK_BIN:$PATH" "$ADAPTER" "$MANIFEST"

  [ "$status" -eq 0 ]
  [ "$(<"$TEST_ROOT/commands")" = $'update\ninstall -y git' ]
}
