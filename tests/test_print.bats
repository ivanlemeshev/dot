#!/usr/bin/env bats

# Tests for lib/print.sh

setup() {
  # Source the library before each test
  source "${BATS_TEST_DIRNAME}/../lib/print.sh"

  # Disable colors for consistent testing
  PRINT_COLORS=false
}

@test "print_section outputs formatted section" {
  run print_section "Test Section"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Test Section" ]]
  [[ "$output" =~ "================================================================================" ]]
}

@test "print_section respects custom width" {
  run print_section "Test" 20
  [ "$status" -eq 0 ]
  [[ "$output" =~ "====================" ]]
}

@test "print_separator outputs default separator" {
  run print_separator
  [ "$status" -eq 0 ]
  [[ "$output" == "--------------------------------------------------------------------------------" ]]
}

@test "print_separator respects custom width" {
  run print_separator 20
  [ "$status" -eq 0 ]
  [ "${#output}" -eq 20 ]
}

@test "print_separator uses custom character" {
  run print_separator 10 "="
  [ "$status" -eq 0 ]
  [[ "$output" == "==========" ]]
}

@test "print_step outputs step indicator" {
  run print_step 1 5 "First step"
  [ "$status" -eq 0 ]
  [[ "$output" == "[1/5] First step" ]]
}

@test "print_list outputs bulleted item" {
  run print_list "Test item"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Test item" ]]
  [[ "$output" =~ "•" ]]
}

@test "print_list uses custom bullet" {
  run print_list "Test item" "-"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "- Test item" ]]
}

@test "print_key_value outputs formatted pair" {
  run print_key_value "Name" "Value"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Name:" ]]
  [[ "$output" =~ "Value" ]]
}

@test "print_progress shows 0% at start" {
  run print_progress 0 100 "Loading"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "0%" ]]
  [[ "$output" =~ "Loading" ]]
}

@test "print_progress shows 100% at end" {
  run print_progress 100 100 "Complete"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "100%" ]]
  [[ "$output" =~ "Complete" ]]
}

@test "print_progress shows 50% midway" {
  run print_progress 50 100 "Processing"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "50%" ]]
}

@test "print_enable_colors sets PRINT_COLORS to true" {
  print_enable_colors
  [ "$PRINT_COLORS" == "true" ]
}

@test "print_disable_colors sets PRINT_COLORS to false" {
  print_disable_colors
  [ "$PRINT_COLORS" == "false" ]
}
