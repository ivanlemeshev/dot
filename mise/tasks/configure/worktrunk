#!/usr/bin/env bash
#MISE description="Install Worktrunk"

set -euo pipefail

if [[ ! -x "$HOME/.local/bin/wt" ]]; then
  cargo install worktrunk --locked --root "$HOME/.local"
fi
"$HOME/.local/bin/wt" --version
