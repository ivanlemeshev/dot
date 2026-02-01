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
  local line=$(printf '%80s' | tr ' ' '=')

  printf '\n'
  printf "${BLUE}%s${RESET}\n" "${line}"
  printf "${BLUE}  %s${RESET}\n" "$title"
  printf "${BLUE}%s${RESET}\n" "${line}"
  printf '\n'
}

# Print a subheader (for tools, smaller sections)
function ui.print_subheader() {
  printf "${BLUE}📦${RESET} %s\n" "$*"
}

# Print an info message
function ui.print_info() {
  printf "${BLUE}💡${RESET} %s\n" "$*"
}

# Print a success message
function ui.print_success() {
  printf "${GREEN}✅${RESET} %s\n" "$*"
}

# Print an error message
function ui.print_error() {
  printf "${RED}❌${RESET} %s\n" "$*" >&2
}

# Print a warning message
function ui.print_warning() {
  printf "${YELLOW}⚠️${RESET} %s\n" "$*" >&2
}
