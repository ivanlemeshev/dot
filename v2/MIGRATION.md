# Migration Guide

## Overview

This guide explains how to migrate from the current dotfiles setup to the new v2
system.

**Important**: The v2 system is built in a separate directory and does not
modify your existing setup. Both can coexist safely.

## Current Setup (v1)

The current setup uses OS-specific scripts:

- `setup-ubuntu.sh` - Ubuntu setup
- `setup-macos.sh` - macOS setup
- `setup-windows.ps1` - Windows setup

Config files are at the repository root:

- `.vimrc`, `.tmux.conf`, `config.fish`, `starship.toml`, etc.

## New Setup (v2)

The v2 system uses:

- Single `v2/setup` entry point (Ubuntu 24.04 only for now)
- Modular tool-based structure
- Configs organized by tool in `v2/tools/`
- Docker-based testing

## Migration Path

### Option 1: Test v2 Without Affecting Current Setup

This is the recommended approach.

1. **Clone or update your dotfiles repository:**

   ```bash
   cd ~/dot
   git pull
   ```

2. **Test v2 in Docker:**

   ```bash
   cd v2
   ./docker-test.sh
   ```

3. **Try v2 on a test VM or spare machine:**

   ```bash
   cd v2
   ./setup
   ```

4. **When satisfied, use v2 on your main machine:**
   ```bash
   cd v2
   ./setup
   ```

Your existing setup remains untouched in the parent directory.

### Option 2: Side-by-Side Comparison

Keep both setups and compare:

1. **Current setup configs:** `~/dot/.tmux.conf`, `~/dot/config.fish`, etc.
2. **v2 configs:** `~/dot/v2/tools/core/tmux/.tmux.conf`,
   `~/dot/v2/tools/core/fish/config.fish`, etc.

You can manually diff configs to see what changed.

### Option 3: Clean Install

Start fresh with v2:

1. **Backup your current home directory configs:**

   ```bash
   mkdir ~/dotfiles-backup
   cp ~/.vimrc ~/dotfiles-backup/
   cp ~/.tmux.conf ~/dotfiles-backup/
   cp -r ~/.config/fish ~/dotfiles-backup/
   cp -r ~/.config/nvim ~/dotfiles-backup/
   # etc.
   ```

2. **Remove existing symlinks (if any):**

   ```bash
   rm ~/.vimrc ~/.tmux.conf
   rm -rf ~/.config/fish ~/.config/nvim
   # etc.
   ```

3. **Run v2 setup:**
   ```bash
   cd ~/dot/v2
   ./setup
   ```

## Key Differences

### Directory Structure

| Current (v1)              | New (v2)                       |
| ------------------------- | ------------------------------ |
| `config.fish`             | `tools/core/fish/config.fish`  |
| `.tmux.conf`              | `tools/core/tmux/.tmux.conf`   |
| `.vimrc`                  | `tools/core/vim/.vimrc`        |
| `starship.toml`           | `tools/core/starship/st*.toml` |
| `nvim/`                   | `tools/core/neovim/nvim/`      |
| `lazygit/`                | `tools/optional/lazygit/`      |
| `install/ubuntu/*.sh`     | `tools/core/*/tool.sh`         |
| `setup-ubuntu.sh`         | `setup` (single entry point)   |
| `scripts/functions/*.sh`  | `lib/*.sh`                     |
| Multiple OS setup scripts | One `setup`, OS detection      |
| 33 Ubuntu install scripts | 6-7 core tool modules          |
| Manual execution order    | Automatic tool discovery       |
| No testing infrastructure | Docker + GitHub Actions        |

### Setup Command

| Current (v1)       | New (v2)  |
| ------------------ | --------- |
| `./setup-ubuntu.sh | `./setup` |

### Adding New Tools

**Current (v1):**

1. Create `install/ubuntu/install-newtool.sh`
2. Add line to `setup-ubuntu.sh`
3. Make executable
4. Manually maintain execution order

**New (v2):**

1. Create `tools/optional/newtool/tool.sh`
2. Done! (Auto-discovered)

### Configuration Files

**Current (v1):**

- All at repository root
- Scattered across directories
- Hard to find which config belongs to which tool

**New (v2):**

- Organized by tool
- `tools/core/fish/config.fish` - clearly belongs to fish
- Self-contained (tool + config together)

## What Stays the Same

- Configuration file contents (mostly unchanged)
- Tool versions and packages
- Post-install steps (tmux plugins, nvim plugins, etc.)
- GitHub authentication, shell customization

## Rollback

If you want to go back to the old setup:

1. **Remove v2 symlinks:**

   ```bash
   rm ~/.vimrc ~/.tmux.conf
   rm -rf ~/.config/fish ~/.config/nvim
   # etc.
   ```

2. **Run old setup:**
   ```bash
   cd ~/dot
   ./setup-ubuntu.sh
   ```

## FAQ

**Q: Will v2 break my current setup?** A: No. v2 is in a separate `v2/`
directory and doesn't touch the current setup.

**Q: Can I use both v1 and v2 at the same time?** A: Not simultaneously on the
same machine (configs would conflict), but you can switch between them.

**Q: Do I need to reconfigure everything?** A: No. The configs are copied from
v1, so your customizations are preserved.

**Q: What if I have custom modifications to configs?** A: Copy your
modifications to the v2 config files in `tools/*/`. The setup will create
symlinks from there.

**Q: Is v2 stable?** A: Currently in development. Test in Docker first, then on
a non-critical machine.

**Q: When should I migrate?** A: Wait until Phase 5 is complete and v2 is marked
as production-ready.

**Q: What about macOS and Windows?** A: Currently v2 only supports Ubuntu 24.04.
macOS and Windows support coming in future phases.

## Support

For issues or questions:

- Check [IMPLEMENTATION.md](IMPLEMENTATION.md) for current progress
- Check [ARCHITECTURE.md](ARCHITECTURE.md) for design details
- File an issue in the repository
