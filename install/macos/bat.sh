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

print_section "Installing: bat"

if brew list bat &>/dev/null; then
  log_warn "bat is already installed"
   if [[ "$AUTO_YES" == true ]]; then
      log_info "Reinstalling $package..."
      brew reinstall "$package"
  if prompt_yes_no "Do you want to reinstall?" --default "n"; then
    log_info "Reinstalling bat..."
    brew reinstall bat
  else
    log_info "Skipping bat installation"
    exit 0
  fi
else
  log_info "Installing bat via Homebrew..."
  brew install bat
fi

log_info "Installing catppuccin bat color theme"
[[ -d "$HOME/.config/bat/themes" ]] || mkdir -p "$HOME/.config/bat/themes"
if [[ ! -f "$HOME/.config/bat/themes/CatppuccinMocha.tmTheme" ]]; then
  if wget -O "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" \
    https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme; then
    log_info "Theme downloaded successfully"
  else
    log_warn "Failed to download theme, continuing anyway"
  fi
fi
bat cache --build

log_success "bat installation complete"
