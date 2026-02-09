#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SCRIPTS_DIR="$PROJECT_ROOT/install/ubuntu"

"$INSTALL_SCRIPTS_DIR/update.sh"
"$INSTALL_SCRIPTS_DIR/essentials.sh"
"$INSTALL_SCRIPTS_DIR/fzf.sh"
"$INSTALL_SCRIPTS_DIR/vim.sh"
"$INSTALL_SCRIPTS_DIR/nvim.sh"
"$INSTALL_SCRIPTS_DIR/git.sh"
"$INSTALL_SCRIPTS_DIR/gh.sh"
"$INSTALL_SCRIPTS_DIR/vivid.sh"
"$INSTALL_SCRIPTS_DIR/tmux.sh"
"$INSTALL_SCRIPTS_DIR/nerd-fonts.sh"
"$INSTALL_SCRIPTS_DIR/gcc-14.sh"
"$INSTALL_SCRIPTS_DIR/yt-dlp.sh"
"$INSTALL_SCRIPTS_DIR/powershell.sh"
"$INSTALL_SCRIPTS_DIR/bat.sh"
"$INSTALL_SCRIPTS_DIR/mise.sh"
"$INSTALL_SCRIPTS_DIR/fish.sh"
"$INSTALL_SCRIPTS_DIR/oh-my-posh.sh"
"$INSTALL_SCRIPTS_DIR/clean.sh"

exec fish -l
