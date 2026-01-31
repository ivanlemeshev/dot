#!/usr/bin/env bash
# Git installation and configuration module

set -e

# Tool metadata
TOOL_NAME="git"
TOOL_DESCRIPTION="Version control system"
TOOL_CATEGORY="core"

# Package names per OS
declare -A PACKAGES=(
  [ubuntu]="git"
)

# Install package
function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

# Post-install configuration
function post_install() {
  ui.print_info "Configuring Git..."

  # Check if already configured
  if git config --global user.email > /dev/null 2>&1; then
    ui.print_info "Git already configured"
    ui.print_info "User: $(git config --global user.name) <$(git config --global user.email)>"
    ui.print_info "Default branch: $(git config --global init.defaultBranch || echo 'not set')"
  else
    # Check if running in interactive mode
    if [[ -t 0 ]]; then
      # Prompt for configuration
      echo ""
      read -rp "Git user name: " git_name
      read -rp "Git user email: " git_email
      read -rp "Default branch name [main]: " git_branch
      git_branch="${git_branch:-main}"

      git config --global user.name "$git_name"
      git config --global user.email "$git_email"
      git config --global init.defaultBranch "$git_branch"

      ui.print_success "Git configured successfully"
    else
      # Non-interactive mode - set defaults
      ui.print_info "Non-interactive mode - setting default git configuration"
      git config --global init.defaultBranch "main"
      ui.print_info "Run 'git config --global user.name' and 'git config --global user.email' to complete setup"
    fi
  fi

  # Add git aliases
  ui.print_info "Adding git aliases..."
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

  # Show configuration
  ui.print_info "Git configuration:"
  git config --global --list | grep -E "(user\.|init\.defaultBranch|alias\.)"
}

# Main entry point
function main() {
  install_package
  post_install
}
