#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
bash -l
rustup default stable
rustup completions fish >~/.config/fish/completions/rustup.fish
