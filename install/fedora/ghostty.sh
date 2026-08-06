#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Ghostty"

log_info "Enabling the Ghostty COPR repository"
sudo dnf copr enable -y scottames/ghostty

log_info "Installing Ghostty"
sudo dnf install -y ghostty

log_info "Configuring Ghostty"
GHOSTTY_CONFIG_SOURCE="$PROJECT_ROOT/.config/ghostty/config"
GHOSTTY_CONFIG_TARGET="$HOME/.config/ghostty/config"
GHOSTTY_THEME_SOURCE="$PROJECT_ROOT/.config/ghostty/themes/custom"
GHOSTTY_THEME_TARGET="$HOME/.config/ghostty/themes/custom"

link_ghostty_file() {
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
  log_info "Linked $target_path"
}

link_ghostty_file "$GHOSTTY_CONFIG_SOURCE" "$GHOSTTY_CONFIG_TARGET"
link_ghostty_file "$GHOSTTY_THEME_SOURCE" "$GHOSTTY_THEME_TARGET"

log_info "Ghostty installation complete"
