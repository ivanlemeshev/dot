#!/bin/bash

# print.sh - Formatting and printing functions for shell scripts
# Usage: source lib/print.sh

# ANSI color codes (for standalone use)
readonly PRINT_COLOR_RESET="\033[0m"
readonly PRINT_COLOR_CYAN="\033[0;36m"
readonly PRINT_COLOR_GRAY="\033[0;90m"
readonly PRINT_COLOR_BOLD_BLUE="\033[1;34m"
readonly PRINT_COLOR_GREEN="\033[0;32m"

# Enable/disable colors (can be overridden)
PRINT_COLORS=${PRINT_COLORS:-true}

# Use LOG_COLORS if available (for consistency when both log.sh and print.sh are sourced)
if [[ -n "${LOG_COLORS+x}" ]]; then
  PRINT_COLORS=$LOG_COLORS
fi

# print_section prints a formatted section header
# Usage:
#   print_section "Installing Dependencies"
#   print_section "Configuration" 50
#
# Output:
#   ========================================
#   Installing Dependencies
#   ========================================
print_section() {
  local message="$1"
  local width="${2:-40}"
  local separator
  separator=$(printf '=%.0s' $(seq 1 "$width"))

  if [[ "$PRINT_COLORS" == true && -t 1 ]]; then
    echo -e "\n${PRINT_COLOR_BOLD_BLUE}${separator}${PRINT_COLOR_RESET}"
    echo -e "${PRINT_COLOR_BOLD_BLUE}${message}${PRINT_COLOR_RESET}"
    echo -e "${PRINT_COLOR_BOLD_BLUE}${separator}${PRINT_COLOR_RESET}\n"
  else
    echo -e "\n${separator}"
    echo -e "${message}"
    echo -e "${separator}\n"
  fi
}

# print_step prints a step indicator
# Usage:
#   print_step 1 5 "Installing packages"
#   print_step 2 5 "Configuring settings"
#
# Output: [1/5] Installing packages
print_step() {
  local current="$1"
  local total="$2"
  local message="$3"

  local step_info="[${current}/${total}]"

  if [[ "$PRINT_COLORS" == true && -t 1 ]]; then
    echo -e "${PRINT_COLOR_CYAN}${step_info}${PRINT_COLOR_RESET} ${message}"
  else
    echo -e "${step_info} ${message}"
  fi
}

# print_separator prints a visual separator
# Usage:
#   print_separator
#   print_separator 60
#   print_separator 40 "-"
#
# Output: ----------------------------------------
print_separator() {
  local width="${1:-40}"
  local char="${2:--}"
  local separator=""

  for ((i = 0; i < width; i++)); do
    separator+="$char"
  done

  if [[ "$PRINT_COLORS" == true && -t 1 ]]; then
    echo -e "${PRINT_COLOR_GRAY}${separator}${PRINT_COLOR_RESET}"
  else
    echo "$separator"
  fi
}

# print_list prints a bulleted list item
# Usage:
#   print_list "First item"
#   print_list "Second item"
#
# Output:
#   • First item
#   • Second item
print_list() {
  local message="$1"
  local bullet="${2:-•}"

  if [[ "$PRINT_COLORS" == true && -t 1 ]]; then
    echo -e "  ${PRINT_COLOR_CYAN}${bullet}${PRINT_COLOR_RESET} ${message}"
  else
    echo -e "  ${bullet} ${message}"
  fi
}

# print_key_value prints a key-value pair
# Usage:
#   print_key_value "Name" "John Doe"
#   print_key_value "Status" "Active"
#
# Output:
#   Name:    John Doe
#   Status:  Active
print_key_value() {
  local key="$1"
  local value="$2"
  local key_width="${3:-15}"

  if [[ "$PRINT_COLORS" == true && -t 1 ]]; then
    printf "${PRINT_COLOR_CYAN}%-${key_width}s${PRINT_COLOR_RESET} %s\n" "${key}:" "$value"
  else
    printf "%-${key_width}s %s\n" "${key}:" "$value"
  fi
}

# print_progress prints a progress indicator
# Usage:
#   print_progress 30 100 "Downloading"
#   print_progress 75 100 "Installing"
#
# Output: [████████░░░░░░░░░░] 30% Downloading
print_progress() {
  local current="$1"
  local total="$2"
  local message="${3:-}"
  local width="${4:-20}"

  local percent=$((current * 100 / total))
  local filled=$((current * width / total))
  local empty=$((width - filled))

  local bar=""
  bar+=$(printf '█%.0s' $(seq 1 "$filled"))
  bar+=$(printf '░%.0s' $(seq 1 "$empty"))

  if [[ "$PRINT_COLORS" == true && -t 1 ]]; then
    printf "\r${PRINT_COLOR_GREEN}[${bar}]${PRINT_COLOR_RESET} %3d%% %s" "$percent" "$message"
  else
    printf "\r[${bar}] %3d%% %s" "$percent" "$message"
  fi

  # New line if complete
  if [[ $current -eq $total ]]; then
    echo ""
  fi
}

# print_enable_colors enables colored output
# Usage:
#   print_enable_colors
print_enable_colors() {
  PRINT_COLORS=true
}

# print_disable_colors disables colored output
# Usage:
#   print_disable_colors
print_disable_colors() {
  PRINT_COLORS=false
}
