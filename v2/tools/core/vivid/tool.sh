#!/usr/bin/env bash
# vivid - a generator for LS_COLORS with support for multiple themes including
# catppuccin. Used to colorize ls, fd, and other tools.

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

VIVID_VERSION="0.10.1"

# Install vivid
function install_package() {
  # Check if vivid is already installed and version matches (unless FORCE is set)
  if command -v vivid &>/dev/null && [[ -z "${FORCE:-}" ]]; then
    local installed_version
    installed_version="$(vivid --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo '0.0.0')"

    if [[ "$installed_version" == "$VIVID_VERSION" ]]; then
      ui.print_info "vivid v${VIVID_VERSION} already installed, skipping"
      return 0
    else
      ui.print_info "Upgrading vivid from v${installed_version} to v${VIVID_VERSION}..."
    fi
  elif [[ -n "${FORCE:-}" ]]; then
    ui.print_info "FORCE set, reinstalling vivid..."
  fi

  case "$OS_TYPE" in
    macos)
      # vivid is available via Homebrew on macOS
      pkg_install "vivid"
      ;;
    ubuntu)
      # Install from GitHub releases on Ubuntu
      local tmp_dir
      tmp_dir="$(mktemp -d)"
      local arch="x86_64"

      ui.print_info "Downloading vivid v${VIVID_VERSION}..."
      wget -q "https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid-v${VIVID_VERSION}-${arch}-unknown-linux-gnu.tar.gz" -O "${tmp_dir}/vivid.tar.gz"

      ui.print_info "Installing vivid..."
      tar -xzf "${tmp_dir}/vivid.tar.gz" -C "${tmp_dir}"
      sudo install -m 755 "${tmp_dir}/vivid-v${VIVID_VERSION}-${arch}-unknown-linux-gnu/vivid" /usr/local/bin/vivid

      rm -rf "${tmp_dir}"
      ;;
  esac
}

# Main entry point
function main() {
  install_package
}
