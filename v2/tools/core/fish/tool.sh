#!/usr/bin/env bash
# Fish shell installation module

set -e

# Tool metadata
TOOL_NAME="fish"
TOOL_DESCRIPTION="Friendly interactive shell"
TOOL_CATEGORY="core"

# Package names per OS
declare -A PACKAGES=(
  [ubuntu]="fish"
)

# Pre-install hook
function pre_install() {
  if [[ "$OS_TYPE" == "ubuntu" ]]; then
    ui.print_info "Adding Fish shell PPA..."
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt-get update -qq
  fi
}

# Install package
function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

# Post-install hook
function post_install() {
  local current_shell
  current_shell="$(basename "$SHELL")"

  # Change default shell to fish
  if [[ "$current_shell" != "fish" ]]; then
    ui.print_info "Changing default shell to fish"
    sudo chsh -s "$(which fish)" "$(whoami)"
  else
    ui.print_info "Fish is already the default shell"
  fi

  # Install Fisher plugin manager
  ui.print_info "Installing Fisher plugin manager"
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

  # Install fzf.fish plugin
  ui.print_info "Installing fzf.fish plugin"
  fish -c "fisher install PatrickF1/fzf.fish"
}

# Symlink configuration files
function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Create fish config directory
  mkdir -p "${HOME}/.config/fish"

  # Link config file
  symlink_file "${tool_dir}/config.fish" "${HOME}/.config/fish/config.fish"
}

# Main entry point
function main() {
  pre_install
  install_package
  post_install
  link_configs
}
