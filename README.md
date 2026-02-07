# Dotfiles

```bash
   ____   ___ _____ _____ ___ _     _____ ____
  |  _ \ / _ \_   _|  ___|_ _| |   | ____/ ___|
  | | | | | | || | | |_   | || |   |  _| \___ \
 _| |_| | |_| || | |  _|  | || |___| |___ ___) |
(_)____/ \___/ |_| |_|   |___|_____|_____|____/
```

> [!WARNING] Review code before running. Use at your own risk.

## Setup

```bash
# Clone repo
git clone https://github.com/ivanlemeshev/dot ~/dotfiles
cd ~/dotfiles

# Optional: Configure personal settings
cp config.env.example config.env
vim config.env

# Run setup
./bin/setup
```

## Post-install

```bash
# GitHub CLI auth
gh auth login

# Neovim: Enable Copilot
nvim
:Copilot auth
```

## Tools

Managed via [mise](https://mise.jdx.dev):

- Go
- Node
- Python
- Lua
- golangci-lint

See `.config/mise/config.toml` for versions.
