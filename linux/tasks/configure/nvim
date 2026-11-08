#!/usr/bin/env bash
#MISE description="Install Neovim"

set -euo pipefail

. /etc/os-release
if [[ "$ID" == fedora ]]; then
  native_nvim_ready() {
    /usr/bin/nvim --headless -u NONE '+lua if vim.fn.has("nvim-0.12") ~= 1 then vim.cmd("cquit 1") end' +qa
  }
  if ! native_nvim_ready; then sudo dnf upgrade -y neovim; fi
  if native_nvim_ready; then
    mkdir -p "$HOME/.local/bin"
    ln -sfn /usr/bin/nvim "$HOME/.local/bin/nvim"
    nvim --version
    exit 0
  fi
  printf 'The native Neovim version is too old. Install the stable upstream release.\n'
fi

case "$(uname -m)" in
  x86_64) archive_arch=x86_64 ;;
  aarch64) archive_arch=arm64 ;;
  *)
    printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
    exit 1
    ;;
esac

archive="nvim-linux-${archive_arch}.tar.gz"
install_dir="/opt/nvim-linux-${archive_arch}"
temp_dir="$(mktemp -d)"
extracted_root="$temp_dir/extracted"
trap 'rm -rf "$temp_dir"' EXIT

curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/${archive}" -o "$temp_dir/$archive"
mkdir "$extracted_root"
tar -xzf "$temp_dir/$archive" -C "$extracted_root"
nvim_bin="$(find "$extracted_root" -path '*/bin/nvim' -print -quit)"

if [[ -z "$nvim_bin" || ! -x "$nvim_bin" ]]; then
  printf 'Neovim binary is missing from %s.\n' "$archive" >&2
  exit 1
fi

extracted_dir="${nvim_bin%/bin/nvim}"
sudo rm -rf "$install_dir"
sudo mv "$extracted_dir" "$install_dir"
sudo chown -R root:root "$install_dir"
"$install_dir/bin/nvim" --version

mkdir -p "$HOME/.local/bin"
ln -sfn "$install_dir/bin/nvim" "$HOME/.local/bin/nvim"
nvim --version
