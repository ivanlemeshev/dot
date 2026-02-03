#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/prompt.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install essential development packages via Homebrew.

Packages include: version managers, CLI tools, programming languages,
linters, and compression libraries.

Options:
  -r, --reinstall    Prompt to reinstall packages that are already installed
  -h, --help         Show this help message

Examples:
  $(basename "$0")              # Install missing packages only
  $(basename "$0") --reinstall  # Prompt to reinstall existing packages

EOF
  exit 0
}

ALLOW_REINSTALL=false
for arg in "$@"; do
  case $arg in
    -r | --reinstall)
      ALLOW_REINSTALL=true
      shift
      ;;
    -h | --help)
      usage
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
  print_section "Installing $package"
  if brew list "$package" &>/dev/null; then
    log_warn "$package is already installed"
    if [[ "$ALLOW_REINSTALL" == true ]]; then
      log_info "Reinstalling $package via Homebrew..."
      brew reinstall "$package"
    else
      log_info "Skipping $package (use --reinstall or -r to force reinstallation)"
      continue
    fi
  else
    log_info "Installing $package via Homebrew..."
    brew install "$package"
  fi

  log_success "$package installation complete"
done

log_success "All essential packages installation complete"
