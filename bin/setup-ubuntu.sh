#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

"$PROJECT_ROOT/install/ubuntu/update.sh"
"$PROJECT_ROOT/install/ubuntu/essentials.sh"
"$PROJECT_ROOT/install/ubuntu/vim.sh"
"$PROJECT_ROOT/install/ubuntu/git.sh"
"$PROJECT_ROOT/install/ubuntu/gh.sh"
"$PROJECT_ROOT/install/ubuntu/tmux.sh"
"$PROJECT_ROOT/install/ubuntu/nerd-fonts.sh"
"$PROJECT_ROOT/install/ubuntu/clean.sh"

# ./install/ubuntu/install-asdf.sh
# ./install/ubuntu/install-bat.sh
# ./install/ubuntu/install-vivid.sh
# ./install/ubuntu/install-starship.sh
# ./install/ubuntu/install-fish.sh
# ./install/ubuntu/install-bottom.sh
# ./install/ubuntu/install-go.sh
# ./install/ubuntu/install-python.sh
# ./install/ubuntu/install-node.sh
# ./install/ubuntu/install-lua.sh
# ./install/ubuntu/install-rust.sh
# ./install/ubuntu/install-nvim.sh
# ./install/ubuntu/install-yt-dlp.sh
# ./install/ubuntu/clean.sh

# exec fish -l
