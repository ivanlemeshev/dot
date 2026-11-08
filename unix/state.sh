#!/usr/bin/env bash

state_load() {
  if [[ -f "$1" ]]; then jq -c . "$1"; else printf '%s\n' "$2"; fi
}

state_save() {
  local path="$1" value="$2" temporary
  mkdir -p "$(dirname "$path")"
  temporary="$(mktemp "$path.XXXXXX")"
  if ! printf '%s\n' "$value" | jq . >"$temporary"; then
    rm -f "$temporary"
    return 1
  fi
  mv -f "$temporary" "$path"
}

expand_home() {
  case "$1" in \~/*) printf '%s/%s\n' "$HOME" "${1#\~/}" ;; *) printf '%s\n' "$1" ;; esac
}

canonical_path() {
  if command -v grealpath >/dev/null 2>&1; then grealpath -m -- "$1"; else realpath -m -- "$1"; fi
}

backup_destination() {
  mkdir -p "$1/backups"
  printf '%s/original\n' "$(mktemp -d "$1/backups/XXXXXXXX")"
}

backup_configuration() {
  local target="$1" file="$2" directory="${3:-}" records destination
  records="$(state_load "$file" '[]')"
  jq -e 'type == "array"' <<<"$records" >/dev/null
  if jq -e --arg target "$target" 'any(.[]; .target == $target)' <<<"$records" >/dev/null; then
    printf 'A backup already exists for %s. Review %s.\n' "$target" "$file" >&2
    return 1
  fi
  destination="$(backup_destination "$(dirname "$file")")"
  records="$(jq --arg target "$target" --arg backup "$destination" --arg directory "$directory" \
    '. + [({target: $target, backup: $backup} + if $directory == "" then {} else {directory: ($directory == "true")} end)]' <<<"$records")"
  state_save "$file" "$records"
  mv "$target" "$destination"
  printf 'Backup: %s -> %s\n' "$target" "$destination"
}

prepare_configuration() {
  local file="$1" directory="${2:-}" status entry target
  status="$(mise dot status --json)"
  jq -e '(.files | type) == "array"' <<<"$status" >/dev/null
  if jq -e 'any(.files[]; .state == "source_missing")' <<<"$status" >/dev/null; then
    printf 'A managed configuration source is missing.\n' >&2
    return 1
  fi
  while IFS= read -r entry; do
    if [[ "$(jq -r '.mode' <<<"$entry")" != symlink ]]; then
      if [[ -n "$directory" ]]; then
        printf 'Unexpected configuration mode.\n' >&2
        return 1
      fi
      continue
    fi
    target="$(expand_home "$(jq -r '.target' <<<"$entry")")"
    backup_configuration "$target" "$file" "$directory"
  done < <(jq -c '.files[] | select(.state == "differs")' <<<"$status")
}

restore_configuration() {
  local file="$1" strict="${2:-true}" records entry target backup directory
  records="$(state_load "$file" '[]')"
  jq -e 'type == "array"' <<<"$records" >/dev/null
  while IFS= read -r entry; do
    target="$(jq -r '.target' <<<"$entry")"
    backup="$(jq -r '.backup' <<<"$entry")"
    if [[ ! -e "$backup" && ! -L "$backup" ]]; then
      if [[ "$strict" == true ]]; then
        printf 'The configuration backup is missing: %s\n' "$backup" >&2
        return 1
      fi
      continue
    fi
    directory="$(jq -r '.directory // false' <<<"$entry")"
    if [[ "$directory" == true && -d "$target" && ! -L "$target" ]]; then rmdir "$target"; fi
    if [[ -e "$target" || -L "$target" ]]; then
      printf 'The restore target exists: %s\n' "$target" >&2
      return 1
    fi
    mv "$backup" "$target"
    records="$(jq --argjson entry "$entry" 'map(select(. != $entry))' <<<"$records")"
    state_save "$file" "$records"
  done < <(jq -c 'reverse[]' <<<"$records")
  rm -f "$file"
}

version_at_least() {
  local version="$1" major="$2" minor="$3" patch="$4"
  [[ "$version" =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]] || return 1
  ((BASH_REMATCH[1] > major || (BASH_REMATCH[1] == major && BASH_REMATCH[2] > minor) || (BASH_REMATCH[1] == major && BASH_REMATCH[2] == minor && BASH_REMATCH[3] >= patch)))
}
