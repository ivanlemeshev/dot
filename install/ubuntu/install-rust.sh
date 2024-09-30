#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Rust: installing"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
exec bash -l
rustup default stable
rustup completions fish >~/.config/fish/completions/rustup.fish
exit
