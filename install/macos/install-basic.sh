#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: basic packages"

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
brew install --cask rio
