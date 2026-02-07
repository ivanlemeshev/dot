#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SCRIPTS_DIR="$PROJECT_ROOT/install/macos"

"$INSTALL_SCRIPTS_DIR/homebrew.sh"
"$INSTALL_SCRIPTS_DIR/essentials.sh"
"$INSTALL_SCRIPTS_DIR/vim.sh"
"$INSTALL_SCRIPTS_DIR/nvim.sh"
"$INSTALL_SCRIPTS_DIR/git.sh"
"$INSTALL_SCRIPTS_DIR/gh.sh"
"$INSTALL_SCRIPTS_DIR/tmux.sh"
"$INSTALL_SCRIPTS_DIR/nerd-fonts.sh"
"$INSTALL_SCRIPTS_DIR/bat.sh"
"$INSTALL_SCRIPTS_DIR/opencode.sh"
"$INSTALL_SCRIPTS_DIR/iterm2.sh"
"$INSTALL_SCRIPTS_DIR/mise.sh"
"$INSTALL_SCRIPTS_DIR/fish.sh"
"$INSTALL_SCRIPTS_DIR/oh-my-posh.sh"
