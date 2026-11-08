#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. "$SCRIPT_DIR/../unix/state.sh"
STATE="$HOME/.local/state/dotfiles-ubuntu/keyboard.json"
SCHEMA=org.gnome.desktop.input-sources
KEY=xkb-options

keyboard_read() {
  gsettings get "$SCHEMA" "$KEY" | jq -Rsc 'sub("^@as "; "") | gsub("\u0027"; "\"") | fromjson'
}

keyboard_write() {
  local value="$1" applied
  gsettings set "$SCHEMA" "$KEY" "$value"
  applied="$(keyboard_read)"
  if ! jq -en --argjson actual "$applied" --argjson expected "$value" '$actual == $expected' >/dev/null; then
    printf 'GNOME does not apply the requested keyboard options.\n' >&2
    return 1
  fi
}

host_keyboard() {
  local release
  release="$(tr '[:upper:]' '[:lower:]' </proc/sys/kernel/osrelease)"
  [[ -n "${WSL_DISTRO_NAME:-}${container:-}" || "$release" == *microsoft* || -e /.dockerenv || -e /run/.containerenv ]]
}

keyboard_main() {
  local action="${1:-}" desktop current desired record
  if host_keyboard; then
    printf 'WSL and containers use the host keyboard mapping.\n'
    return
  fi
  desktop="$(printf '%s' "${XDG_CURRENT_DESKTOP:-}" | tr '[:upper:]' '[:lower:]')"
  if [[ -z "$desktop" && ! -f "$STATE" ]]; then
    printf 'No desktop session is active. Run configure:desktop from the Ubuntu desktop session.\n'
    return
  fi
  if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" || ("$desktop" != *gnome* && "$desktop" != *ubuntu*) ]]; then
    printf 'Run this task in the Ubuntu GNOME desktop session.\n' >&2
    return 1
  fi
  current="$(keyboard_read)"
  desired="$(jq -c 'map(select((startswith("caps:") or (startswith("ctrl:") and contains("caps"))) | not)) + ["ctrl:nocaps"]' <<<"$current")"
  case "$action" in
    apply)
      if [[ "$current" == "$desired" ]]; then return; fi
      if [[ -f "$STATE" ]]; then
        record="$(cat "$STATE")"
        if ! jq -en --argjson current "$current" --argjson record "$record" '$current == $record.previous or $current == $record.applied' >/dev/null; then
          printf 'Keyboard options change after setup. Review keyboard.json.\n' >&2
          return 1
        fi
      else
        state_save "$STATE" "$(jq -n --argjson previous "$current" --argjson applied "$desired" '{previous: $previous, applied: $applied}')"
      fi
      keyboard_write "$desired"
      ;;
    verify)
      if ! jq -e '([.[] | select(. == "ctrl:nocaps")] | length) == 1 and all(.[]; . == "ctrl:nocaps" or ((startswith("caps:") or (startswith("ctrl:") and contains("caps"))) | not))' <<<"$current" >/dev/null; then
        printf 'Caps Lock does not map to Ctrl in GNOME.\n' >&2
        return 1
      fi
      ;;
    unapply)
      if [[ ! -f "$STATE" ]]; then return; fi
      record="$(cat "$STATE")"
      if ! jq -en --argjson current "$current" --argjson record "$record" '$current == $record.previous or $current == $record.applied' >/dev/null; then
        printf 'Keyboard options change after setup. Review keyboard.json.\n' >&2
        return 1
      fi
      keyboard_write "$(jq -c '.previous' <<<"$record")"
      rm "$STATE"
      ;;
    *)
      printf 'Use apply, verify, or unapply.\n' >&2
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then keyboard_main "$@"; fi
