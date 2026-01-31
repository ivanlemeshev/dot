#!/usr/bin/env bash
# Tmux installation module

set -e

# Tool metadata
TOOL_NAME="tmux"
TOOL_DESCRIPTION="Terminal multiplexer"
TOOL_CATEGORY="core"

# Package names per OS
declare -A PACKAGES=(
  [ubuntu]="tmux"
)

# Install package
function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

# Post-install hook
function post_install() {
  # Install TPM (Tmux Plugin Manager)
  local tpm_dir="${HOME}/.tmux/plugins/tpm"

  if [[ ! -d "$tpm_dir" ]]; then
    ui.print_info "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  else
    ui.print_info "TPM already installed"
  fi

  ui.print_info "To install tmux plugins, press: Ctrl+Space I inside tmux"
}

# Symlink configuration files
function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  symlink_file "${tool_dir}/.tmux.conf" "${HOME}/.tmux.conf"
}

# Main entry point
function main() {
  install_package
  post_install
  link_configs
}
