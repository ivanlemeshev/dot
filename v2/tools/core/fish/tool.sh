#!/usr/bin/env bash
# Fish shell installation and configuration

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Add Fish PPA for the latest version
function pre_install() {
  if ! grep -q "fish-shell" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    ui.print_info "Adding Fish shell PPA..."
    sudo apt-add-repository -y ppa:fish-shell/release-3 >/dev/null 2>&1
    sudo apt-get update -qq >/dev/null 2>&1
  fi
}

# Install Fish shell
function install_package() {
  pkg_install "fish"
}

# Set Fish as the default shell
function post_install() {
  local fish_path
  fish_path="$(which fish)"

  # Add fish to /etc/shells if not present
  if ! grep -q "$fish_path" /etc/shells; then
    ui.print_info "Adding fish to /etc/shells..."
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  # Change default shell to fish
  if [[ "$SHELL" != "$fish_path" ]]; then
    ui.print_info "Setting fish as default shell..."
    sudo chsh -s "$fish_path" "$(whoami)"
  fi
}

# Link Fish configuration
function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  symlink_file "${tool_dir}/config.fish" "${HOME}/.config/fish/config.fish"
}

# Main entry point
function main() {
  pre_install
  install_package
  post_install
  link_configs
}
