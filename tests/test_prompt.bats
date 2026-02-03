#!/usr/bin/env bats

# Tests for lib/prompt.sh (interactive functions)

setup() {
  # Source the library before each test
  source "${BATS_TEST_DIRNAME}/../lib/prompt.sh"

  # Note: We redirect stderr to /dev/null in tests to hide prompts/colors
}

# Test prompt_yes_no with simulated input
@test "prompt_yes_no returns 0 for yes" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo 'y' | prompt_yes_no 'Test?' 2>/dev/null"
  [ "$status" -eq 0 ]
}

@test "prompt_yes_no returns 1 for no" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo 'n' | prompt_yes_no 'Test?' 2>/dev/null"
  [ "$status" -eq 1 ]
}

@test "prompt_yes_no accepts 'yes'" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo 'yes' | prompt_yes_no 'Test?' 2>/dev/null"
  [ "$status" -eq 0 ]
}

@test "prompt_yes_no accepts 'no'" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo 'no' | prompt_yes_no 'Test?' 2>/dev/null"
  [ "$status" -eq 1 ]
}

@test "prompt_yes_no uses default yes" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo '' | prompt_yes_no 'Test?' --default y 2>/dev/null"
  [ "$status" -eq 0 ]
}

@test "prompt_yes_no uses default no" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo '' | prompt_yes_no 'Test?' --default n 2>/dev/null"
  [ "$status" -eq 1 ]
}

@test "prompt_input returns user input" {
  result=$(echo 'test input' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_input 'Enter:' 2>/dev/null")
  [[ "$result" == "test input" ]]
}

@test "prompt_input uses default value" {
  result=$(echo '' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_input 'Enter:' --default 'default' 2>/dev/null")
  [[ "$result" == "default" ]]
}

@test "prompt_input trims whitespace" {
  result=$(echo '  test  ' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_input 'Enter:' 2>/dev/null")
  [[ "$result" == "test" ]]
}

@test "prompt_choice returns selected option" {
  result=$(echo '2' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_choice 'Choose:' 'A' 'B' 'C' 2>/dev/null")
  [[ "$result" == "B" ]]
}

@test "prompt_choice rejects invalid choice" {
  # First invalid (99), then valid (1) - capture both stdout and stderr
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; printf '99\n1\n' | prompt_choice 'Choose:' 'A' 'B' 'C' 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Invalid choice" ]]
  [[ "$output" =~ "A" ]]
}

@test "prompt_choice uses default" {
  result=$(echo '' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_choice 'Choose:' --default 2 'A' 'B' 'C' 2>/dev/null")
  [[ "$result" == "B" ]]
}

@test "prompt_multiselect returns multiple selections" {
  result=$(echo '1 3' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_multiselect 'Choose:' 'A' 'B' 'C' 2>/dev/null")
  [[ "$result" == "A C" ]]
}

@test "prompt_password returns hidden input" {
  # Note: password input is hidden, and prompt_password outputs newlines to stderr
  # We trim newlines from the result since echo in prompt adds them
  result=$(echo 'secret' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_password 'Password:' 2>/dev/null" | tr -d '\n')
  [[ "$result" == "secret" ]]
}

@test "prompt_password confirms matching passwords" {
  # Trim newlines from output
  result=$(printf 'secret\nsecret\n' | bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; prompt_password 'Password:' --confirm 2>/dev/null" | tr -d '\n')
  [[ "$result" == "secret" ]]
}

@test "prompt_password rejects non-matching passwords" {
  # First attempt fails, second succeeds - capture stderr to see error message
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; printf 'secret1\nsecret2\nsecret\nsecret\n' | prompt_password 'Password:' --confirm 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "do not match" ]]
  [[ "$output" =~ "secret" ]]
}

@test "prompt_path accepts valid path" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo '/tmp' | prompt_path 'Path:'"
  [ "$status" -eq 0 ]
  [[ "$output" == "/tmp" ]]
}

@test "prompt_path expands tilde" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; echo '~' | prompt_path 'Path:'"
  [ "$status" -eq 0 ]
  [[ "$output" == "$HOME" ]]
}

@test "prompt_path validates existing path" {
  # Capture stderr to see validation error
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/prompt.sh; printf '/nonexistent\n/tmp\n' | prompt_path 'Path:' --must-exist 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "does not exist" ]]
  [[ "$output" =~ "/tmp" ]]
}
