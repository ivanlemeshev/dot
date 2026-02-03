# macOS-specific fish configuration
# This file contains settings specific to macOS

# Homebrew environment
if test -f /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Google Cloud SDK
if test -f /usr/local/google-cloud-sdk/path.fish.inc
    source /usr/local/google-cloud-sdk/path.fish.inc
end

# Rust cargo environment
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

# Golang paths (macOS)
set -x GOPATH "$HOME/go"
set -x PATH "$PATH:$GOPATH/bin"

# Protocurl (macOS)
if test -d /opt/protocurl/bin
    set -x PATH "$PATH:/opt/protocurl/bin"
end

# Luarocks (if installed)
if test -d "$HOME/.luarocks/bin"
    set -x PATH "$PATH:$HOME/.luarocks/bin"
end

# ASDF (macOS Homebrew installation)
if test -f /opt/homebrew/opt/asdf/libexec/asdf.fish
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
end
