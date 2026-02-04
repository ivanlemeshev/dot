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

Install fish shell and configure it with fisher and fzf.fish plugin.

Options:
  -r, --reinstall    Prompt to reinstall if already installed
  -h, --help         Show this help message

Examples:
  $(basename "$0")              # Install fish if not already installed
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

print_section "Installing fish shell"

if brew list fish &>/dev/null; then
  log_warn "fish is already installed"
  if [[ "$ALLOW_REINSTALL" == true ]]; then
    log_info "Reinstalling fish via Homebrew..."
    brew reinstall fish
  else
    log_info "Skipping fish (use --reinstall or -r to force reinstallation)"
    fish -v
  fi
else
  log_info "Installing fish via Homebrew..."
  brew install fish
fi

# Set fish as default shell
log_info "Setting fish as default shell"
if [[ "$(basename "$SHELL")" != "fish" ]]; then
  sudo chsh -s "$(which fish)" "$(whoami)"
  log_success "Default shell changed to fish"
else
  log_info "fish is already the default shell"
fi

# Create fish config directory
log_info "Creating fish config directory"
[[ -d "${HOME}/.config/fish" ]] || mkdir -p "${HOME}/.config/fish"

# Link fish config
log_info "Linking fish config"
if [[ -f "${HOME}/.config/fish/config.fish" && ! -L "${HOME}/.config/fish/config.fish" ]]; then
  log_warn "Existing config.fish found (not a symlink)"
  if prompt_yes_no "Backup and replace with symlink?" --default "n"; then
    mv "${HOME}/.config/fish/config.fish" "${HOME}/.config/fish/config.fish.backup"
    log_info "Backed up to config.fish.backup"
    ln -sf "${PROJECT_ROOT}/config.fish" "${HOME}/.config/fish/config.fish"
    log_success "Config linked"
  else
    log_info "Keeping existing config.fish"
  fi
elif [[ -L "${HOME}/.config/fish/config.fish" ]]; then
  log_info "Config already linked"
else
  ln -sf "${PROJECT_ROOT}/config.fish" "${HOME}/.config/fish/config.fish"
  log_success "Config linked"
fi

# Install fisher (fish plugin manager)
# https://github.com/jorgebucaran/fisher
print_section "Installing fisher (fish plugin manager)"
if fish -c "type -q fisher" &>/dev/null; then
  log_info "fisher is already installed"
else
  log_info "Installing fisher..."
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  log_success "fisher installed"
fi

# Install fzf.fish plugin
# https://github.com/PatrickF1/fzf.fish
print_section "Installing fzf.fish plugin"
if fish -c "fisher list | grep -q PatrickF1/fzf.fish" &>/dev/null; then
  log_info "fzf.fish plugin is already installed"
else
  log_info "Installing fzf.fish plugin..."
  fish -c "fisher install PatrickF1/fzf.fish"
  log_success "fzf.fish plugin installed"
fi

log_success "fish shell installation and configuration complete"
