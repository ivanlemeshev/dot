#!/usr/bin/env bash
# Fish shell - a smart and user-friendly command line shell with autosuggestions,
# syntax highlighting, and tab completions that work out of the box.

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Add Fish PPA for the latest version (Ubuntu only)
function pre_install() {
  case "$OS_TYPE" in
    ubuntu)
      if ! grep -q "fish-shell" /etc/apt/sources.list.d/*.list 2>/dev/null; then
        ui.print_info "Adding Fish shell PPA..."
        sudo apt-add-repository -y ppa:fish-shell/release-3 >/dev/null 2>&1
        sudo apt-get update -qq >/dev/null 2>&1
      fi
      ;;
    macos)
      # No PPA needed on macOS
      ;;
  esac
}

# Install Fish shell
function install_package() {
  if pkg_installed "fish" && [[ -z "${FORCE:-}" ]]; then
    ui.print_info "fish already installed, skipping (use FORCE=1 to reinstall)"
  else
    if [[ -n "${FORCE:-}" ]]; then
      ui.print_info "FORCE set, reinstalling fish..."
    fi
    pkg_install "fish"
  fi
}

# Set Fish as the default shell and install plugin manager
function post_install() {
  local fish_path
  fish_path="$(which fish)"

  # Add fish to /etc/shells if not present
  if ! grep -q "$fish_path" /etc/shells; then
    ui.print_info "Adding fish to /etc/shells..."
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  # Change default shell to fish (skip in CI)
  if [[ "$SHELL" != "$fish_path" ]] && [[ -z "${CI:-}" ]]; then
    ui.print_info "Setting fish as default shell..."
    case "$OS_TYPE" in
      ubuntu)
        sudo chsh -s "$fish_path" "$(whoami)"
        ;;
      macos)
        chsh -s "$fish_path"
        ;;
    esac
  elif [[ -n "${CI:-}" ]]; then
    ui.print_info "Skipping default shell change in CI environment"
  fi

  # Install fisher (fish plugin manager) if not already installed
  # https://github.com/jorgebucaran/fisher
  # Check for fisher function file directly to avoid hanging in Docker
  local fisher_file="${HOME}/.config/fish/functions/fisher.fish"

  if [[ -f "$fisher_file" ]] && [[ -z "${FORCE:-}" ]]; then
    ui.print_info "fisher already installed, skipping"
  else
    ui.print_info "Installing fish plugin manager (fisher)..."
    fish -C "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && exit"
  fi

  # Install catppuccin theme if not already installed
  # https://github.com/catppuccin/fish
  # Check fisher plugin file directly to avoid hanging in Docker
  local fisher_plugins="${HOME}/.config/fish/fish_plugins"

  if [[ -f "$fisher_plugins" ]] && grep -q "catppuccin/fish" "$fisher_plugins" && [[ -z "${FORCE:-}" ]]; then
    ui.print_info "catppuccin fish theme already installed, skipping"
  else
    ui.print_info "Installing catppuccin fish theme..."
    fish -C "fisher install catppuccin/fish && exit"
  fi

  # Activate theme (skip in CI - requires interactive shell)
  if [[ -z "${CI:-}" ]]; then
    fish -C "yes | fish_config theme save 'Catppuccin Mocha'; exit"
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
