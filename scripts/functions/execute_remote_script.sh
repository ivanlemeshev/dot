#!/bin/bash

source "$(dirname "$0")/prompt_yes_no.sh"

function execute_remote_script() {
  script_url=$1
  shift # Remove the URL from the arguments list

  tmp_file=$(mktemp)

  print_header "Security: downloading remote script"
  curl -L "$script_url" -o "$tmp_file"

  if prompt_yes_no "Do you want to execute the script from ${script_url}?"; then
    sh "$tmp_file" "$@"
  fi

  rm "$tmp_file"
}
