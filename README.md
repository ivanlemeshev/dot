# Dotfiles

[![Lint](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml)
[![CodeQL](https://github.com/ivanlemeshev/dot/workflows/CodeQL/badge.svg)](https://github.com/ivanlemeshev/dot/security/code-scanning)

```text
          _       _    __ _ _
       __| | ___ | |_ / _(_) | ___  ___
      / _` |/ _ \| __| |_| | |/ _ \/ __|
     | (_| | (_) | |_|  _| | |  __/\__ \
    . \__,_|\___/ \__|_| |_|_|\___||___/

    > own your shell. shape your system.
```

This repository contains my personal dotfiles and bootstrap scripts. It includes configurations for Neovim, Zsh, and various tools.

<!-- prettier-ignore -->
> [!WARNING]
> Review code before running. Use at your own risk.

## Bootstrap

```bash
# Clone repo
git clone https://github.com/ivanlemeshev/dot ~/dotfiles
cd ~/dotfiles

# Optional: Configure personal settings
cp config.env.example config.env
vim config.env

# Run bootstrap
./bin/bootstrap
```

### Windows

1. Open PowerShell in the repository folder.
2. Optional: configure Git settings in `config.env`.

```powershell
Copy-Item config.env.example config.env
notepad config.env
```

3. Run the bootstrap. If PowerShell blocks it, use the second command.

```powershell
.\bin\bootstrap.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\bin\bootstrap.ps1
```

## Post-install

```bash
# GitHub CLI auth
gh auth login

# Neovim: Enable Copilot
nvim
:Copilot auth
```

## Terminal colors

Windows Terminal, Ghostty, Konsole, iTerm2, and the VS Code terminal use the same custom ANSI 16 palette.
Each terminal uses its native configuration format.
Terminal applications use ANSI color indices instead of fixed RGB colors.
Selection backgrounds use ANSI bright blue (12) with ANSI black (0) text.
Vim and Neovim show the current line number in bold yellow with no line background.
Native terminal selection settings use the same blue (`#81a2be`) where supported.
Use dark terminal themes with the current application mappings.
ANSI black (0) and the terminal background use `#1d1f21`.
Normal colors use indices 0–7.
Bright colors use indices 8–15.
ANSI bright white (15) supplies main text.
Borders, window separators, inactive line numbers, and secondary text use ANSI white (7), `#a7adb1`.
Comments, indentation guides, and hidden characters use ANSI bright black (8), `#5d666e`.
PowerShell uses ANSI colors for PSReadLine syntax and prediction lists.
Text roles use bright red, blue, and magenta.
Text roles use normal green, yellow, and cyan where the contrast passes 4.4:1.
The bat theme stores ANSI indices in its [native theme format](https://github.com/sharkdp/bat/blob/master/assets/themes/base16.tmTheme).
Check palette consistency in each terminal.

## Tools

Managed via [mise](https://mise.jdx.dev):

- Go
- golangci-lint
- Node
- Python
- Lua
- Zig

See `.config/mise/config.toml` for versions.
