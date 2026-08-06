#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Mapping Caps Lock to Ctrl"

if ! command -v kwriteconfig6 >/dev/null || ! command -v kreadconfig6 >/dev/null; then
  log_error "KDE Plasma 6 configuration tools are unavailable"
  exit 1
fi

# Preserve unrelated XKB options while removing Caps Lock mappings that would
# conflict with ctrl:nocaps.
current_options="$(kreadconfig6 --file kxkbrc --group Layout --key Options)"
new_options=()
IFS=',' read -r -a options <<<"$current_options"

for option in "${options[@]}"; do
  [[ -z "$option" ]] && continue
  [[ "$option" == caps:* ]] && continue
  [[ "$option" == ctrl:nocaps ]] && continue
  new_options+=("$option")
done
new_options+=("ctrl:nocaps")

option_value="$(IFS=,; printf '%s' "${new_options[*]}")"
kwriteconfig6 --file kxkbrc --group Layout --key Options "$option_value"
kwriteconfig6 --file kxkbrc --group Layout --key ResetOldOptions true
kwriteconfig6 --file kxkbrc --group Layout --key Use true

kwriteconfig6 --notify --file plasmakeyboardrc --group General \
  --key diacriticsPopupEnabled false

# Apply without logging out when the Plasma keyboard service is available.
if command -v dbus-send >/dev/null && \
  dbus-send --session --type=signal /Layouts \
    org.kde.KeyboardLayouts.reloadConfig >/dev/null 2>&1; then
  log_info "Caps Lock now acts as Ctrl"
else
  log_info "Mapping saved; log out and back in to apply it"
fi
