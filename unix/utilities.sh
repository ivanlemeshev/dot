#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
. "$SCRIPT_DIR/state.sh"

reset_nvim() {
  local yes=false dry_run=false argument path resolved
  local paths=("${XDG_CONFIG_HOME:-$HOME/.config}/nvim" "${XDG_DATA_HOME:-$HOME/.local/share}/nvim" "${XDG_STATE_HOME:-$HOME/.local/state}/nvim" "${XDG_CACHE_HOME:-$HOME/.cache}/nvim")
  for argument in "$@"; do
    case "$argument" in --yes) yes=true ;; --dry-run) dry_run=true ;; *)
      printf 'Unknown argument: %s\n' "$argument" >&2
      return 1
      ;;
    esac
  done
  for path in "${paths[@]}"; do
    if [[ ! -L "$path" ]]; then
      resolved="$(canonical_path "$path")"
      if [[ "$resolved" == "$ROOT" || "$resolved" == "$ROOT/"* || "$ROOT" == "$resolved/"* ]]; then
        printf 'The reset path contains the setup source: %s\n' "$path" >&2
        return 1
      fi
    fi
    printf 'Reset path: %s\n' "$path"
  done
  if [[ "$dry_run" == true ]]; then return; fi
  if [[ "$yes" != true ]]; then
    printf 'Review --dry-run, then pass --yes to remove these paths.\n' >&2
    return 1
  fi
  for path in "${paths[@]}"; do
    if [[ -L "$path" || -f "$path" ]]; then rm -- "$path"; elif [[ -e "$path" ]]; then rm -rf -- "$path"; fi
  done
  printf 'Neovim reset completes. Run bootstrap to restore the configuration link.\n'
}

set_git_user() {
  local repository="" name="" email="" name_given=false email_given=false
  while [[ $# -gt 0 ]]; do
    if [[ $# -lt 2 ]]; then
      printf 'An argument value is missing.\n' >&2
      return 1
    fi
    case "$1" in
      --repo) repository="$(expand_home "$2")" ;;
      --name)
        name="$2"
        name_given=true
        ;;
      --email)
        email="$2"
        email_given=true
        ;;
      *)
        printf 'Unknown argument: %s\n' "$1" >&2
        return 1
        ;;
    esac
    shift 2
  done
  if [[ -z "$repository" ]]; then
    printf 'Pass --repo with a repository path.\n' >&2
    return 1
  fi
  git -C "$repository" rev-parse --git-dir >/dev/null
  if [[ "$name_given" == false ]]; then IFS= read -r -p 'Git user name: ' name; fi
  if [[ "$email_given" == false ]]; then IFS= read -r -p 'Git user email: ' email; fi
  if [[ -z "${name//[[:space:]]/}" || -z "${email//[[:space:]]/}" || "$name$email" == *$'\n'* || "$name$email" == *$'\r'* ]]; then
    printf 'Git name and email must contain nonempty single-line values.\n' >&2
    return 1
  fi
  git -C "$repository" config --local --replace-all user.name "$name"
  git -C "$repository" config --local --replace-all user.email "$email"
  printf 'Repository Git identity changes. Other settings stay unchanged.\n'
}

case "${1:-}" in
  reset-nvim)
    shift
    reset_nvim "$@"
    ;;
  set-git-repo-user)
    shift
    set_git_user "$@"
    ;;
  *)
    printf 'Use reset-nvim or set-git-repo-user.\n' >&2
    exit 1
    ;;
esac
