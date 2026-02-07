#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

"$PROJECT_ROOT/install/ubuntu/update.sh"
"$PROJECT_ROOT/install/ubuntu/essentials.sh"
"$PROJECT_ROOT/install/ubuntu/vim.sh"
"$PROJECT_ROOT/install/ubuntu/nvim.sh"
"$PROJECT_ROOT/install/ubuntu/git.sh"
"$PROJECT_ROOT/install/ubuntu/gh.sh"
"$PROJECT_ROOT/install/ubuntu/vivid.sh"
"$PROJECT_ROOT/install/ubuntu/tmux.sh"
"$PROJECT_ROOT/install/ubuntu/nerd-fonts.sh"
"$PROJECT_ROOT/install/ubuntu/gcc-14.sh"
"$PROJECT_ROOT/install/ubuntu/yt-dlp.sh"
"$PROJECT_ROOT/install/ubuntu/powershell.sh"
"$PROJECT_ROOT/install/ubuntu/bat.sh"
"$PROJECT_ROOT/install/ubuntu/mise.sh"
"$PROJECT_ROOT/install/ubuntu/fish.sh"
"$PROJECT_ROOT/install/ubuntu/oh-my-posh.sh"
"$PROJECT_ROOT/install/ubuntu/clean.sh"

exec fish -l
