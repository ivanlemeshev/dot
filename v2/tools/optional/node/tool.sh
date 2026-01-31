#!/usr/bin/env bash
# Node.js installation module via asdf

set -e

# Tool metadata
TOOL_NAME="node"
TOOL_DESCRIPTION="Node.js JavaScript runtime"
TOOL_CATEGORY="optional"

# Node.js version to install
NODE_VERSION="lts"

# Install asdf if not already installed
function install_asdf() {
  if [ -d "$HOME/.asdf" ]; then
    print_info "asdf already installed"
    return
  fi

  print_info "Installing asdf version manager..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1

  # Source asdf
  # shellcheck source=/dev/null
  source "$HOME/.asdf/asdf.sh"

  print_success "asdf installed"
}

# Install Node.js via asdf
function install_package() {
  # Source asdf if available
  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    # shellcheck source=/dev/null
    source "$HOME/.asdf/asdf.sh"
  fi

  if command -v node > /dev/null 2>&1; then
    local current_version
    current_version="$(node --version)"
    print_info "Node.js already installed: ${current_version}"
    return
  fi

  install_asdf

  print_info "Installing Node.js ${NODE_VERSION} via asdf..."

  # Add nodejs plugin
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true

  # Install Node.js
  asdf install nodejs "${NODE_VERSION}"
  asdf global nodejs "${NODE_VERSION}"

  print_success "Node.js ${NODE_VERSION} installed"
}

# Post-install hook
function post_install() {
  print_info "Node.js is managed by asdf"
  print_info "asdf configuration is in fish config"
  print_info "Use 'asdf install nodejs <version>' to install other versions"
}

# Main entry point
function main() {
  install_package
  post_install
}
