#!/bin/bash

set -e

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
