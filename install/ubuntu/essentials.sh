#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

print_section "Installing essential packages via apt-get"

packages=(
  "curl" # A tool for transferring data from or to a server using URLs.
  "wget" # A network downloader to retrieve files from the web.
)

TOTAL_STEPS=$((${#packages[@]} + 1))
CURRENT_STEP=1

if [[ "${VERBOSE:-false}" == true ]]; then
  APT_QUIET="-q"
elif [[ "${VERY_VERBOSE:-false}" == true ]]; then
  APT_QUIET=""
else
  APT_QUIET="-qq"
fi

print_step "$CURRENT_STEP" "$TOTAL_STEPS" "Updating package lists"
sudo apt-get update $APT_QUIET
((CURRENT_STEP++))

for pkg in "${packages[@]}"; do
  print_step "$CURRENT_STEP" "$TOTAL_STEPS" "Installing $pkg"
  if dpkg -s "$pkg" &>/dev/null; then
    log_info "$pkg is already installed, skipping."
    packages=("${packages[@]/$pkg/}")
  else
    sudo apt-get install -y $APT_QUIET "$pkg"
  fi
  ((CURRENT_STEP++))
done
