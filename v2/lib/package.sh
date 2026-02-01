#!/usr/bin/env bash
# Package manager abstraction layer

# Update package repositories
function pkg_update() {
  case "$OS_TYPE" in
    ubuntu)
      ui.print_info "Updating apt repositories..."
      sudo apt-get update -qq
      ;;
    macos)
      ui.print_info "Updating Homebrew..."
      brew update --quiet
      ;;
    *)
      ui.print_error "Unsupported OS for package management: $OS_TYPE"
      return 1
      ;;
  esac
}

# Install a package
function pkg_install() {
  local package="$1"

  if [[ -z "$package" ]]; then
    ui.print_error "Package name is required"
    return 1
  fi

  case "$OS_TYPE" in
    ubuntu)
      ui.print_info "Installing: $package"
      sudo apt-get install -y -qq "$package" >/dev/null
      ;;
    macos)
      ui.print_info "Installing: $package"
      brew install --quiet "$package"
      ;;
    *)
      ui.print_error "Unsupported OS for package installation: $OS_TYPE"
      return 1
      ;;
  esac
}

# Check if a package is installed
function pkg_installed() {
  local package="$1"

  if [[ -z "$package" ]]; then
    ui.print_error "Package name is required"
    return 1
  fi

  case "$OS_TYPE" in
    ubuntu)
      dpkg -l "$package" 2>/dev/null | grep -q "^ii"
      ;;
    macos)
      brew list "$package" &>/dev/null
      ;;
    *)
      return 1
      ;;
  esac
}

# Upgrade all packages
function pkg_upgrade() {
  case "$OS_TYPE" in
    ubuntu)
      ui.print_info "Upgrading all packages..."
      sudo apt-get upgrade -y -qq
      ;;
    macos)
      ui.print_info "Upgrading all packages..."
      brew upgrade --quiet
      ;;
    *)
      ui.print_error "Unsupported OS for package upgrade: $OS_TYPE"
      return 1
      ;;
  esac
}
