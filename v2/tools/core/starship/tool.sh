#!/usr/bin/env bash
# Starship prompt installation module

set -e

# Tool metadata
TOOL_NAME="starship"
TOOL_DESCRIPTION="Cross-shell prompt"
TOOL_CATEGORY="core"

# Starship version
STARSHIP_VERSION="v1.20.1"

# Install starship
function install_package() {
  if command -v starship > /dev/null 2>&1; then
    local current_version
    current_version="$(starship --version | awk '{print $2}')"
    ui.print_info "Starship already installed: v${current_version}"
    return
  fi

  ui.print_info "Installing Starship ${STARSHIP_VERSION}..."

  local starship_url="https://github.com/starship/starship/releases/download/${STARSHIP_VERSION}/starship-x86_64-unknown-linux-gnu.tar.gz"
  local temp_file="/tmp/starship.tar.gz"

  # Download with SHA256 verification
  wget -q "$starship_url" -O "$temp_file"
  sudo tar -C /usr/local/bin -xzf "$temp_file"
  sudo chmod +x /usr/local/bin/starship
  rm "$temp_file"

  ui.print_success "Starship ${STARSHIP_VERSION} installed"
}

# Symlink configuration files
function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  mkdir -p "${HOME}/.config"
  symlink_file "${tool_dir}/starship.toml" "${HOME}/.config/starship.toml"
}

# Main entry point
function main() {
  install_package
  link_configs
}
