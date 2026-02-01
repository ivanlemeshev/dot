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
  pkg_install "fzf"
}

# Install fish integration via fzf.fish plugin
function post_install() {
  # Install fzf.fish plugin
  # https://github.com/PatrickF1/fzf.fish
  ui.print_info "Installing fzf.fish plugin..."
  fish -C "fisher install PatrickF1/fzf.fish && exit"
}

# Main entry point
function main() {
  install_package
  post_install
}
