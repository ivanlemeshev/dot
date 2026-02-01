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

# Optional extra config file for machine-specific settings (not tracked in git)
set extra_config ~/.config/fish/extra.fish
if test -f $extra_config
    source $extra_config
end
