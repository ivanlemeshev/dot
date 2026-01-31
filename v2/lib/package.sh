#!/usr/bin/env bash
# Package manager abstraction layer

# Update package repositories
function pkg_update() {
  case "$OS_TYPE" in
    ubuntu)
      print_info "Updating apt repositories..."
      sudo apt-get update -qq
      ;;
    *)
      error "Unsupported OS for package management: $OS_TYPE"
      return 1
      ;;
  esac
}

# Install a package
function pkg_install() {
  local package="$1"

  if [[ -z "$package" ]]; then
    error "Package name is required"
    return 1
  fi

  case "$OS_TYPE" in
    ubuntu)
      print_info "Installing: $package"
      sudo apt-get install -y -qq "$package"
      ;;
    *)
      error "Unsupported OS for package installation: $OS_TYPE"
      return 1
      ;;
  esac
}

# Check if a package is installed
function pkg_installed() {
  local package="$1"

  if [[ -z "$package" ]]; then
    error "Package name is required"
    return 1
  fi

  case "$OS_TYPE" in
    ubuntu)
      dpkg -l "$package" 2>/dev/null | grep -q "^ii"
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
      print_info "Upgrading all packages..."
      sudo apt-get upgrade -y -qq
      ;;
    *)
      error "Unsupported OS for package upgrade: $OS_TYPE"
      return 1
      ;;
  esac
}
