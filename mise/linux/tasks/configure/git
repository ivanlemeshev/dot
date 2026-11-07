#!/usr/bin/env bash
#MISE description="Set local Git defaults"

set -euo pipefail

local_config="$HOME/.config/git/config.local"

mkdir -p "$(dirname "$local_config")"
touch "$local_config"
chmod 600 "$local_config"

if [[ -n "${GIT_DEFAULT_BRANCH:-}" ]]; then
  git config --file "$local_config" --replace-all init.defaultBranch "$GIT_DEFAULT_BRANCH"
fi

if [[ -n "${GIT_USER_NAME:-}" ]]; then
  git config --file "$local_config" --replace-all user.name "$GIT_USER_NAME"
fi

if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
  git config --file "$local_config" --replace-all user.email "$GIT_USER_EMAIL"
fi
