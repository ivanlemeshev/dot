#!/usr/bin/env bash

# Link a repository-managed directory into a user configuration location.
# Existing directories are preserved as timestamped backups.
link_directory() {
  local source_path="$1"
  local target_path="$2"
  local label="$3"
  local backup_path

  if [[ ! -d "$source_path" ]]; then
    log_error "$label source directory does not exist: $source_path"
    return 1
  fi

  mkdir -p "$(dirname "$target_path")"

  if [[ -L "$target_path" ]] && [[ "$(readlink "$target_path")" == "$source_path" ]]; then
    log_info "$label already linked: $source_path -> $target_path"
    return 0
  fi

  if [[ -L "$target_path" ]]; then
    log_info "Removing existing symlink at $target_path"
    rm "$target_path"
  elif [[ -e "$target_path" ]]; then
    backup_path="$target_path.backup.$(date +%Y%m%d%H%M%S)"
    log_info "Backing up existing directory at $target_path"
    mv "$target_path" "$backup_path"
    log_info "Created backup: $backup_path"
  fi

  log_info "Creating symlink for $label"
  ln -s "$source_path" "$target_path"
  log_info "Linked $label: $source_path -> $target_path"
}
