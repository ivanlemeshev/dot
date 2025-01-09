#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: basic packages"

packages=(
  "openssl"
  "readline"
  "sqlite3"
  "xz"
  "zlib"
  "tcl-tk"
  "vivid"
  "tree"
  "fd"
  "fzf"
  "bottom"
  "go"
  "node"
  "lazygit"
  "wget"
  "ripgrep"
  "uv"
  "terraform"
)

brew install ${packages[*]}
