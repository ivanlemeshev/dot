#!/usr/bin/env bash
# UI functions for user-friendly output

# Color Definitions
BLUE='\e[34m'
GREEN='\e[32m'
RED='\e[31m'
YELLOW='\e[33m'
RESET='\e[0m' #resets the color to default

# Print a header with simple ASCII box
function ui.print_header() {
  local title="$*"
  local width=80
  local padding=$((width - 2 - ${#title}))

  # Top border
  printf '='
  for ((i = 0; i < width - 2; i++)); do
    printf '='
  done
  printf '=\n'

  # Title line
  printf '  %s' "$title"
  for ((i = 0; i < padding - 1; i++)); do
    printf ' '
  done
  printf '\n'

  # Bottom border
  printf '='
  for ((i = 0; i < width - 2; i++)); do
    printf '='
  done
  printf '=\n'
}

# Print an info message
function ui.print_info() {
  echo -e "${BLUE}[INFO]${RESET} $*"
}

# Print a success message
function ui.print_success() {
  echo -e "${GREEN}[ OK ]${RESET} $*"
}

# Print an error message
function ui.error() {
  echo -e "${RED}[FAIL]${RESET} $*" >&2
}

# Print a warning message
function ui.print_warning() {
  echo -e "${YELLOW}[WARN]${RESET} $*" >&2
}
