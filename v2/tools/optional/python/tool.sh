#!/usr/bin/env bash
# Python with UV package manager installation module

set -e

# Tool metadata
TOOL_NAME="python"
TOOL_DESCRIPTION="Python with UV package manager"
TOOL_CATEGORY="optional"

# Package names per OS
declare -A PACKAGES=(
  [ubuntu]="python3 python3-pip python3-venv"
)

# Install Python
function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

# Post-install hook
function post_install() {
  # Install UV (modern Python package manager)
  if command -v uv > /dev/null 2>&1; then
    ui.print_info "UV already installed"
  else
    ui.print_info "Installing UV (Python package manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    ui.print_success "UV installed to ~/.local/bin"
  fi

  ui.print_info "Python is installed"
  ui.print_info "UV is available at: ~/.local/bin/uv"
  ui.print_info "~/.local/bin is in PATH via fish config"
}

# Main entry point
function main() {
  install_package
  post_install
}
