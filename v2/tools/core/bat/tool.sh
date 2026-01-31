#!/usr/bin/env bash
# Bat installation module

set -e

# Tool metadata
TOOL_NAME="bat"
TOOL_DESCRIPTION="Cat with syntax highlighting"
TOOL_CATEGORY="core"

# Package names per OS
declare -A PACKAGES=(
  [ubuntu]="bat"
)

# Install package
function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

# Post-install hook
function post_install() {
  # Download Catppuccin Mocha theme
  local bat_themes_dir="${HOME}/.config/bat/themes"
  local theme_file="${bat_themes_dir}/Catppuccin Mocha.tmTheme"

  if [[ ! -f "$theme_file" ]]; then
    ui.print_info "Installing Catppuccin Mocha theme for bat..."
    mkdir -p "$bat_themes_dir"
    wget -q "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme" -O "$theme_file"

    # Rebuild bat cache (on Ubuntu it's batcat)
    if command -v batcat > /dev/null 2>&1; then
      batcat cache --build > /dev/null 2>&1
    elif command -v bat > /dev/null 2>&1; then
      bat cache --build > /dev/null 2>&1
    fi

    ui.print_success "Catppuccin Mocha theme installed"
  else
    ui.print_info "Catppuccin Mocha theme already installed"
  fi

  # Note: On Ubuntu, bat is installed as batcat
  if command -v batcat > /dev/null 2>&1; then
    ui.print_info "bat is available as 'batcat' on Ubuntu"
    ui.print_info "Alias 'bat' is configured in fish config"
  fi
}

# Main entry point
function main() {
  install_package
  post_install
}
