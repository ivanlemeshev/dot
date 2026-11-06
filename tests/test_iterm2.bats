#!/usr/bin/env bats

setup() {
  TEST_ROOT="$(mktemp -d)"
  TEST_REPO="$TEST_ROOT/repository"
  TEST_HOME="$TEST_ROOT/home"
  PROFILE_DIR="$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles"
  PROFILE_SOURCE="$TEST_REPO/macos/iterm2/custom.json"
  PROFILE_TARGET="$PROFILE_DIR/custom.json"
  mkdir -p "$TEST_REPO/install/macos" "$TEST_REPO/lib" "$TEST_REPO/macos/iterm2" "$TEST_HOME"
  cp "$BATS_TEST_DIRNAME/../install/macos/iterm2.sh" "$TEST_REPO/install/macos/"
  cp "$BATS_TEST_DIRNAME/../lib/"{link,log,print}.sh "$TEST_REPO/lib/"
  cp "$BATS_TEST_DIRNAME/../macos/iterm2/custom.json" "$PROFILE_SOURCE"
}

teardown() {
  rm -rf "$TEST_ROOT"
}

run_installer() {
  run env HOME="$TEST_HOME" bash -c '
    brew() { :; }
    defaults() { :; }
    export -f brew defaults
    exec bash "$1"
  ' _ "$TEST_REPO/install/macos/iterm2.sh"
}

@test "iTerm2 keeps personal dynamic profiles active" {
  mkdir -p "$PROFILE_DIR"
  printf '%s\n' '{"Profiles": []}' >"$PROFILE_DIR/Personal.json"

  run_installer

  [ "$status" -eq 0 ]
  [ ! -L "$PROFILE_DIR" ]
  [ -f "$PROFILE_DIR/Personal.json" ]
  [ -L "$PROFILE_TARGET" ]
  [ "$(readlink "$PROFILE_TARGET")" = "$PROFILE_SOURCE" ]
}

@test "iTerm2 profile installation is idempotent" {
  run_installer
  [ "$status" -eq 0 ]

  run_installer

  [ "$status" -eq 0 ]
  [ ! -L "$PROFILE_DIR" ]
  [ "$(readlink "$PROFILE_TARGET")" = "$PROFILE_SOURCE" ]
  [ -z "$(find "$PROFILE_DIR" -name 'custom.json.backup.*' -print -quit)" ]
}

@test "iTerm2 replaces the legacy directory link without changing repository files" {
  mkdir -p "$(dirname "$PROFILE_DIR")"
  ln -s "$TEST_REPO/macos/iterm2" "$PROFILE_DIR"

  run_installer

  [ "$status" -eq 0 ]
  [ ! -L "$PROFILE_DIR" ]
  [ -L "$PROFILE_TARGET" ]
  [ "$(readlink "$PROFILE_TARGET")" = "$PROFILE_SOURCE" ]
  [ ! -L "$PROFILE_SOURCE" ]
  cmp "$PROFILE_SOURCE" "$BATS_TEST_DIRNAME/../macos/iterm2/custom.json"
}

@test "iTerm2 preserves an existing custom profile in a backup" {
  mkdir -p "$PROFILE_DIR"
  printf '%s\n' 'personal profile' >"$PROFILE_TARGET"

  run_installer

  [ "$status" -eq 0 ]
  [ -L "$PROFILE_TARGET" ]
  backup_path="$(find "$(dirname "$PROFILE_DIR")" -maxdepth 1 -type f -name 'custom.json.backup.*' -print -quit)"
  [ -n "$backup_path" ]
  [ "$(<"$backup_path")" = 'personal profile' ]
}
