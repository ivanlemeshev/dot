#!/usr/bin/env bats

@test "terminal palettes match the requested Tomorrow Night colors" {
  run python3 "$BATS_TEST_DIRNAME/check_terminal_colors.py"
  [ "$status" -eq 0 ]
}
