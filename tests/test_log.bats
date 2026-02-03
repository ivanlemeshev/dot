#!/usr/bin/env bats

# Tests for lib/log.sh

setup() {
  # Source the library before each test
  source "${BATS_TEST_DIRNAME}/../lib/log.sh"

  # Disable colors for consistent testing
  LOG_COLORS=false

  # Reset log level
  LOG_LEVEL=$LOG_LEVEL_INFO

  # Disable timestamps for predictable output
  LOG_TIMESTAMPS=false
}

@test "log_info outputs correct format" {
  run log_info "test message"
  [ "$status" -eq 0 ]
  [[ "$output" == "[*] test message" ]]
}

@test "log_success outputs correct format" {
  run log_success "success message"
  [ "$status" -eq 0 ]
  [[ "$output" == "[+] success message" ]]
}

@test "log_warn outputs correct format" {
  run log_warn "warning message"
  [ "$status" -eq 0 ]
  [[ "$output" == "[!] warning message" ]]
}

@test "log_error outputs to stderr" {
  run log_error "error message"
  [ "$status" -eq 0 ]
  # Error goes to stderr, so output will be empty in run
  [[ "$output" == "[x] error message" ]]
}

@test "log_debug is hidden by default" {
  run log_debug "debug message"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "log_debug is visible when level is DEBUG" {
  LOG_LEVEL=$LOG_LEVEL_DEBUG
  run log_debug "debug message"
  [ "$status" -eq 0 ]
  [[ "$output" == "[-] debug message" ]]
}

@test "log_set_level changes log level" {
  log_set_level debug
  [ "$LOG_LEVEL" -eq "$LOG_LEVEL_DEBUG" ]

  log_set_level warn
  [ "$LOG_LEVEL" -eq "$LOG_LEVEL_WARN" ]
}

@test "log_set_level rejects invalid level" {
  run log_set_level invalid
  [ "$status" -eq 1 ]
}

@test "log_enable_timestamps adds timestamps" {
  log_enable_timestamps
  run log_info "test"
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^\[[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}\]\ \[\*\]\ test$ ]]
}

@test "log_command runs successful command" {
  run log_command "Test command" true
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Test command..." ]]
  [[ "$output" =~ "Test command completed" ]]
}

@test "log_command detects failed command" {
  run log_command "Failing command" false
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Failing command..." ]]
  [[ "$output" =~ "Failing command failed" ]]
}

@test "log_file creates log file" {
  local tmpfile="/tmp/bats-test-$$.log"

  log_set_file "$tmpfile"
  log_info "test message"

  [ -f "$tmpfile" ]
  grep -q "test message" "$tmpfile"

  rm -f "$tmpfile"
}

@test "log levels filter correctly" {
  LOG_LEVEL=$LOG_LEVEL_WARN

  # Info should be hidden
  run log_info "info"
  [ -z "$output" ]

  # Warn should be visible
  run log_warn "warning"
  [[ "$output" == "[!] warning" ]]

  # Error should be visible
  run log_error "error"
  [[ "$output" == "[x] error" ]]
}

@test "log_fatal exits with default code 1" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/log.sh; LOG_COLORS=false; log_fatal 'fatal error'"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "fatal error" ]]
  [[ "$output" =~ "[x]" ]]
}

@test "log_fatal exits with custom code" {
  run bash -c "source ${BATS_TEST_DIRNAME}/../lib/log.sh; LOG_COLORS=false; log_fatal 'fatal error' 42"
  [ "$status" -eq 42 ]
  [[ "$output" =~ "fatal error" ]]
  [[ "$output" =~ "[x]" ]]
}
