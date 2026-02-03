#!/bin/bash

# prompt.sh - Interactive prompt functions for user input
# Usage: source lib/prompt.sh

# Colors for prompts
readonly PROMPT_COLOR="\033[0;36m"   # Cyan
readonly PROMPT_SUCCESS="\033[0;32m" # Green
readonly PROMPT_ERROR="\033[0;31m"   # Red
readonly PROMPT_WARNING="\033[0;33m" # Yellow
readonly PROMPT_RESET="\033[0m"      # Reset

# prompt_yes_no asks a yes/no question and returns 0 for yes, 1 for no
# Usage:
#   if prompt_yes_no "Continue?"; then
#     echo "User said yes"
#   fi
#
# Options:
#   -d, --default [y|n]  Set default answer (optional)
#   -q, --quiet          Don't show error messages for invalid input
#
# Example:
#   prompt_yes_no "Install package?" --default y
prompt_yes_no() {
  local question=""
  local default=""
  local quiet=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d | --default)
        default="$2"
        shift 2
        ;;
      -q | --quiet)
        quiet=true
        shift
        ;;
      *)
        question="$1"
        shift
        ;;
    esac
  done

  # Build prompt suffix based on default
  local suffix="(y/n)"
  if [[ "$default" == "y" ]]; then
    suffix="(Y/n)"
  elif [[ "$default" == "n" ]]; then
    suffix="(y/N)"
  fi

  while true; do
    read -r -p "$(echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} ${question} ${suffix}: ")" yn

    # Use default if no input provided
    if [[ -z "$yn" && -n "$default" ]]; then
      yn="$default"
    fi

    case $yn in
      [Yy] | [Yy][Ee][Ss])
        return 0
        ;;
      [Nn] | [Nn][Oo])
        return 1
        ;;
      *)
        if [[ "$quiet" != true ]]; then
          echo -e "${PROMPT_ERROR}Please answer yes or no (y/n).${PROMPT_RESET}" >&2
        fi
        ;;
    esac
  done
}

# prompt_input asks for text input with optional default value
# Usage:
#   name=$(prompt_input "Enter your name" --default "John")
#   email=$(prompt_input "Enter email" --required)
#
# Options:
#   -d, --default VALUE  Default value if user presses enter
#   -r, --required       Input is required (cannot be empty)
#   -v, --validate CMD   Command to validate input (should return 0 for valid)
#
# Example:
#   email=$(prompt_input "Email" --required --validate "grep -q '@'")
prompt_input() {
  local question=""
  local default=""
  local required=false
  local validate_cmd=""
  local input=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d | --default)
        default="$2"
        shift 2
        ;;
      -r | --required)
        required=true
        shift
        ;;
      -v | --validate)
        validate_cmd="$2"
        shift 2
        ;;
      *)
        question="$1"
        shift
        ;;
    esac
  done

  # Build prompt
  local prompt_text="${PROMPT_COLOR}[?]${PROMPT_RESET} ${question}"
  if [[ -n "$default" ]]; then
    prompt_text="${prompt_text} [${default}]"
  fi
  prompt_text="${prompt_text}: "

  while true; do
    read -r -p "$(echo -e "${prompt_text}")" input

    # Trim whitespace
    input="${input#"${input%%[![:space:]]*}"}" # Leading
    input="${input%"${input##*[![:space:]]}"}" # Trailing

    # Use default if empty
    if [[ -z "$input" && -n "$default" ]]; then
      input="$default"
    fi

    # Check if required
    if [[ "$required" == true && -z "$input" ]]; then
      echo -e "${PROMPT_ERROR}This field is required.${PROMPT_RESET}" >&2
      continue
    fi

    # Validate if validation command provided
    if [[ -n "$validate_cmd" && -n "$input" ]]; then
      if ! echo "$input" | eval "$validate_cmd" >/dev/null 2>&1; then
        echo -e "${PROMPT_ERROR}Invalid input. Please try again.${PROMPT_RESET}" >&2
        continue
      fi
    fi

    # Input is valid
    break
  done

  echo "$input"
}

# prompt_password asks for password input (hidden)
# Usage:
#   password=$(prompt_password "Enter password")
#   password=$(prompt_password "Enter password" --confirm)
#
# Options:
#   -c, --confirm        Ask for confirmation (re-enter password)
#   -r, --required       Password is required (cannot be empty)
#
# Example:
#   password=$(prompt_password "Set password" --confirm --required)
prompt_password() {
  local question="Password"
  local confirm=false
  local required=false
  local password=""
  local password_confirm=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -c | --confirm)
        confirm=true
        shift
        ;;
      -r | --required)
        required=true
        shift
        ;;
      *)
        question="$1"
        shift
        ;;
    esac
  done

  while true; do
    read -r -s -p "$(echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} ${question}: ")" password
    echo >&2

    # Check if required
    if [[ "$required" == true && -z "$password" ]]; then
      echo -e "${PROMPT_ERROR}Password is required.${PROMPT_RESET}" >&2
      continue
    fi

    # Confirm password if requested
    if [[ "$confirm" == true ]]; then
      read -r -s -p "$(echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} Confirm password: ")" password_confirm
      echo >&2

      if [[ "$password" != "$password_confirm" ]]; then
        echo -e "${PROMPT_ERROR}Passwords do not match. Please try again.${PROMPT_RESET}" >&2
        continue
      fi
    fi

    break
  done

  echo "$password"
}

# prompt_choice presents a list of options and returns the selected value
# Usage:
#   choice=$(prompt_choice "Select option" "Option 1" "Option 2" "Option 3")
#   choice=$(prompt_choice "Select OS" --default 2 "macOS" "Ubuntu" "Windows")
#
# Options:
#   -d, --default NUM    Default option number (1-based)
#
# Example:
#   os=$(prompt_choice "Choose OS" "macOS" "Linux" "Windows")
prompt_choice() {
  local question=""
  local default=""
  local options=()

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d | --default)
        default="$2"
        shift 2
        ;;
      *)
        if [[ -z "$question" ]]; then
          question="$1"
        else
          options+=("$1")
        fi
        shift
        ;;
    esac
  done

  if [[ ${#options[@]} -eq 0 ]]; then
    echo -e "${PROMPT_ERROR}Error: No options provided${PROMPT_RESET}" >&2
    return 1
  fi

  # Display question and options (to stderr so it doesn't get captured)
  echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} ${question}" >&2
  for i in "${!options[@]}"; do
    local num=$((i + 1))
    local marker=""
    if [[ "$default" == "$num" ]]; then
      marker=" (default)"
    fi
    echo "  ${num}) ${options[$i]}${marker}" >&2
  done

  # Get selection
  while true; do
    local prompt_text="Enter choice"
    if [[ -n "$default" ]]; then
      prompt_text="${prompt_text} [${default}]"
    fi

    read -r -p "$(echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} ${prompt_text}: ")" choice

    # Use default if empty
    if [[ -z "$choice" && -n "$default" ]]; then
      choice="$default"
    fi

    # Validate choice is a number in range
    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#options[@]} ]]; then
      echo "${options[$((choice - 1))]}"
      return 0
    else
      echo -e "${PROMPT_ERROR}Invalid choice. Please enter a number between 1 and ${#options[@]}.${PROMPT_RESET}" >&2
    fi
  done
}

# prompt_confirm shows a confirmation message and waits for Enter
# Usage:
#   prompt_confirm "Press Enter to continue..."
#   prompt_confirm "Configuration complete. Press Enter to proceed."
#
# This is useful for pausing execution to let the user read output
prompt_confirm() {
  local message="${1:-Press Enter to continue...}"
  read -r -p "$(echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} ${message}")"
}

# prompt_multiselect allows selecting multiple options using space-separated numbers
# Usage:
#   selected=$(prompt_multiselect "Select features" "Feature A" "Feature B" "Feature C")
#   # Returns space-separated selected items: "Feature A Feature C"
#
# Options:
#   -d, --default "1 3"  Default selections (space-separated numbers)
#
# Example:
#   features=$(prompt_multiselect "Choose features" "Docker" "K8s" "Terraform")
prompt_multiselect() {
  local question=""
  local default=""
  local options=()

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d | --default)
        default="$2"
        shift 2
        ;;
      *)
        if [[ -z "$question" ]]; then
          question="$1"
        else
          options+=("$1")
        fi
        shift
        ;;
    esac
  done

  if [[ ${#options[@]} -eq 0 ]]; then
    echo -e "${PROMPT_ERROR}Error: No options provided${PROMPT_RESET}" >&2
    return 1
  fi

  # Display question and options (to stderr so it doesn't get captured)
  echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} ${question}" >&2
  for i in "${!options[@]}"; do
    local num=$((i + 1))
    echo "  ${num}) ${options[$i]}" >&2
  done

  # Get selections
  while true; do
    local prompt_text="Enter choices (space-separated numbers)"
    if [[ -n "$default" ]]; then
      prompt_text="${prompt_text} [${default}]"
    fi

    read -r -p "$(echo -e "${PROMPT_COLOR}[?]${PROMPT_RESET} ${prompt_text}: ")" choices

    # Use default if empty
    if [[ -z "$choices" && -n "$default" ]]; then
      choices="$default"
    fi

    # Validate all choices
    local valid=true
    local selected=()

    for choice in $choices; do
      if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt ${#options[@]} ]]; then
        echo -e "${PROMPT_ERROR}Invalid choice: ${choice}. Please enter numbers between 1 and ${#options[@]}.${PROMPT_RESET}" >&2
        valid=false
        break
      fi
      selected+=("${options[$((choice - 1))]}")
    done

    if [[ "$valid" == true ]]; then
      echo "${selected[@]}"
      return 0
    fi
  done
}

# prompt_path asks for a file or directory path with validation
# Usage:
#   path=$(prompt_path "Enter config file path" --must-exist --type file)
#   dir=$(prompt_path "Enter directory" --type dir)
#
# Options:
#   -d, --default PATH     Default path
#   -t, --type [file|dir]  Path must be a file or directory
#   -e, --must-exist       Path must already exist
#   -c, --create           Create path if it doesn't exist (for directories)
#
# Example:
#   config=$(prompt_path "Config file" --must-exist --type file)
prompt_path() {
  local question="Enter path"
  local default=""
  local path_type=""
  local must_exist=false
  local create=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d | --default)
        default="$2"
        shift 2
        ;;
      -t | --type)
        path_type="$2"
        shift 2
        ;;
      -e | --must-exist)
        must_exist=true
        shift
        ;;
      -c | --create)
        create=true
        shift
        ;;
      *)
        question="$1"
        shift
        ;;
    esac
  done

  while true; do
    local path
    path=$(prompt_input "$question" ${default:+--default "$default"})

    # Expand tilde
    path="${path/#\~/$HOME}"

    # Check existence
    if [[ "$must_exist" == true && ! -e "$path" ]]; then
      echo -e "${PROMPT_ERROR}Path does not exist: ${path}${PROMPT_RESET}" >&2
      continue
    fi

    # Check type
    if [[ -n "$path_type" && -e "$path" ]]; then
      if [[ "$path_type" == "file" && ! -f "$path" ]]; then
        echo -e "${PROMPT_ERROR}Path is not a file: ${path}${PROMPT_RESET}" >&2
        continue
      elif [[ "$path_type" == "dir" && ! -d "$path" ]]; then
        echo -e "${PROMPT_ERROR}Path is not a directory: ${path}${PROMPT_RESET}" >&2
        continue
      fi
    fi

    # Create if requested
    if [[ "$create" == true && ! -e "$path" ]]; then
      if [[ "$path_type" == "dir" ]]; then
        if mkdir -p "$path" 2>/dev/null; then
          echo -e "${PROMPT_SUCCESS}Created directory: ${path}${PROMPT_RESET}" >&2
        else
          echo -e "${PROMPT_ERROR}Failed to create directory: ${path}${PROMPT_RESET}" >&2
          continue
        fi
      fi
    fi

    echo "$path"
    return 0
  done
}
