#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get script path and directory
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"

source "${PROJECT_ROOT}/lib/print_header.sh"
source "${PROJECT_ROOT}/lib/prompt_input.sh"

print_header "Configuring the current git repository"

git_user_email=$(prompt_input "What the user email do you want to use?")
git config user.email "${git_user_email}"

git_user_name=$(prompt_input "What the user name do you want to use?")
git config user.name "${git_user_name}"

print_header "Git configuration"
git config --list
