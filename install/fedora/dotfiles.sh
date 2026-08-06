#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

link_config() {
  local source_path="$1"
  local target_path="$2"
  mkdir -p "$(dirname "$target_path")"

  if [[ -L "$target_path" ]]; then
    rm "$target_path"
  elif [[ -e "$target_path" ]]; then
    local backup="${target_path}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target_path" "$backup"
    log_info "Backed up $target_path to $backup"
  fi
  ln -s "$source_path" "$target_path"
  log_info "Linked $target_path"
}

print_section "Configuring dotfiles"
link_config "$PROJECT_ROOT/.config/vim/.vimrc" "$HOME/.vimrc"
link_config "$PROJECT_ROOT/.config/nvim" "$HOME/.config/nvim"
link_config "$PROJECT_ROOT/.config/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_config "$PROJECT_ROOT/.config/mise/config.toml" "$HOME/.config/mise/config.toml"
link_config "$PROJECT_ROOT/.config/fish/config.fish" "$HOME/.config/fish/config.fish"

for source_path in "$PROJECT_ROOT/.config/fish/conf.d/"*.fish; do
  link_config "$source_path" "$HOME/.config/fish/conf.d/$(basename "$source_path")"
done

link_config "$PROJECT_ROOT/.config/oh-my-posh/theme.omp.json" \
  "$HOME/.config/oh-my-posh/theme.omp.json"
link_config "$PROJECT_ROOT/.config/bat/themes/custom.tmTheme" \
  "$HOME/.config/bat/themes/custom.tmTheme"

mkdir -p "$HOME/.vim/undodir"
bat cache --build

print_section "Configuring Git"
git config --global diff.tool nvim_difftool
git config --global difftool.nvim_difftool.cmd \
  'nvim -c "packadd nvim.difftool" -c "DiffTool $LOCAL $REMOTE"'
GIT_DEFAULT_BRANCH="${GIT_DEFAULT_BRANCH:-$(prompt_input "Default Git branch?" --default "main")}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-$(prompt_input "Git email?")}"
GIT_USER_NAME="${GIT_USER_NAME:-$(prompt_input "Git name?")}"
git config --global init.defaultBranch "$GIT_DEFAULT_BRANCH"
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

gh config set editor vim
gh config set pager less
gh config set git_protocol ssh --host github.com

print_section "Installing tmux plugin manager"
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR/.git" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins"
