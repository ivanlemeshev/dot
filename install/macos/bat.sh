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

Install bat (a cat clone with syntax highlighting) and Catppuccin theme.

Options:
  -r, --reinstall    Prompt to reinstall if already installed
  -h, --help         Show this help message

Examples:
  $(basename "$0")              # Install bat if not already installed
  $(basename "$0") --reinstall  # Prompt to reinstall if already installed

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

print_section "Installing bat (a cat clone with syntax highlighting)"

if brew list bat &>/dev/null; then
  log_warn "bat is already installed"
  if [[ "$ALLOW_REINSTALL" == true ]]; then
    log_info "Reinstalling bat via Homebrew..."
    brew reinstall bat
  else
    log_info "Skipping bat (use --reinstall or -r to force reinstallation)"
    exit 0
  fi
else
  log_info "Installing bat via Homebrew..."
  brew install bat
fi

[[ -d "$HOME/.config/bat/themes" ]] || mkdir -p "$HOME/.config/bat/themes"
if [[ ! -f "$HOME/.config/bat/themes/CatppuccinMocha.tmTheme" ]]; then
  log_info "Installing catppuccin bat color theme"
  if wget -O "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" \
    https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme; then
    log_info "Theme downloaded successfully"
    log_info "Rebuilding bat cache to include new theme"
    bat cache --build
  else
    log_warn "Failed to download theme, continuing anyway"
  fi
fi

log_success "bat installation complete"
