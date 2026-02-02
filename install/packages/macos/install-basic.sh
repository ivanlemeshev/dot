#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

echo "=== Installing basic packages ==="

packages=(
  "asdf"
  "bottom"
  "buf"
  "direnv"
  "fd"
  "fzf"
  "gemini-cli"
  "go"
  "golangci-lint"
  "lazygit"
  "lua"
  "luarocks"
  "node"
  "openssl"
  "readline"
  "ripgrep"
  "sqlite3"
  "tcl-tk"
  "terraform"
  "tree"
  "uv"
  "vivid"
  "wget"
  "xz"
  "zlib"
)

brew install ${packages[*]}
