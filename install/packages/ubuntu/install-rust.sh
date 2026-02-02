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

print_header "Rust: installing"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
. "${HOME}/.cargo/env"

print_header "Rust: setting default toolchain"
rustup default stable

print_header "Rust: adding completions"
[[ -d "${HOME}/.config/fish/completions/" ]] || mkdir -p "${HOME}/.config/fish/completions/"
rustup completions fish >"${HOME}/.config/fish/completions/rustup.fish"
