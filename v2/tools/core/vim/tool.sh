#!/usr/bin/env bash
# Vim installation module

set -e

# Tool metadata
TOOL_NAME="vim"
TOOL_DESCRIPTION="Classic text editor"
TOOL_CATEGORY="core"

# Package names per OS
declare -A PACKAGES=(
  [ubuntu]="vim"
)

# Install package
function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

# Symlink configuration files
function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  symlink_file "${tool_dir}/.vimrc" "${HOME}/.vimrc"
}

# Main entry point
function main() {
  install_package
  link_configs
}
