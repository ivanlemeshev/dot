#!/usr/bin/env bash
# Rust programming language installation module

set -e

# Tool metadata
TOOL_NAME="rust"
TOOL_DESCRIPTION="Rust programming language"
TOOL_CATEGORY="optional"

# Install Rust via rustup
function install_package() {
  if command -v rustc > /dev/null 2>&1; then
    local current_version
    current_version="$(rustc --version | awk '{print $2}')"
    ui.print_info "Rust already installed: v${current_version}"
    return
  fi

  ui.print_info "Installing Rust via rustup..."

  # Install rustup
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  # Source cargo env
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"

  ui.print_success "Rust installed successfully"
}

# Post-install hook
function post_install() {
  # Install fish completions
  if command -v rustup > /dev/null 2>&1; then
    ui.print_info "Installing fish completions for Rust..."
    mkdir -p "${HOME}/.config/fish/completions"
    rustup completions fish > "${HOME}/.config/fish/completions/rustup.fish"
  fi

  ui.print_info "Cargo is available at: ~/.cargo/bin/cargo"
  ui.print_info "Environment is configured in fish config"
}

# Main entry point
function main() {
  install_package
  post_install
}
