#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Fish"

sudo dnf install -y fish

link_fish_config() {
  local source_path="$1"
  local target_path="$2"
  mkdir -p "$(dirname "$target_path")"

  if [[ -L "$target_path" ]]; then
    rm "$target_path"
  elif [[ -e "$target_path" ]]; then
    local backup="${target_path}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target_path" "$backup"
    log_info "Backed up $target_path to $backup"
  fi
  ln -s "$source_path" "$target_path"
}

link_fish_config "$PROJECT_ROOT/.config/fish/config.fish" \
  "$HOME/.config/fish/config.fish"

for source_path in "$PROJECT_ROOT/.config/fish/conf.d/"*.fish; do
  link_fish_config "$source_path" \
    "$HOME/.config/fish/conf.d/$(basename "$source_path")"
done

fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher PatrickF1/fzf.fish'

fish_path="$(command -v fish)"
current_shell="$(getent passwd "$(whoami)" | cut -d: -f7)"
if [[ "$current_shell" != "$fish_path" ]]; then
  sudo chsh -s "$fish_path" "$(whoami)"
fi

log_info "Fish configuration complete"
