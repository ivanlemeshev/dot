#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

echo "=== Installing iTerm2 ==="

brew install iterm2

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${PWD}/macos/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
