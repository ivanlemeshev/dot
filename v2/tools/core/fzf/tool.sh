#!/usr/bin/env bash
# fzf - a command-line fuzzy finder for interactive filtering of files, command
# history (Ctrl+R), and more. Integrates with fish via fzf.fish plugin.

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Install fzf
function install_package() {
  if pkg_installed "fzf" && [[ -z "${FORCE:-}" ]]; then
    ui.print_info "fzf already installed, skipping (use FORCE=1 to reinstall)"
  else
    if [[ -n "${FORCE:-}" ]]; then
      ui.print_info "FORCE set, reinstalling fzf..."
    fi
    pkg_install "fzf"
  fi
}

# Install fish integration via fzf.fish plugin
# https://github.com/PatrickF1/fzf.fish
function post_install() {
  # Check fisher plugin file directly to avoid hanging fish in Docker
  local fisher_plugins="${HOME}/.config/fish/fish_plugins"

  if [[ -f "$fisher_plugins" ]] && grep -q "PatrickF1/fzf.fish" "$fisher_plugins" && [[ -z "${FORCE:-}" ]]; then
    ui.print_info "fzf.fish plugin already installed, skipping"
  else
    ui.print_info "Installing fzf.fish plugin..."
    fish -C "fisher install PatrickF1/fzf.fish && exit"
  fi
}

# Main entry point
function main() {
  install_package
  post_install
}
