#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Mapping Caps Lock to Ctrl"

if ! command -v gsettings >/dev/null; then
  log_error "GNOME settings tools are unavailable"
  exit 1
fi

current_options="$(gsettings get org.gnome.desktop.input-sources xkb-options)"
options=()
if [[ "$current_options" =~ ^\[(.*)\]$ ]]; then
  option_text="${BASH_REMATCH[1]}"
  while [[ "$option_text" =~ ^[[:space:]]*\'([^\']*)\'[[:space:]]*(,[[:space:]]*(.*))?$ ]]; do
    options+=("${BASH_REMATCH[1]}")
    option_text="${BASH_REMATCH[3]}"
  done
fi

new_options=()
for option in "${options[@]}"; do
  [[ "$option" == caps:* || "$option" == ctrl:nocaps ]] && continue
  new_options+=("'$option'")
done
new_options+=("'ctrl:nocaps'")

option_value="[$(IFS=', '; printf '%s' "${new_options[*]}")]"
gsettings set org.gnome.desktop.input-sources xkb-options "$option_value"
log_info "Caps Lock now acts as Ctrl"
