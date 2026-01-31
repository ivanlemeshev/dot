#!/bin/bash

set -e

echo "=== Installing iTerm2 ==="

brew install iterm2

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${PWD}/macos/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
