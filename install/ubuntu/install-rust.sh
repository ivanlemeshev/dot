#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Rust: installing"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
# shellcheck source=/dev/null
. "${HOME}/.cargo/env"

print_header "Rust: setting default toolchain"
rustup default stable

print_header "Rust: adding completions"
[[ -d "${HOME}/.config/fish/completions/" ]] || mkdir -p "${HOME}/.config/fish/completions/"
rustup completions fish >"${HOME}/.config/fish/completions/rustup.fish"
