#!/usr/bin/env bash
# Lazygit installation module

set -e

# Tool metadata
TOOL_NAME="lazygit"
TOOL_DESCRIPTION="Simple terminal UI for git commands"
TOOL_CATEGORY="optional"

# Install via go install
function install_package() {
  if command -v lazygit >/dev/null 2>&1; then
    local current_version
    current_version="$(lazygit --version | head -n1 | awk '{print $6}' | tr -d ',')"
    ui.print_info "Lazygit already installed: v${current_version}"
    return
  fi

  # Check if Go is installed
  if ! command -v go >/dev/null 2>&1; then
    ui.print_error "Go is required to install lazygit"
    ui.print_error "Please install Go first (it's in optional tools)"
    return 1
  fi

  ui.print_info "Installing lazygit via go install..."

  # Source Go environment if needed
  export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

  go install github.com/jesseduffield/lazygit@latest

  ui.print_success "Lazygit installed to ~/go/bin/lazygit"
}

# Symlink configuration files
function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  mkdir -p "${HOME}/.config/lazygit"

  if [ -f "${tool_dir}/config/config.yml" ]; then
    symlink_file "${tool_dir}/config/config.yml" "${HOME}/.config/lazygit/config.yml"
  else
    ui.print_warning "Lazygit config file not found, skipping"
  fi
}

# Main entry point
function main() {
  install_package
  link_configs
}
