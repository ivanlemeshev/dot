#!/usr/bin/env bash

set -euo pipefail

platform="$1"
repository="/opt/dotfiles"
export PATH="$HOME/.local/bin:$PATH"

assert_link() {
  local path="$1"
  local target="$2"

  [[ -L "$path" ]]
  [[ "$(readlink "$path")" == "$target" ]]
}

verify_installation() {
  "$repository/bin/setup" </dev/null

  command -v git
  command -v fish
  command -v tmux
  command -v mise
  command -v oh-my-posh
  command -v grpcurl
  mise where node >/dev/null
  mise exec -- node --version
  mise exec -- racket --version
  mise exec -- tree-sitter --version
  [[ -x /opt/nvim-linux-x86_64/bin/nvim ]]

  assert_link "$HOME/.vimrc" "$repository/.config/vim/.vimrc"
  assert_link "$HOME/.config/nvim" "$repository/.config/nvim"
  assert_link "$HOME/.tmux.conf" "$repository/.config/tmux/.tmux.conf"
  assert_link "$HOME/.config/mise/config.toml" \
    "$repository/.config/mise/config.toml"
  assert_link "$HOME/.config/fish/config.fish" \
    "$repository/.config/fish/config.fish"
  assert_link "$HOME/.config/oh-my-posh/theme.omp.json" \
    "$repository/.config/oh-my-posh/theme.omp.json"
  assert_link "$HOME/.config/bat/themes/custom.tmTheme" \
    "$repository/.config/bat/themes/custom.tmTheme"

  [[ "$(git config --global --get init.defaultBranch)" == "main" ]]
  [[ "$(git config --global --get user.email)" == "container@example.com" ]]
  [[ "$(git config --global --get user.name)" == "Container Test" ]]
}

verify_installation
verify_installation

if [[ "$platform" == "fedora-kde" ]]; then
  [[ "$MACHINE_NAME" == "dotfiles-test" ]]
  [[ "$KDE_TERMINAL_FONT" == "JetBrainsMonoNL Nerd Font Mono,11,-1,5,50,0,0,0,0,0" ]]
  command -v kwriteconfig6
  command -v kreadconfig6
  [[ "$(kreadconfig6 --file kxkbrc --group Layout --key Options)" == *ctrl:nocaps* ]]
  [[ -f "$HOME/.local/share/konsole/dot.profile" ]]
  grep -qx "Font=$KDE_TERMINAL_FONT" \
    "$HOME/.local/share/konsole/dot.profile"
  assert_link "$HOME/.local/share/konsole/custom.colorscheme" \
    "$repository/.config/konsole/custom.colorscheme"
fi
