#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

for command in git vim nvim; do
  if ! command -v "$command" >/dev/null; then
    echo "Editor tests require $command" >&2
    exit 1
  fi
done

EDITOR_TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dot-editor-tests.XXXXXX")"
trap 'rm -rf "$EDITOR_TEST_ROOT"' EXIT
export XDG_CONFIG_HOME="$EDITOR_TEST_ROOT/config"
export XDG_DATA_HOME="$EDITOR_TEST_ROOT/data"
export XDG_STATE_HOME="$EDITOR_TEST_ROOT/state"
export XDG_CACHE_HOME="$EDITOR_TEST_ROOT/cache"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"

if ! nvim --clean --headless -i NONE \
  -c 'if !has("nvim-0.12") | cquit | endif' -c 'qa!'; then
  echo "Editor tests require Neovim 0.12 or later" >&2
  exit 1
fi

install_test_plugin() {
  local name="$1"
  local repository="$2"
  local revision="$3"
  local destination="$XDG_DATA_HOME/nvim/site/pack/core/opt/$name"

  echo "Installing test plugin: $name ($revision)"
  git init --quiet --initial-branch=editor-tests "$destination"
  git -C "$destination" fetch --quiet --depth=1 "$repository" "$revision"
  git -C "$destination" checkout --quiet --detach FETCH_HEAD
}

install_test_plugin lualine.nvim \
  https://github.com/nvim-lualine/lualine.nvim \
  221ce6b2d999187044529f49da6554a92f740a96
install_test_plugin tiny-inline-diagnostic.nvim \
  https://github.com/rachartier/tiny-inline-diagnostic.nvim \
  46ae9b3c8f3039e96ff4497d190ad0aee091f30d

for test_file in tests/nvim/*.lua; do
  echo "Running $test_file"
  nvim --clean -i NONE -l "$test_file"
done

for test_file in tests/vim/*.vim; do
  echo "Running $test_file"
  if ! vim -N -n -i NONE --noplugin -V1"$EDITOR_TEST_ROOT/vim.log" \
    --cmd "set runtimepath=\$VIMRUNTIME" --cmd 'set packpath=' \
    -u .config/vim/.vimrc -es -S "$test_file"; then
    cat "$EDITOR_TEST_ROOT/vim.log" >&2
    exit 1
  fi
done

echo "All editor tests pass"
