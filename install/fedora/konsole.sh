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
if [[ -L "$KONSOLE_PROFILE_DIR/TomorrowNight.colorscheme" ]] && \
  [[ "$(readlink "$KONSOLE_PROFILE_DIR/TomorrowNight.colorscheme")" == "$PROJECT_ROOT/.config/konsole/TomorrowNight.colorscheme" ]]; then
  unlink "$KONSOLE_PROFILE_DIR/TomorrowNight.colorscheme"
fi
if [[ -L "$KONSOLE_COLOR_TARGET" ]]; then
  unlink "$KONSOLE_COLOR_TARGET"
elif [[ -e "$KONSOLE_COLOR_TARGET" ]]; then
  KONSOLE_COLOR_BACKUP="$KONSOLE_COLOR_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$KONSOLE_COLOR_TARGET" "$KONSOLE_COLOR_BACKUP"
  log_info "Backed up Konsole theme to $KONSOLE_COLOR_BACKUP"
fi
ln -s "$KONSOLE_COLOR_SOURCE" "$KONSOLE_COLOR_TARGET"

kwriteconfig6 --file konsolerc --group "Desktop Entry" \
  --key DefaultProfile "dot.profile"

log_info "Konsole now uses dot.profile"
