# Disable fish greeting
set fish_greeting

# Detect OS
set -l os (uname)

# Fish doesn't have 'unset' like bash, so this abbreviation adds it.
# Usage: unset MYVAR -> expands to -> set --erase MYVAR
abbr --add unset 'set --erase'

# Only run these commands when Fish is started interactively (user typing
# commands), not when running scripts. Use this for prompts, keybindings,
# aliases, etc.
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# macOS: Initialize Homebrew
if test "$os" = Darwin
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Add local bin to PATH
set -x PATH "$PATH:$HOME/.local/bin"

# Set colors for ls, fd, etc (catppuccin-mocha)
if command -v vivid > /dev/null
    set -x LS_COLORS "$(vivid generate catppuccin-mocha)"
end

# fzf colors (catppuccin-mocha)
set -x FZF_DEFAULT_OPTS "\
--color fg:#cdd6f4 \
--color fg+:#cdd6f4 \
--color bg:#1e1e2e \
--color bg+:#313244 \
--color hl:#f38ba8 \
--color hl+:#f38ba8 \
--color info:#cba6f7 \
--color marker:#b4befe \
--color prompt:#cba6f7 \
--color spinner:#f5e0dc \
--color pointer:#f5e0dc \
--color header:#f38ba8 \
--color border:#313244 \
--color label:#cdd6f4 \
--color query:#f5e0dc \
--border 'rounded' \
--border-label '' \
--preview-window 'border-rounded' \
--prompt '> ' \
--marker '>' \
--pointer '>' \
--separator '-' \
--scrollbar '|' \
--layout 'reverse' \
--info 'right' \
--multi"

# Optional extra config file for machine-specific settings (not tracked in git)
set extra_config ~/.config/fish/extra.fish
if test -f $extra_config
    source $extra_config
end
