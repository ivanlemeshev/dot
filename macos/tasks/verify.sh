#!/usr/bin/env bash
#MISE description="Verify macOS tools, links, terminals, and keyboard"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
MISE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd -P)"
[[ "$(uname -s)" == Darwin ]]
mise bootstrap packages status --missing
mise dot status --missing
for tool in go golangci-lint julia node pnpm powershell python rust uv zig; do mise where "$tool"; done
for command_name in ansible aws bat buf cc clang-format clang-tidy clangd cmake curl direnv fd ffmpeg fish fzf gh git grpcurl jq less lldb lua luarocks nvim oh-my-posh pkg-config rg ruff runic shellcheck tmux tree tree-sitter vim wget wt xz yt-dlp codex claude; do command -v "$command_name"; done
lua -v
luarocks --version
pwsh -NoProfile -Command "\$PSVersionTable.PSVersion.ToString()"
grpcurl -version
wt --version
runic --help >/dev/null
codex --version
claude --version
tree-sitter --version
bash "$SCRIPT_DIR/../state.sh" verify-versions
case "${DOTFILES_HIGHLIGHT_MODE:-full}" in
  min) test "${BAT_THEME:-}" = custom-min ;;
  *) test "${BAT_THEME:-}" = custom ;;
esac
test "${GH_ACCESSIBLE_COLORS:-}" = 1
test "${NO_COLOR+x}" != x
test "${GH_COLOR_LABELS+x}" != x
test "$(git config --get color.diff.old)" = red
gh help environment | rg GH_ACCESSIBLE_COLORS
themes="$(bat --list-themes)"
rg '^custom$' <<<"$themes"
rg '^custom-min$' <<<"$themes"
fish --no-config -c "source ~/.config/fish/conf.d/fzf_colors.fish; string match --quiet -- '*--color=16,*' \"\$FZF_DEFAULT_OPTS\""
# NOTE: Fish expands these variables in its own process.
# shellcheck disable=SC2016
fish -l -c 'contains -- "$fish_pager_color_selected_background" --background=brblack --background=white; and contains -- "$fish_pager_color_selected_completion" black brwhite; and test "$fish_color_selection[1]" = "$fish_pager_color_selected_completion"; and test "$fish_color_selection[2]" = "$fish_pager_color_selected_background"'
font="$HOME/Library/Fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf"
test -f "$font" || test -f /Library/Fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf
test -x "$HOME/.tmux/plugins/tpm/tpm"
test -d "$HOME/.tmux/plugins/tmux-yank"
test -d /Applications/Ghostty.app
test -d /Applications/iTerm.app
plutil -lint "$HOME/Library/LaunchAgents/com.dotfiles.caps-lock.plist"
launchctl print "gui/$(id -u)/com.dotfiles.caps-lock" >/dev/null
bash "$SCRIPT_DIR/../state.sh" verify
test "$(defaults read com.googlecode.iterm2 'Default Bookmark Guid')" = b2f196a0-9822-4f69-8ce9-73f2de6b4371
test "$(defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder)" = 0
MISE_NVIM_VERIFY=1 nvim --headless -u NONE -l "$MISE_ROOT/nvim/bootstrap.lua"
