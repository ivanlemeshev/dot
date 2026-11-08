#!/usr/bin/env bash
#MISE description="Install Fish plugins and set Fish as the login shell"

set -euo pipefail

# NOTE: Fish reads fzf commands when it loads the plugin.
command -v fzf

fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher install PatrickF1/fzf.fish && functions --query fzf_configure_bindings'

fish_path="$(command -v fish)"
passwd_entry="$(getent passwd "$(id -u)")"

if [[ -z "$passwd_entry" ]]; then
  printf 'No account exists for UID %s.\n' "$(id -u)" >&2
  exit 1
fi

login_name="${passwd_entry%%:*}"
sudo usermod --shell "$fish_path" "$login_name"
