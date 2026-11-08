#!/usr/bin/env bash
#MISE description="Install the Tree-sitter CLI"

set -euo pipefail
. /etc/os-release
if [[ "$ID" == fedora ]]; then
  native_cli_ready() {
    local version
    version="$(/usr/bin/tree-sitter --version)"
    [[ "$version" =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]] || return 1
    ((BASH_REMATCH[1] > 0 || BASH_REMATCH[2] > 26 || (BASH_REMATCH[2] == 26 && BASH_REMATCH[3] >= 1)))
  }
  if ! native_cli_ready; then sudo dnf upgrade -y tree-sitter-cli; fi
  if native_cli_ready; then
    mkdir -p "$HOME/.local/bin"
    ln -sfn /usr/bin/tree-sitter "$HOME/.local/bin/tree-sitter"
    tree-sitter --version
    exit 0
  fi
fi

# NOTE: Ubuntu parsers require a newer CLI than the native package.
cargo install tree-sitter-cli --version 0.26.12 --locked --root "$HOME/.local"
"$HOME/.local/bin/tree-sitter" --version
