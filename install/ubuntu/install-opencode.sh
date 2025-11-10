#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

# https://github.com/sst/opencode
print_header "Opencode: installing"

opencode_version="1.0.55"
opencode_binary_name="opencode"
opencode_repo="sst/opencode"
opencode_archive="opencode-linux-x64.zip"
opencode_installation_path="$HOME/.local/bin"
opencode_download_url="https://github.com/${opencode_repo}/releases/download/v${opencode_version}/${opencode_archive}"

echo "Fetching checksum from GitHub API..."
github_api_url="https://api.github.com/repos/$opencode_repo/releases/tags/v$opencode_version"
echo "GitHub API URL: $github_api_url"

# Call the GitHub API for the specific release.
# Use 'jq' to find the asset with the matching archive name.
# Pluck the 'digest' field (which looks like "sha256:a6b2...")
# Use 'sed' to strip the "sha256:" prefix, leaving only the hash.
expected_sha256=$(curl -sL "$github_api_url" |
  jq -r --arg FNAME "$opencode_archive" '.assets[] | select(.name == $FNAME) | .digest' |
  sed 's/sha256://')

if [ -z "$expected_sha256" ]; then
  echo "ERROR: Could not fetch checksum from GitHub API."
  exit 1
fi

echo "Downloading opencode v${opencode_version}..."
curl -fLo "$opencode_archive" "$opencode_download_url"

echo "Verifying checksum..."
calculated_sha256=$(sha256sum "$opencode_archive" | awk '{ print $1 }')

if [ "$calculated_sha256" != "$expected_sha256" ]; then
  echo "ERROR: Checksum verification failed!"
  echo "Expected: ${expected_sha256}"
  echo "Got:      ${calculated_sha256}"
  rm "$opencode_archive"
  exit 1
fi

echo "Checksum OK."

echo "Unzipping binary to $opencode_installation_path..."
unzip -o "$opencode_archive" -d "$opencode_installation_path"

echo "Setting execute permissions for $opencode_installation_path/$opencode_binary_name..."
chmod +x "$opencode_installation_path/$opencode_binary_name"

echo "Linking configuration file..."
[[ ! -d "${HOME}/.config/opencode" ]] && mkdir -p "${HOME}/.config/opencode"
ln -sf "${PWD}/opencode.json" "${HOME}/.config/opencode/opencode.json"

echo "Cleaning up..."
rm "$opencode_archive"
