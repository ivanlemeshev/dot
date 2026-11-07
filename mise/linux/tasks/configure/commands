#!/usr/bin/env bash
#MISE description="Set Linux command names"

set -euo pipefail
. /etc/os-release
mkdir -p "$HOME/.local/bin"
if [[ "$ID" == ubuntu ]]; then
  ln -sfn /usr/bin/fdfind "$HOME/.local/bin/fd"
  ln -sfn /usr/bin/batcat "$HOME/.local/bin/bat"
  ln -sfn /usr/bin/fzf "$HOME/.local/bin/fzf"
else
  for command_name in bat fd fzf; do
    ln -sfn "/usr/bin/$command_name" "$HOME/.local/bin/$command_name"
  done
fi
fd --version
bat --version
fzf --version
