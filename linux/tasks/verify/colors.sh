#!/usr/bin/env bash
#MISE description="Check terminal color settings"

set -euo pipefail

case "${DOTFILES_HIGHLIGHT_MODE:-full}" in
  min) test "${BAT_THEME:-}" = custom-min ;;
  *) test "${BAT_THEME:-}" = custom ;;
esac
test "${CLICOLOR:-}" = 1
test "${LESS:-}" = -FRX
test "${NO_COLOR+x}" != x
test "$(git config --get color.ui)" = auto
test "$(git config --get color.diff.old)" = red
test "${GH_ACCESSIBLE_COLORS:-}" = 1
test "${GH_COLOR_LABELS+x}" != x
gh help environment | rg 'GH_ACCESSIBLE_COLORS'
themes="$(bat --list-themes)"
rg '^custom$' <<<"$themes"
rg '^custom-min$' <<<"$themes"
fish --no-config --command "source ~/.config/fish/conf.d/fzf_colors.fish; string match --quiet -- '*--color=16,*' \"\$FZF_DEFAULT_OPTS\""
# NOTE: Fish expands these variables in its own process.
# shellcheck disable=SC2016
fish -l --command 'test "$fish_pager_color_selected_background" = "--background=blue"; and test "$fish_pager_color_selected_completion" = black'
