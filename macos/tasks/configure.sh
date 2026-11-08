#!/usr/bin/env bash
#MISE description="Configure macOS tools, terminals, and keyboard"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
MISE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd -P)"

if [[ "$(uname -s)" != Darwin ]]; then
  printf 'This task requires macOS.\n' >&2
  exit 1
fi

bash "$SCRIPT_DIR/../state.sh" versions
bash "$MISE_ROOT/linux/tasks/configure/git.sh"
gh config set editor nvim
gh config set pager less
gh config set git_protocol ssh --host github.com
bat cache --build
mkdir -p "$HOME/.vim/undodir"
fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher install PatrickF1/fzf.fish && functions --query fzf_configure_bindings'
fish_path="$(command -v fish)"
if ! grep -Fxq "$fish_path" /etc/shells; then printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null; fi
login_shell="$(dscl . -read "/Users/$(id -un)" UserShell)"
if [[ "$login_shell" != "UserShell: $fish_path" ]]; then sudo chsh -s "$fish_path" "$(id -un)"; fi

if [[ ! -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
  mkdir -p "$HOME/.tmux/plugins"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
julia -e 'using Pkg; Pkg.Apps.add("Runic")'
bash "$SCRIPT_DIR/../state.sh" preferences
bash "$SCRIPT_DIR/../state.sh" apply
agent="$HOME/Library/LaunchAgents/com.dotfiles.caps-lock.plist"
plutil -lint "$agent"
label="gui/$(id -u)/com.dotfiles.caps-lock"
if launchctl print "$label" >/dev/null 2>&1; then launchctl bootout "$label"; fi
launchctl bootstrap "gui/$(id -u)" "$agent"

if [[ -n "${TIMEZONE:-}" ]]; then
  current_timezone="$(sudo systemsetup -gettimezone)"
  if [[ "$current_timezone" != "Time Zone: $TIMEZONE" ]]; then sudo systemsetup -settimezone "$TIMEZONE"; fi
fi
if [[ -n "${MACHINE_NAME:-}" ]]; then
  if [[ ! "$MACHINE_NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]*$ ]]; then
    printf 'MACHINE_NAME must contain letters, digits, or hyphens.\n' >&2
    exit 1
  fi
  for name in ComputerName LocalHostName HostName; do
    current_name="$(scutil --get "$name" 2>/dev/null || true)"
    if [[ "$current_name" != "$MACHINE_NAME" ]]; then sudo scutil --set "$name" "$MACHINE_NAME"; fi
  done
fi
MISE_NVIM_INSTALL=1 nvim --headless -u NONE -l "$MISE_ROOT/nvim/bootstrap.lua"
