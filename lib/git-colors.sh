#!/usr/bin/env bash

configure_git_colors() {
  local source_path="$PROJECT_ROOT/.config/git/colors"
  local target_path="$HOME/.config/git/colors"
  mkdir -p "$(dirname "$target_path")"
  if [[ -L "$target_path" ]]; then
    unlink "$target_path"
  elif [[ -e "$target_path" ]]; then
    mv "$target_path" "$target_path.backup.$(date +%Y%m%d%H%M%S)"
  fi
  ln -s "$source_path" "$target_path"
  if ! git config --global --get-all include.path | grep -Fxq "$target_path"; then
    git config --global --add include.path "$target_path"
  fi
}
