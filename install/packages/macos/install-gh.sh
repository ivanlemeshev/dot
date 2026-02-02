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

print_header "Installing: GitHub CLI"
brew install gh

print_header "Checking version: GitHub CLI"
gh --version

print_header "Configuring: GitHub CLI"
gh config set editor vim
gh config set pager less
gh config set git_protocol ssh --host github.com

print_header "Checking config: GitHub CLI"
gh config list
