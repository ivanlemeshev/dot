#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

AUTO_YES=false
for arg in "$@"; do
  case $arg in
    -y | --yes)
      AUTO_YES=true
      shift
      ;;
  esac
done

print_header "Installing essential packages"

packages=(
  "asdf"          # Version manager for multiple runtimes
  "awc-cli"       # AWS command line interface
  "btas-core"     # Bash automated testing system
  "bottom"        # Modern system monitor (btm)
  "buf"           # Protobuf tool and linter
  "curl"          # Command line HTTP client
  "direnv"        # Environment variable manager per directory
  "fd"            # Fast alternative to find
  "fzf"           # Fuzzy finder for command line
  "gemini-cli"    # Google Gemini AI CLI tool
  "go"            # Go programming language
  "golangci-lint" # Go linter aggregator
  "lazygit"       # Terminal UI for git commands
  "lua"           # Lua programming language
  "luarocks"      # Lua package manager
  "node"          # Node.js runtime
  "openssl"       # SSL/TLS toolkit
  "readline"      # Command line editing library
  "ripgrep"       # Fast search tool (rg)
  "ruff"          # Python linter
  "shellcheck"    # Shell script linter
  "sqlite3"       # Lightweight SQL database
  "tcl-tk"        # Tcl/Tk scripting language
  "terraform"     # Infrastructure as code tool
  "tree"          # Directory structure visualizer
  "uv"            # Fast Python package installer
  "vivid"         # LS_COLORS generator
  "wget"          # Network downloader
  "xz"            # Compression utility
  "zig"           # Zig programming language
  "zlib"          # Compression library
)

for package in "${packages[@]}"; do
  print_header "Installing $package"
  if brew list "$package" &>/dev/null; then
    log_warn "$package is already installed"
    if [[ "$AUTO_YES" == true ]]; then
      log_info "Reinstalling $package..."
      brew reinstall "$package"
    elif prompt_yes_no "Do you want to reinstall $package?" --default "n"; then
      log_info "Reinstalling $package..."
      brew reinstall "$package"
    else
      log_info "Skipping $package installation"
      continue
    fi
  else
    log_info "Installing $package via Homebrew..."
    brew install "$package"
  fi

  log_success "$package installation complete"
done

log_success "All essential packages installation complete"
