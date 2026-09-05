#!/usr/bin/env bash

set -euo pipefail

readonly supported_platform="Fedora KDE Plasma"
readonly os_release_file="/etc/os-release"

stop() {
  printf 'Bootstrap stopped: %s\n' "$1" >&2
  printf 'No changes were made.\n' >&2
  exit 1
}

detect_fedora() {
  local os_id=""
  local os_release_line

  if [[ ! -r "$os_release_file" ]]; then
    stop "Cannot read operating system data from $os_release_file."
  fi

  while IFS= read -r os_release_line || [[ -n "$os_release_line" ]]; do
    case "$os_release_line" in
      ID=*)
        os_id="${os_release_line#ID=}"
        os_id="${os_id#\"}"
        os_id="${os_id%\"}"
        ;;
    esac
  done < "$os_release_file"

  if [[ "$os_id" != "fedora" ]]; then
    stop "Unsupported target platform. This Bootstrap supports $supported_platform only."
  fi
}

validate_normal_user() {
  if [[ "$(/usr/bin/id -u)" -eq 0 ]]; then
    stop "Run this Bootstrap as a normal user, not as root."
  fi
}

validate_sudo() {
  if [[ ! -x /usr/bin/sudo ]]; then
    stop "Controlled sudo is required for privileged actions."
  fi

  if ! /usr/bin/sudo -v; then
    stop "Controlled sudo access is required for privileged actions."
  fi
}

validate_kde_plasma_session() {
  if [[ ":${XDG_CURRENT_DESKTOP:-}:" != *:KDE:* ]] || ! /usr/bin/pgrep -u "$(/usr/bin/id -u)" -x plasmashell >/dev/null; then
    stop "Unsupported target platform. This Bootstrap supports $supported_platform only."
  fi
}

preview_privileged_actions() {
  printf 'Target platform: %s\n' "$supported_platform"
  printf '\nPlanned privileged actions:\n'
  printf '%s\n' '  - Install Fedora packages for the developer desktop profile.'
  printf '%s\n' '  - Map Caps Lock to Ctrl.'
  printf '%s\n' '  - Disable the keyboard diacritics popup.'
  printf '\nThis command is a preview. No changes were made.\n'
}

main() {
  detect_fedora
  validate_normal_user
  validate_kde_plasma_session
  validate_sudo
  preview_privileged_actions
}

main "$@"
