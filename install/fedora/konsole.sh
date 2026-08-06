#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

print_section "Configuring Konsole"

sudo dnf install -y konsole

if ! command -v kwriteconfig6 >/dev/null; then
  log_error "kwriteconfig6 is unavailable; KDE Plasma 6 is required"
  exit 1
fi

KDE_TERMINAL_FONT="${KDE_TERMINAL_FONT:-JetBrainsMonoNL Nerd Font Mono,11,-1,5,50,0,0,0,0,0}"
KONSOLE_PROFILE_DIR="$HOME/.local/share/konsole"
KONSOLE_PROFILE="$KONSOLE_PROFILE_DIR/dot.profile"
mkdir -p "$KONSOLE_PROFILE_DIR"

sed "s|@FONT@|$KDE_TERMINAL_FONT|" \
  "$PROJECT_ROOT/.config/konsole/dot.profile.in" >"$KONSOLE_PROFILE"

KONSOLE_COLOR_SOURCE="$PROJECT_ROOT/.config/konsole/custom.colorscheme"
KONSOLE_COLOR_TARGET="$KONSOLE_PROFILE_DIR/custom.colorscheme"
ln -sf "$KONSOLE_COLOR_SOURCE" "$KONSOLE_COLOR_TARGET"

kwriteconfig6 --file konsolerc --group "Desktop Entry" \
  --key DefaultProfile "dot.profile"

log_info "Konsole now uses dot.profile"
