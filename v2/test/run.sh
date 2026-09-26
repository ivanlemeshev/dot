#!/usr/bin/env bash

set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

/opt/v2/bin/bootstrap
/opt/v2/bin/bootstrap

command -v git
command -v chezmoi
test "$(git config --global --get init.defaultBranch)" = main
test -f "$HOME/.gitconfig"
