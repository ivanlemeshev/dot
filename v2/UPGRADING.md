# Upgrading Tools

This document explains how to upgrade or reinstall tools in your dotfiles.

## Idempotency

The setup scripts are idempotent - running them multiple times is safe and will skip already-installed tools.

## Upgrading Tools

### 1. Package Manager Tools (fish, fzf)

**Ubuntu:**
```bash
sudo apt update
sudo apt upgrade fish fzf
```

**macOS:**
```bash
brew upgrade fish fzf
```

Or upgrade all packages:
```bash
brew upgrade
```

### 2. GitHub Release Tools (vivid)

**Automatic version checking:**

When you update the version in the tool script (e.g., `VIVID_VERSION="0.11.0"`), the setup will automatically detect the version mismatch and upgrade:

```bash
./v2/setup
# Output: Upgrading vivid from v0.10.1 to v0.11.0...
```

**Manual upgrade:**
1. Edit `v2/tools/core/vivid/tool.sh`
2. Update `VIVID_VERSION="x.x.x"`
3. Run `./v2/setup`

### 3. Force Reinstall

To force reinstall any tool (bypass idempotency checks):

```bash
FORCE=1 ./v2/setup
```

This will:
- Reinstall all packages even if already present
- Reinstall all fish plugins
- Redownload and reinstall GitHub release tools

**Use cases for FORCE:**
- Fix corrupted installations
- Force downgrade to a specific version
- Reset to clean state
- Troubleshoot installation issues

## Examples

### Upgrade vivid only

```bash
# 1. Update version in the tool script
sed -i 's/VIVID_VERSION="0.10.1"/VIVID_VERSION="0.11.0"/' v2/tools/core/vivid/tool.sh

# 2. Run setup (it will detect version mismatch)
./v2/setup
```

### Force reinstall everything

```bash
FORCE=1 ./v2/setup
```

### Upgrade system packages

**Ubuntu:**
```bash
sudo apt update && sudo apt upgrade -y
```

**macOS:**
```bash
brew update && brew upgrade
```

## How It Works

### Package Manager Tools

- **First run:** Installs the package
- **Subsequent runs:** Skips installation (shows "already installed, skipping")
- **With FORCE=1:** Reinstalls via package manager

### GitHub Release Tools (vivid)

- **First run:** Downloads and installs
- **Subsequent runs:**
  - Checks installed version vs `VIVID_VERSION` in script
  - If versions match: skips
  - If versions differ: upgrades automatically
- **With FORCE=1:** Downloads and installs regardless of version

### Fish Plugins

- **First run:** Installs via fisher
- **Subsequent runs:** Checks if plugin exists, skips if present
- **With FORCE=1:** Reinstalls plugins

## Troubleshooting

### "Tool not working after upgrade"

```bash
# Force clean reinstall
FORCE=1 ./v2/setup
```

### "Package manager has newer version"

```bash
# Ubuntu
sudo apt update
sudo apt upgrade <package-name>

# macOS
brew upgrade <package-name>
```

### "Want to downgrade vivid"

```bash
# 1. Edit version in tool script
vim v2/tools/core/vivid/tool.sh
# Change VIVID_VERSION to older version

# 2. Force reinstall
FORCE=1 ./v2/setup
```
