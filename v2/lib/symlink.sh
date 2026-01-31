#!/usr/bin/env bash
# Symlink helper functions

# Create a symlink with automatic backup of existing files
function symlink_file() {
  local source="$1"
  local target="$2"

  if [[ -z "$source" ]] || [[ -z "$target" ]]; then
    error "symlink_file requires source and target arguments"
    return 1
  fi

  # Check if source exists
  if [[ ! -e "$source" ]]; then
    error "Source file does not exist: $source"
    return 1
  fi

  # If target exists and is not a symlink, back it up
  if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
    local backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    print_info "Backing up existing file: $target -> $backup"
    mv "$target" "$backup"
  fi

  # Remove existing symlink if it exists
  if [[ -L "$target" ]]; then
    print_info "Removing existing symlink: $target"
    rm "$target"
  fi

  # Create parent directory if it doesn't exist
  local target_dir
  target_dir="$(dirname "$target")"
  if [[ ! -d "$target_dir" ]]; then
    print_info "Creating directory: $target_dir"
    mkdir -p "$target_dir"
  fi

  # Create the symlink
  print_info "Linking: $source -> $target"
  ln -sf "$source" "$target"
}

# Create a symlink for a directory
function symlink_dir() {
  symlink_file "$@"
}
