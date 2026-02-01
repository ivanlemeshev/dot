# Windows Setup

## Prerequisites

1. Windows Terminal (install from Microsoft Store)
2. PowerShell 5.1 or later
3. Git for Windows (optional, but recommended)

## Installation

1. **Enable script execution** (run as Administrator):

   ```powershell
   Set-ExecutionPolicy RemoteSigned
   ```

2. **Run setup** (run as Administrator):

   ```powershell
   cd v2\windows
   .\setup.ps1
   ```

3. **Restart** your computer for Caps Lock remap to take effect

## What Gets Installed

1. ✅ **Caps Lock -> Ctrl** - Registry modification
2. ✅ **JetBrainsMono & Hack Nerd Fonts** - Required for terminal icons
3. ✅ **Windows Terminal settings** - Symlinked configuration

## For Development

Use **WSL2** (Windows Subsystem for Linux) and run the Ubuntu setup:

```bash
# Inside WSL2
cd v2
./setup
```

This gives you the full dev environment (fish, fzf, etc.) in WSL.
