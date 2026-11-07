#!/usr/bin/env bash

set -euo pipefail
local_config="$HOME/.config/git/config.local"
mkdir -p "$(dirname "$local_config")"
touch "$local_config"
chmod 600 "$local_config"
for key in user.name user.email init.defaultBranch; do
  if git config --file "$local_config" --get "$key" >/dev/null; then
    continue
  else
    status=$?
    if [[ "$status" -ne 1 ]]; then exit "$status"; fi
  fi
  if value="$(git config --global --get "$key")"; then
    if [[ -n "$value" ]]; then git config --file "$local_config" --replace-all "$key" "$value"; fi
  else
    status=$?
    if [[ "$status" -ne 1 ]]; then exit "$status"; fi
  fi
done
