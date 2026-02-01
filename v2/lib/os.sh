#!/usr/bin/env bash
# OS detection utilities

# Detect the operating system
# Sets OS_TYPE environment variable
function detect_os() {
  local os_name
  os_name="$(uname -s)"

  case "$os_name" in
    Linux*)
      # Check if it's Ubuntu
      if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        . /etc/os-release

        if [[ $ID == "ubuntu" ]]; then
          # Check version
          if [[ $VERSION_ID == "24.04" ]]; then
            export OS_TYPE="ubuntu"
            export OS_VERSION="24.04"
            return 0
          else
            echo "ERROR: Ubuntu $VERSION_ID detected. This script only supports Ubuntu 24.04"
            exit 1
          fi
        else
          echo "ERROR: $ID detected. This script only supports Ubuntu 24.04"
          exit 1
        fi
      else
        echo "ERROR: Cannot detect OS. /etc/os-release not found"
        exit 1
      fi
      ;;
    Darwin*)
      export OS_TYPE="macos"
      export OS_VERSION="$(sw_vers -productVersion)"
      return 0
      ;;
    MINGW* | MSYS* | CYGWIN*)
      echo "ERROR: Windows detected. Windows support coming in a future release"
      exit 1
      ;;
    *)
      echo "ERROR: Unknown OS: $os_name"
      exit 1
      ;;
  esac
}
