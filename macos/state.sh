#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. "$SCRIPT_DIR/../unix/state.sh"
STATE="$HOME/.local/state/dotfiles-macos"
CAPS=30064771129
CONTROL=30064771296
SRC=HIDKeyboardModifierMappingSrc
DST=HIDKeyboardModifierMappingDst

prepare() {
  local profiles="$HOME/Library/Application Support/iTerm2/DynamicProfiles" path
  if [[ -L "$profiles" ]]; then
    if [[ -d "$profiles" ]]; then
      for path in "$profiles"/* "$profiles"/.[!.]* "$profiles"/..?*; do
        [[ -e "$path" || -L "$path" ]] || continue
        case "${path##*/}" in custom.json | TomorrowNight.json) ;; *)
          printf 'Move the iTerm2 DynamicProfiles directory link before setup. It contains other profiles.\n' >&2
          return 1
          ;;
        esac
      done
    fi
    backup_configuration "$profiles" "$STATE/links.json" true
    mkdir -p "$profiles"
  fi
  prepare_configuration "$STATE/links.json" false
}

mappings() {
  local output
  output="$(hidutil property --get UserKeyMapping)"
  case "$output" in '(null)' | null | '')
    printf '[]\n'
    return
    ;;
  esac
  printf '%s\n' "$output" | plutil -convert json -o - - | jq -cS '
    def number:
      if type == "number" then .
      elif startswith("0x") then
        ascii_downcase | .[2:] | explode | reduce .[] as $c (0; . * 16 + ("0123456789abcdef" | index($c | [.] | implode)))
      else tonumber end;
    if type != "array" then error("The keyboard map is not an array.") else map(with_entries(.value |= number)) end'
}

set_mappings() {
  local values="$1" current
  hidutil property --set "$(jq -cn --argjson values "$values" '{UserKeyMapping: $values}')" >/dev/null
  current="$(mappings)"
  if ! jq -en --argjson actual "$current" --argjson expected "$values" '$actual == $expected' >/dev/null; then
    printf 'The keyboard map does not match the requested map.\n' >&2
    return 1
  fi
}

keyboard() {
  local action="$1" current previous desired saved
  current="$(mappings)"
  previous="$(jq -cS --arg key "$SRC" --argjson caps "$CAPS" 'map(select(.[$key] == $caps))' <<<"$current")"
  desired="$(jq -cnS --arg src "$SRC" --arg dst "$DST" --argjson caps "$CAPS" --argjson control "$CONTROL" '[{($src): $caps, ($dst): $control}]')"
  case "$action" in
    verify)
      if [[ "$previous" != "$desired" ]]; then
        printf 'Caps Lock does not map to Ctrl.\n' >&2
        return 1
      fi
      ;;
    apply)
      if [[ "$previous" != "$desired" ]]; then
        if [[ ! -f "$STATE/keyboard.json" ]]; then state_save "$STATE/keyboard.json" "$previous"; fi
        set_mappings "$(jq -c --arg key "$SRC" --argjson caps "$CAPS" --argjson desired "$desired" 'map(select(.[$key] != $caps)) + $desired' <<<"$current")"
      fi
      ;;
    restore)
      if [[ ! -f "$STATE/keyboard.json" ]]; then return; fi
      if [[ "$previous" != "$desired" ]]; then
        printf 'The Caps Lock map changes after setup. Review keyboard.json before restoration.\n' >&2
        return 1
      fi
      saved="$(cat "$STATE/keyboard.json")"
      set_mappings "$(jq -c --arg key "$SRC" --argjson caps "$CAPS" --argjson saved "$saved" 'map(select(.[$key] != $caps)) + $saved' <<<"$current")"
      rm "$STATE/keyboard.json"
      ;;
  esac
}

read_preferences() {
  local load_prefs guid
  load_prefs="$(defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder 2>/dev/null || true)"
  guid="$(defaults read com.googlecode.iterm2 'Default Bookmark Guid' 2>/dev/null || true)"
  jq -cn --arg load_prefs "$load_prefs" --arg guid "$guid" '
    {
      LoadPrefsFromCustomFolder: if $load_prefs == "" then null elif $load_prefs == "1" then true elif $load_prefs == "0" then false else error("Invalid iTerm2 preference value.") end,
      "Default Bookmark Guid": if $guid == "" then null else $guid end
    }'
}

preferences() {
  local restore="${1:-false}" current previous key desired value kind
  local keys=(LoadPrefsFromCustomFolder 'Default Bookmark Guid')
  current="$(read_preferences)"
  if [[ "$restore" == true ]]; then
    if [[ ! -f "$STATE/iterm2.json" ]]; then return; fi
    previous="$(cat "$STATE/iterm2.json")"
    for key in "${keys[@]}"; do
      if [[ "$key" == LoadPrefsFromCustomFolder ]]; then desired=false; else desired='"b2f196a0-9822-4f69-8ce9-73f2de6b4371"'; fi
      if ! jq -en --argjson current "$current" --arg key "$key" --argjson desired "$desired" '$current[$key] == $desired' >/dev/null; then
        printf 'iTerm2 changes after setup: %s\n' "$key" >&2
        return 1
      fi
    done
    for key in "${keys[@]}"; do
      value="$(jq -c --arg key "$key" '.[$key]' <<<"$previous")"
      if [[ "$value" == null ]]; then
        defaults delete com.googlecode.iterm2 "$key"
      else
        kind="$(jq -r 'if type == "boolean" then "-bool" else "-string" end' <<<"$value")"
        defaults write com.googlecode.iterm2 "$key" "$kind" "$(jq -r . <<<"$value")"
      fi
    done
    rm "$STATE/iterm2.json"
  else
    if [[ ! -f "$STATE/iterm2.json" ]]; then
      state_save "$STATE/iterm2.json" "$(jq '{LoadPrefsFromCustomFolder, "Default Bookmark Guid": .["Default Bookmark Guid"]}' <<<"$current")"
    fi
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool false
    defaults write com.googlecode.iterm2 'Default Bookmark Guid' -string b2f196a0-9822-4f69-8ce9-73f2de6b4371
  fi
}

versions() {
  local upgrade="${1:-false}" command package output environment
  local minimum=(0 12 0)
  for command in nvim tree-sitter; do
    if [[ "$command" == nvim ]]; then
      package=neovim
      minimum=(0 12 0)
    else
      package=tree-sitter-cli
      minimum=(0 26 1)
    fi
    output="$("$command" --version)"
    if ! version_at_least "$output" "${minimum[@]}"; then
      if [[ "$upgrade" == true ]]; then brew upgrade "$package"; fi
      output="$("$command" --version)"
      if ! version_at_least "$output" "${minimum[@]}"; then
        printf '%s requires version %s.%s.%s or later.\n' "$command" "${minimum[@]}" >&2
        return 1
      fi
    fi
  done
  environment="$(gh help environment)"
  if ! grep -q GH_ACCESSIBLE_COLORS <<<"$environment"; then
    if [[ "$upgrade" == true ]]; then brew upgrade gh; fi
    environment="$(gh help environment)"
    if ! grep -q GH_ACCESSIBLE_COLORS <<<"$environment"; then
      printf 'GitHub CLI does not support accessible colors.\n' >&2
      return 1
    fi
  fi
}

main() {
  if [[ "$(uname -s)" != Darwin ]]; then
    printf 'This adapter requires macOS.\n' >&2
    return 1
  fi
  case "${1:-}" in
    prepare) prepare ;;
    apply | verify | restore) keyboard "$1" ;;
    versions) versions true ;;
    verify-versions) versions ;;
    preferences) preferences ;;
    unapply)
      local label
      label="gui/$(id -u)/com.dotfiles.caps-lock"
      if launchctl print "$label" >/dev/null 2>&1; then launchctl bootout "$label"; fi
      keyboard restore
      preferences true
      mise dot unapply --yes
      restore_configuration "$STATE/links.json" false
      ;;
    *)
      printf 'Unknown macOS adapter action: %s\n' "${1:-}" >&2
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then main "$@"; fi
