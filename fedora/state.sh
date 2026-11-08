#!/usr/bin/env bash

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. "$ROOT/../unix/state.sh"
STATE="$HOME/.local/state/dotfiles-fedora"
PROFILE="$HOME/.local/share/konsole"
UNSET=__DOTFILES_UNSET__

load() { state_load "$STATE/state.json" '{"links":[],"preferences":[]}'; }
save() { state_save "$STATE/state.json" "$state"; }
read_preference() { kreadconfig6 --file "$1" --group "$2" --key "$3" --default "$UNSET"; }

write_preference() {
  local file="$1" group="$2" key="$3" value="$4" current
  if [[ "$value" == "$UNSET" ]]; then
    kwriteconfig6 --file "$file" --group "$group" --key "$key" --delete
  else
    kwriteconfig6 --file "$file" --group "$group" --key "$key" "$value"
  fi
  current="$(read_preference "$file" "$group" "$key")"
  if [[ "$current" != "$value" ]]; then
    printf 'KDE does not apply %s/%s/%s.\n' "$file" "$group" "$key" >&2
    return 1
  fi
}

set_preference() {
  local file="$1" group="$2" key="$3" value="$4" previous record
  previous="$(read_preference "$file" "$group" "$key")"
  if [[ "$previous" == "$value" ]]; then return; fi
  record="$(jq -c --arg file "$file" --arg group "$group" --arg key "$key" '.preferences[] | select(.file == $file and .group == $group and .key == $key)' <<<"$state")"
  if [[ -z "$record" ]]; then
    state="$(jq --arg file "$file" --arg group "$group" --arg key "$key" --arg previous "$previous" --arg applied "$value" '.preferences += [{file: $file, group: $group, key: $key, previous: $previous, applied: $applied}]' <<<"$state")"
  else
    if [[ "$previous" != "$(jq -r '.previous' <<<"$record")" && "$previous" != "$(jq -r '.applied' <<<"$record")" ]]; then
      printf 'The KDE preference changes after setup: %s/%s\n' "$file" "$key" >&2
      return 1
    fi
    state="$(jq --argjson record "$record" --arg applied "$value" '.preferences |= map(if . == $record then .applied = $applied else . end)' <<<"$state")"
  fi
  save
  write_preference "$file" "$group" "$key" "$value"
}

deploy() {
  local name source target record backup
  mkdir -p "$PROFILE"
  for name in dot.profile custom.colorscheme; do
    source="$ROOT/konsole/$name"
    target="$PROFILE/$name"
    record="$(jq -c --arg target "$target" '.links[] | select(.target == $target)' <<<"$state")"
    if [[ -L "$target" && "$(canonical_path "$target")" == "$source" ]]; then continue; fi
    if [[ -n "$record" ]]; then
      backup="$(jq -r '.backup // empty' <<<"$record")"
      if [[ -e "$target" || -L "$target" ]]; then
        if [[ -z "$backup" || -e "$backup" || -L "$backup" ]]; then
          printf 'The Konsole link changes after setup: %s\n' "$target" >&2
          return 1
        fi
        mv "$target" "$backup"
      fi
      ln -s "$source" "$target"
      continue
    fi
    backup=""
    if [[ -e "$target" || -L "$target" ]]; then backup="$(backup_destination "$STATE")"; fi
    state="$(jq --arg target "$target" --arg source "$source" --arg backup "$backup" '.links += [{target: $target, source: $source, backup: (if $backup == "" then null else $backup end)}]' <<<"$state")"
    save
    if [[ -n "$backup" ]]; then
      mv "$target" "$backup"
      printf 'Backup: %s -> %s\n' "$target" "$backup"
    fi
    ln -s "$source" "$target"
  done
}

reload_keyboard() {
  if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]] && dbus-send --session --type=signal /Layouts org.kde.KeyboardLayouts.reloadConfig >/dev/null 2>&1; then return; fi
  printf 'Log out and back in to apply the keyboard settings.\n'
}

keyboard_options() {
  local value
  value="$(read_preference kxkbrc Layout Options)"
  if [[ "$value" == "$UNSET" ]]; then value=""; fi
  jq -cn --arg value "$value" '$value | split(",") | map(select(length > 0))'
}

font_override() {
  local font="${KDE_TERMINAL_FONT:-}"
  if [[ "$font" == *$'\n'* || "$font" == *$'\r'* ]]; then
    printf 'KDE_TERMINAL_FONT must contain one line.\n' >&2
    return 1
  fi
  printf '%s\n' "$font"
}

default_profile() {
  if [[ -n "$(font_override)" ]]; then printf 'dot-local.profile\n'; else printf 'dot.profile\n'; fi
}

apply() {
  local state options font local_profile
  state="$(load)"
  deploy
  options="$(keyboard_options | jq -r 'map(select((startswith("caps:") or (startswith("ctrl:") and contains("caps"))) | not)) + ["ctrl:nocaps"] | join(",")')"
  set_preference kxkbrc Layout Options "$options"
  set_preference kxkbrc Layout Use true
  set_preference kxkbrc Layout ResetOldOptions true
  set_preference plasmakeyboardrc General diacriticsPopupEnabled false
  font="$(font_override)"
  if [[ -n "$font" ]]; then
    local_profile="$PROFILE/dot-local.profile"
    if [[ -L "$local_profile" ]]; then
      printf 'The local Konsole font profile must not be a symlink.\n' >&2
      return 1
    fi
    if [[ ! -e "$local_profile" ]]; then
      state="$(jq '.local_profile_created = true' <<<"$state")"
      save
    fi
    set_preference "$local_profile" General Parent dot.profile
    set_preference "$local_profile" General Name dot-local
    set_preference "$local_profile" Appearance Font "$font"
  fi
  set_preference konsolerc 'Desktop Entry' DefaultProfile "$(default_profile)"
  reload_keyboard
  verify
}

check_preference() {
  if [[ "$(read_preference "$1" "$2" "$3")" != "$4" ]]; then
    printf 'The KDE preference differs: %s/%s\n' "$1" "$3" >&2
    return 1
  fi
}

verify() {
  local name target font
  for name in dot.profile custom.colorscheme; do
    target="$PROFILE/$name"
    if [[ ! -L "$target" || "$(canonical_path "$target")" != "$ROOT/konsole/$name" ]]; then
      printf 'The Konsole link is missing or differs: %s\n' "$target" >&2
      return 1
    fi
  done
  if ! keyboard_options | jq -e '([.[] | select(. == "ctrl:nocaps")] | length) == 1 and all(.[]; . == "ctrl:nocaps" or ((startswith("caps:") or (startswith("ctrl:") and contains("caps"))) | not))' >/dev/null; then
    printf 'Caps Lock does not map to Ctrl in KDE.\n' >&2
    return 1
  fi
  check_preference kxkbrc Layout Use true
  check_preference kxkbrc Layout ResetOldOptions true
  check_preference plasmakeyboardrc General diacriticsPopupEnabled false
  check_preference konsolerc 'Desktop Entry' DefaultProfile "$(default_profile)"
  font="$(font_override)"
  if [[ -n "$font" ]]; then
    check_preference "$PROFILE/dot-local.profile" General Parent dot.profile
    check_preference "$PROFILE/dot-local.profile" General Name dot-local
    check_preference "$PROFILE/dot-local.profile" Appearance Font "$font"
  fi
}

unapply() {
  local state record current target backup file group key previous local_profile remaining
  state="$(load)"
  while IFS= read -r record; do
    file="$(jq -r '.file' <<<"$record")"
    group="$(jq -r '.group' <<<"$record")"
    key="$(jq -r '.key' <<<"$record")"
    current="$(read_preference "$file" "$group" "$key")"
    if [[ "$current" != "$(jq -r '.applied' <<<"$record")" && "$current" != "$(jq -r '.previous' <<<"$record")" ]]; then
      printf 'A KDE preference changes after setup: %s/%s. Review state.json.\n' "$file" "$key" >&2
      return 1
    fi
  done < <(jq -c '.preferences[]' <<<"$state")
  while IFS= read -r record; do
    target="$(jq -r '.target' <<<"$record")"
    if [[ -L "$target" && "$(canonical_path "$target")" == "$(jq -r '.source' <<<"$record")" ]]; then
      rm "$target"
    elif [[ -e "$target" || -L "$target" ]]; then
      printf 'The Konsole link changes after setup: %s\n' "$target" >&2
      return 1
    fi
    backup="$(jq -r '.backup // empty' <<<"$record")"
    if [[ -n "$backup" && (-e "$backup" || -L "$backup") ]]; then mv "$backup" "$target"; fi
    state="$(jq --argjson record "$record" '.links |= map(select(. != $record))' <<<"$state")"
    save
  done < <(jq -c '.links[]' <<<"$state")
  while IFS= read -r record; do
    file="$(jq -r '.file' <<<"$record")"
    group="$(jq -r '.group' <<<"$record")"
    key="$(jq -r '.key' <<<"$record")"
    previous="$(jq -r '.previous' <<<"$record")"
    write_preference "$file" "$group" "$key" "$previous"
    state="$(jq --argjson record "$record" '.preferences |= map(select(. != $record))' <<<"$state")"
    save
  done < <(jq -c '.preferences | reverse[]' <<<"$state")
  local_profile="$PROFILE/dot-local.profile"
  if [[ "$(jq -r '.local_profile_created // false' <<<"$state")" == true && -f "$local_profile" ]]; then
    remaining="$(sed -E '/^\[[^]]+\][[:blank:]]*$/d' "$local_profile" | tr -d '[:space:]')"
    if [[ -z "$remaining" ]]; then rm "$local_profile"; fi
  fi
  rm -f "$STATE/state.json"
  reload_keyboard
}

main() {
  local command
  . /etc/os-release
  if [[ "$(uname -s)" != Linux || "$ID" != fedora ]]; then
    printf 'This adapter requires Fedora KDE.\n' >&2
    return 1
  fi
  for command in konsole kwriteconfig6 kreadconfig6 dbus-send; do command -v "$command" >/dev/null; done
  case "${1:-}" in apply) apply ;; verify) verify ;; unapply) unapply ;; *)
    printf 'Use apply, verify, or unapply.\n' >&2
    return 1
    ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then main "$@"; fi
