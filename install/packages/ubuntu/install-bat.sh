#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get script and project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "${SCRIPT_PATH}")")")")"

source "${PROJECT_ROOT}/lib/print_header.sh"

print_header "Bat: installing"
sudo apt-get install -y bat

print_header "Bat: installing theme"
[[ -d "${HOME}/.config/bat/themes" ]] || mkdir -p "${HOME}/.config/bat/themes"
[[ -f "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" ]] || wget -O "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
batcat cache --build
