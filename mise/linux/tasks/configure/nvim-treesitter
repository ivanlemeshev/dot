#!/usr/bin/env bash
#MISE description="Install Neovim tools and Tree-sitter parsers"
#MISE depends=["configure:nvim", "configure:tree-sitter", "configure:runic"]

set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MISE_NVIM_INSTALL=1 nvim --headless -u NONE -l "$SCRIPT_DIR/../../../nvim/bootstrap.lua"
