#!/usr/bin/env bats

setup() {
  TEST_ROOT="$(mktemp -d)"
  source "${BATS_TEST_DIRNAME}/../lib/log.sh"
  source "${BATS_TEST_DIRNAME}/../lib/link.sh"
  LOG_COLORS=false
  LOG_TIMESTAMPS=false
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "link_directory creates the requested symlink" {
  mkdir -p "$TEST_ROOT/source"

  link_directory "$TEST_ROOT/source" "$TEST_ROOT/config/skills" "Test skills"

  [ -L "$TEST_ROOT/config/skills" ]
  [ "$(readlink "$TEST_ROOT/config/skills")" = "$TEST_ROOT/source" ]
}

@test "link_directory is idempotent for the same source" {
  mkdir -p "$TEST_ROOT/source"
  link_directory "$TEST_ROOT/source" "$TEST_ROOT/config/skills" "Test skills"

  run link_directory "$TEST_ROOT/source" "$TEST_ROOT/config/skills" "Test skills"

  [ "$status" -eq 0 ]
  [[ "$output" == *"already linked"* ]]
  [ -z "$(find "$TEST_ROOT/config" -maxdepth 1 -name 'skills.backup.*' -print -quit)" ]
}

@test "link_directory preserves an existing directory as a backup" {
  mkdir -p "$TEST_ROOT/source" "$TEST_ROOT/config/skills"
  printf '%s\n' "personal" >"$TEST_ROOT/config/skills/existing.txt"

  link_directory "$TEST_ROOT/source" "$TEST_ROOT/config/skills" "Test skills"

  backup_path="$(find "$TEST_ROOT/config" -maxdepth 1 -type d -name 'skills.backup.*' -print -quit)"
  [ -n "$backup_path" ]
  [ "$(<"$backup_path/existing.txt")" = "personal" ]
  [ -L "$TEST_ROOT/config/skills" ]
}
