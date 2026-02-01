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

  echo ""
  echo -e "${BLUE}${line}${RESET}"
  echo -e "${BLUE}  $title${RESET}"
  echo -e "${BLUE}${line}${RESET}"
  echo ""
}

# Print a subheader (for tools, smaller sections)
function ui.print_subheader() {
  echo -e "${BLUE}📦${RESET} $*"
}

# Print an info message
function ui.print_info() {
  echo -e "${BLUE}💡${RESET} $*"
}

# Print a success message
function ui.print_success() {
  echo -e "${GREEN}✅${RESET} $*"
}

# Print an error message
function ui.print_error() {
  echo -e "${RED}❌${RESET} $*" >&2
}

# Print a warning message
function ui.print_warning() {
  echo -e "${YELLOW}⚠️${RESET} $*" >&2
}
