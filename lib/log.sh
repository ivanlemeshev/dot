#!/bin/bash

# log.sh - Core logging functions for shell scripts
# Usage: source lib/log.sh

# ANSI color codes
readonly LOG_COLOR_RESET="\033[0m"
readonly LOG_COLOR_RED="\033[0;31m"
readonly LOG_COLOR_GREEN="\033[0;32m"
readonly LOG_COLOR_YELLOW="\033[0;33m"
readonly LOG_COLOR_BLUE="\033[0;34m"
readonly LOG_COLOR_MAGENTA="\033[0;35m"
readonly LOG_COLOR_CYAN="\033[0;36m"
readonly LOG_COLOR_GRAY="\033[0;90m"

# Bold colors
readonly LOG_COLOR_BOLD_RED="\033[1;31m"
readonly LOG_COLOR_BOLD_GREEN="\033[1;32m"
readonly LOG_COLOR_BOLD_YELLOW="\033[1;33m"
readonly LOG_COLOR_BOLD_BLUE="\033[1;34m"

# Log level constants
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_SUCCESS=2
readonly LOG_LEVEL_WARN=3
readonly LOG_LEVEL_ERROR=4

# Default log level (INFO and above)
LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# Log file (empty by default, set to enable file logging)
LOG_FILE=${LOG_FILE:-}

# Enable/disable timestamps
LOG_TIMESTAMPS=${LOG_TIMESTAMPS:-false}

# Enable/disable colors
LOG_COLORS=${LOG_COLORS:-true}

# Internal function to format and output log messages
_log() {
  local level="$1"
  local level_num="$2"
  local color="$3"
  local message="$4"

  # Check if this log level should be shown
  if [[ $level_num -lt $LOG_LEVEL ]]; then
    return 0
  fi

  # Build the log message
  local output=""

  # Add timestamp if enabled
  if [[ "$LOG_TIMESTAMPS" == true ]]; then
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    output="[${timestamp}] "
  fi

  # Map level to symbol
  local symbol
  case "$level" in
    DEBUG) symbol="[-]" ;;
    INFO) symbol="[*]" ;;
    SUCCESS) symbol="[+]" ;;
    WARN) symbol="[!]" ;;
    ERROR) symbol="[x]" ;;
    FATAL) symbol="[x]" ;;
    *) symbol="[?]" ;;
  esac

  # Add color if enabled
  if [[ "$LOG_COLORS" == true && -t 1 ]]; then
    output="${output}${color}${symbol}${LOG_COLOR_RESET} ${message}"
  else
    output="${output}${symbol} ${message}"
  fi

  # Output to stdout/stderr
  if [[ $level_num -ge $LOG_LEVEL_ERROR ]]; then
    echo -e "$output" >&2
  else
    echo -e "$output"
  fi

  # Append to log file if configured
  if [[ -n "$LOG_FILE" ]]; then
    # Strip ANSI codes for file output
    local clean_output
    clean_output=$(echo -e "$output" | sed 's/\x1b\[[0-9;]*m//g')
    echo "$clean_output" >>"$LOG_FILE"
  fi
}

# log_debug prints a debug message (magenta color, [-] symbol)
# Usage:
#   log_debug "Variable value: $var"
#   log_debug "Entering function: ${FUNCNAME[0]}"
#
# Output: [-] Variable value: example
#
# Debug messages are hidden by default. To show them:
#   export LOG_LEVEL=$LOG_LEVEL_DEBUG
log_debug() {
  _log "DEBUG" "$LOG_LEVEL_DEBUG" "$LOG_COLOR_MAGENTA" "$*"
}

# log_info prints an informational message (blue color, [*] symbol)
# Usage:
#   log_info "Starting installation..."
#   log_info "Processing file: $filename"
#
# Output: [*] Starting installation...
#
# This is the default log level
log_info() {
  _log "INFO" "$LOG_LEVEL_INFO" "$LOG_COLOR_BLUE" "$*"
}

# log_success prints a success message (green color, [+] symbol)
# Usage:
#   log_success "Installation completed successfully"
#   log_success "File created: $filename"
#
# Output: [+] Installation completed successfully
#
# Use this for successful operations
log_success() {
  _log "SUCCESS" "$LOG_LEVEL_SUCCESS" "$LOG_COLOR_GREEN" "$*"
}

# log_warn prints a warning message (yellow color, [!] symbol)
# Usage:
#   log_warn "Configuration file not found, using defaults"
#   log_warn "Skipping optional dependency: $package"
#
# Output: [!] Configuration file not found, using defaults
#
# Use for non-critical issues
log_warn() {
  _log "WARN" "$LOG_LEVEL_WARN" "$LOG_COLOR_YELLOW" "$*"
}

# log_error prints an error message (red color, [x] symbol, goes to stderr)
# Usage:
#   log_error "Failed to install package: $package"
#   log_error "Invalid configuration in $config_file"
#
# Output: [x] Failed to install package: example
#
# Use for errors (does not exit, just logs)
log_error() {
  _log "ERROR" "$LOG_LEVEL_ERROR" "$LOG_COLOR_BOLD_RED" "$*"
}

# log_fatal prints a fatal error and exits
# Usage:
#   log_fatal "Cannot continue without required dependency"
#   log_fatal "Critical error occurred" 1  # Exit with code 1
#
# This will exit the script after logging
log_fatal() {
  local message="$1"
  local exit_code="${2:-1}"

  _log "FATAL" "$LOG_LEVEL_ERROR" "$LOG_COLOR_BOLD_RED" "$message"
  exit "$exit_code"
}

# log_command runs a command and logs its output
# Usage:
#   log_command "Installing package" apt-get install -y package
#   log_command "Building project" make build
#
# Runs the command and logs success/failure
log_command() {
  local description="$1"
  shift
  local command=("$@")

  log_info "${description}..."

  local output
  local exit_code

  if output=$("${command[@]}" 2>&1); then
    exit_code=0
  else
    exit_code=$?
  fi

  if [[ $exit_code -eq 0 ]]; then
    log_success "${description} completed"
    return 0
  else
    log_error "${description} failed (exit code: ${exit_code})"
    if [[ -n "$output" ]]; then
      log_debug "Command output:\n${output}"
    fi
    return "$exit_code"
  fi
}

# log_set_level sets the minimum log level
# Usage:
#   log_set_level debug
#   log_set_level warn
#   log_set_level error
#
# Available levels: debug, info, success, warn, error
log_set_level() {
  local level
  level="$(echo "$1" | tr '[:upper:]' '[:lower:]')"

  case "$level" in
    debug)
      LOG_LEVEL=$LOG_LEVEL_DEBUG
      ;;
    info)
      LOG_LEVEL=$LOG_LEVEL_INFO
      ;;
    success)
      LOG_LEVEL=$LOG_LEVEL_SUCCESS
      ;;
    warn | warning)
      LOG_LEVEL=$LOG_LEVEL_WARN
      ;;
    error)
      LOG_LEVEL=$LOG_LEVEL_ERROR
      ;;
    *)
      log_error "Invalid log level: $level"
      return 1
      ;;
  esac

  log_debug "Log level set to: $level"
}

# log_set_file sets the log file path
# Usage:
#   log_set_file "/var/log/script.log"
#   log_set_file ""  # Disable file logging
log_set_file() {
  LOG_FILE="$1"

  if [[ -n "$LOG_FILE" ]]; then
    # Create directory if needed
    local log_dir
    log_dir=$(dirname "$LOG_FILE")
    mkdir -p "$log_dir" 2>/dev/null || true

    # Create/clear log file
    : >"$LOG_FILE" 2>/dev/null || {
      log_error "Cannot write to log file: $LOG_FILE"
      LOG_FILE=""
      return 1
    }

    log_info "Logging to file: $LOG_FILE"
  fi
}

# log_enable_timestamps enables timestamp prefixes
# Usage:
#   log_enable_timestamps
log_enable_timestamps() {
  LOG_TIMESTAMPS=true
}

# log_disable_timestamps disables timestamp prefixes
# Usage:
#   log_disable_timestamps
log_disable_timestamps() {
  LOG_TIMESTAMPS=false
}

# log_enable_colors enables colored output
# Usage:
#   log_enable_colors
log_enable_colors() {
  LOG_COLORS=true
}

# log_disable_colors disables colored output
# Usage:
#   log_disable_colors
log_disable_colors() {
  LOG_COLORS=false
}
