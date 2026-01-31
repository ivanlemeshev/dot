#!/usr/bin/env bash
# Neovim installation module

set -e

# Tool metadata
TOOL_NAME="neovim"
TOOL_DESCRIPTION="Modern Vim-based editor"
TOOL_CATEGORY="core"

# Neovim version to install
NVIM_VERSION="v0.10.2"

# Install neovim
function install_package() {
  if command -v nvim > /dev/null 2>&1; then
    local current_version
    current_version="$(nvim --version | head -n1 | awk '{print $2}')"
    print_info "Neovim already installed: $current_version"
    return
  fi

  print_info "Installing Neovim ${NVIM_VERSION}..."

  # Download and install neovim
  local nvim_url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
  local temp_file="/tmp/nvim-linux64.tar.gz"

  wget -q "$nvim_url" -O "$temp_file"
  sudo tar -C /opt -xzf "$temp_file"
  sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
  rm "$temp_file"

  print_success "Neovim ${NVIM_VERSION} installed"
}

# Symlink configuration files
function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Create nvim config directory
  mkdir -p "${HOME}/.config"

  # Link entire nvim directory
  symlink_dir "${tool_dir}/nvim" "${HOME}/.config/nvim"

  print_info "Neovim plugins will install automatically on first launch"
}

# Main entry point
function main() {
  install_package
  link_configs
}
