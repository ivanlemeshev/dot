#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing essential packages"

packages=(
  "asdf"
  "awscli"
  "buf"
  "curl"
  "direnv"
  "fd"
  "fzf"
  "openssl"
  "readline"
  "ripgrep"
  "ruff"
  "sqlite3"
  "tcl-tk"
  "tree"
  "uv"
  "vivid"
  "wget"
  "xz"
  "zlib"
)

for package in "${packages[@]}"; do
  log_info "Installing $package"
  brew install "$package"
done
