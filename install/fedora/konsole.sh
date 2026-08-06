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

KDE_TERMINAL_FONT="${KDE_TERMINAL_FONT:-JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0}"
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

KONSOLE_DESKTOP_SOURCE="/usr/share/applications/org.kde.konsole.desktop"
KONSOLE_DESKTOP_DIR="$HOME/.local/share/applications"
KONSOLE_DESKTOP_TARGET="$KONSOLE_DESKTOP_DIR/org.kde.konsole.desktop"
mkdir -p "$KONSOLE_DESKTOP_DIR"
cp "$KONSOLE_DESKTOP_SOURCE" "$KONSOLE_DESKTOP_TARGET"
sed -i 's|^Exec=konsole|Exec=konsole --hide-toolbars|' \
  "$KONSOLE_DESKTOP_TARGET"

if command -v update-desktop-database >/dev/null; then
  update-desktop-database "$KONSOLE_DESKTOP_DIR"
fi

log_info "Konsole now uses dot.profile with its main toolbar hidden"
