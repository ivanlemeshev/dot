# Quick Start Guide

## Prerequisites

- Ubuntu 24.04 LTS
- Internet connection
- sudo access

## Installation

```bash
# Clone the repository
git clone https://github.com/ivanlemeshev/dot.git ~/dot
cd ~/dot/v2

# Run setup
./setup
```

The setup will:
1. Update package repositories
2. Install all core tools (fish, neovim, tmux, starship, git, bat, vim)
3. Prompt you for optional tools (go, rust, python, node, zig, lazygit, bottom)
4. Create symlinks for all configuration files
5. Configure git with your name and email

## Post-Installation

### Restart Shell

```bash
exec fish -l
```

### Install Tmux Plugins

Inside tmux, press:
```
Ctrl+Space I
```

### Configure GitHub CLI

```bash
gh auth login
```

### Configure GitHub Copilot (in nvim)

```vim
:Copilot auth
```

## Testing with Docker

```bash
cd ~/dot/v2
./docker-test.sh
```

## File Structure

```
~/.config/fish/config.fish    -> ~/dot/v2/tools/core/fish/config.fish
~/.config/nvim/               -> ~/dot/v2/tools/core/neovim/nvim/
~/.config/starship.toml       -> ~/dot/v2/tools/core/starship/starship.toml
~/.tmux.conf                  -> ~/dot/v2/tools/core/tmux/.tmux.conf
~/.vimrc                      -> ~/dot/v2/tools/core/vim/.vimrc
~/.config/lazygit/config.yml  -> ~/dot/v2/tools/optional/lazygit/config/config.yml
```

## Customization

All configs are in `~/dot/v2/tools/*/`. Edit them there, and the symlinks will reflect changes immediately.

## Troubleshooting

### Shell not changed to fish

```bash
sudo chsh -s $(which fish) $(whoami)
```

Then logout and login again.

### Tmux plugins not working

Make sure TPM is installed:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then press `Ctrl+Space I` inside tmux.

### Neovim plugins not installing

Open nvim and wait. Lazy.nvim will install plugins automatically on first launch.
