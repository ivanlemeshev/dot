#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Rust: installing"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
. "${HOME}/.cargo/env"

print_header "Rust: setting default toolchain"
rustup default stable

print_header "Rust: adding completions"
[[ -d "${HOME}/.config/fish/completions/" ]] || mkdir -p "${HOME}/.config/fish/completions/"
rustup completions fish >"${HOME}/.config/fish/completions/rustup.fish"
