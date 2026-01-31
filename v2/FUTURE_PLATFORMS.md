# Future Platform Support: macOS and Windows

This document contains detailed implementation plans for adding macOS and Windows
support to the v2 dotfiles system.

## Current State (Ubuntu 24.04 Only)

The current implementation is Ubuntu-only:

- **lib/os.sh**: Only detects Ubuntu 24.04
- **lib/package.sh**: Only uses apt-get
- **lib/setup-ubuntu.sh**: Ubuntu-specific orchestrator
- **setup**: Routes only to Ubuntu setup
- **Dockerfile**: Ubuntu 24.04 only
- **GitHub Actions**: test-ubuntu.yml only

## Phase 6: macOS Support

### 6.1 Update Core Libraries

#### lib/os.sh

Add macOS detection:

```bash
case "$os_name" in
  Darwin*)
    # Check macOS version
    local macos_version
    macos_version="$(sw_vers -productVersion)"
    export OS_TYPE="macos"
    export OS_VERSION="$macos_version"
    return 0
    ;;
  # ... existing Linux/Ubuntu code ...
esac
```

#### lib/package.sh

Add Homebrew support:

```bash
function pkg_install() {
  case "$OS_TYPE" in
    macos)
      print_info "Installing: $package"
      brew install "$package"
      ;;
    ubuntu)
      # ... existing apt-get code ...
      ;;
  esac
}

function pkg_update() {
  case "$OS_TYPE" in
    macos)
      print_info "Updating Homebrew..."
      brew update
      ;;
    ubuntu)
      # ... existing apt-get code ...
      ;;
  esac
}
```

#### New: lib/setup-macos.sh

Create macOS orchestrator (similar to setup-ubuntu.sh):

```bash
#!/usr/bin/env bash
# Main setup orchestrator for macOS

set -e

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_ROOT

print_header "Setting up dotfiles for macOS"

# Install Homebrew if not present
if ! command -v brew > /dev/null 2>&1; then
  print_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update package repositories
pkg_update

# Install core tools (same as Ubuntu)
install_core_tools

# Install optional tools (same as Ubuntu)
install_optional_tools

print_header "Setup Complete!"
# ... rest same as Ubuntu ...
```

#### Update setup entry point

```bash
case "$OS_TYPE" in
  macos)
    source "${DOTFILES_ROOT}/lib/setup-macos.sh"
    ;;
  ubuntu)
    source "${DOTFILES_ROOT}/lib/setup-ubuntu.sh"
    ;;
esac
```

### 6.2 Update Tool Modules

Most tools will work as-is, but some need macOS-specific adjustments:

#### tools/core/fish/tool.sh

```bash
function pre_install() {
  if [[ "$OS_TYPE" == "ubuntu" ]]; then
    # ... existing PPA code ...
  elif [[ "$OS_TYPE" == "macos" ]]; then
    # Homebrew handles this, no PPA needed
    return
  fi
}

declare -A PACKAGES=(
  [ubuntu]="fish"
  [macos]="fish"
)
```

#### tools/core/neovim/tool.sh

```bash
function install_package() {
  if [[ "$OS_TYPE" == "macos" ]]; then
    pkg_install "neovim"
    return
  fi

  # ... existing Ubuntu manual install code ...
}
```

#### tools/core/starship/tool.sh

```bash
function install_package() {
  if [[ "$OS_TYPE" == "macos" ]]; then
    pkg_install "starship"
    return
  fi

  # ... existing Ubuntu manual install code ...
}
```

#### tools/optional/go/tool.sh

```bash
GO_VERSION="1.24.2"

function install_package() {
  if [[ "$OS_TYPE" == "macos" ]]; then
    pkg_install "go"
    return
  fi

  # ... existing Ubuntu manual install code ...
}
```

### 6.3 Add macOS-Specific Tools

#### tools/platform/macos/iterm2/tool.sh

```bash
#!/usr/bin/env bash
# iTerm2 installation and configuration

set -e

TOOL_NAME="iterm2"
TOOL_DESCRIPTION="macOS terminal emulator"
TOOL_CATEGORY="platform"

function install_package() {
  if ! [ -d "/Applications/iTerm.app" ]; then
    print_info "Installing iTerm2..."
    brew install --cask iterm2
  else
    print_info "iTerm2 already installed"
  fi
}

function link_configs() {
  local tool_dir
  tool_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Set iTerm2 to use custom preferences folder
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${tool_dir}/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

  print_success "iTerm2 configured to use: ${tool_dir}/iterm2"
}

function main() {
  install_package
  link_configs
}
```

Copy existing config:

```bash
cp -r ../macos/iterm2/ v2/tools/platform/macos/iterm2/iterm2/
```

#### tools/platform/macos/homebrew/tool.sh

```bash
#!/usr/bin/env bash
# Homebrew installation (prerequisite for macOS)

set -e

TOOL_NAME="homebrew"
TOOL_DESCRIPTION="macOS package manager"
TOOL_CATEGORY="platform"

function install_package() {
  if command -v brew > /dev/null 2>&1; then
    print_info "Homebrew already installed"
    return
  fi

  print_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function main() {
  install_package
}
```

### 6.4 Update config.fish

The fish config already has macOS conditionals:

```fish
if test "$os" = Darwin
    eval "$(/opt/homebrew/bin/brew shellenv)"
end
```

This should work as-is!

### 6.5 Testing Infrastructure

#### Update Dockerfile

Can't easily test macOS in Docker. Instead, use GitHub Actions:

#### .github/workflows/test-macos.yml

```yaml
name: Test macOS Setup

on:
  push:
    paths:
      - "v2/**"
  pull_request:
    paths:
      - "v2/**"
  workflow_dispatch:

jobs:
  test-macos:
    name: Test on macOS
    runs-on: macos-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run setup
        working-directory: v2
        run: ./setup

      - name: Verify installations
        run: |
          fish --version
          nvim --version
          tmux -V
          starship --version
          git --version
          bat --version

      - name: Verify symlinks
        run: |
          test -L ~/.config/fish/config.fish
          test -L ~/.config/nvim
          test -L ~/.tmux.conf
          test -L ~/.config/starship.toml
          test -L ~/.vimrc
```

### 6.6 Documentation Updates

Update README.md:

```markdown
## Requirements

- **Ubuntu 24.04 LTS** or **macOS Ventura/Sonoma**
- Internet connection
- sudo access (Ubuntu) or admin access (macOS)
```

## Phase 7: Windows Support

### 7.1 Windows Architecture Challenges

Windows is fundamentally different:

- **No bash**: Use PowerShell instead
- **No symbolic links** (without admin): Use junctions or hard links
- **Different paths**: `%USERPROFILE%` instead of `$HOME`
- **Different package manager**: None built-in (could use winget or chocolatey)
- **Different line endings**: CRLF vs LF

### 7.2 Implementation Strategy

**Option A: PowerShell-only** (Recommended)

Create parallel PowerShell implementation:

```
v2/
├── setup           # Bash for Unix
├── setup.ps1       # PowerShell for Windows
├── lib/
│   ├── *.sh        # Bash libraries
│   └── *.ps1       # PowerShell libraries
└── tools/
    ├── core/
    │   └── */
    │       ├── tool.sh   # Bash version
    │       └── tool.ps1  # PowerShell version
```

**Option B: WSL-focused** (Alternative)

Target WSL (Windows Subsystem for Linux) instead of native Windows:

- Treat WSL as Ubuntu
- Use existing Ubuntu scripts
- Only add Windows Terminal config

### 7.3 PowerShell Implementation (Option A)

#### setup.ps1

```powershell
# Unified dotfiles installer for Windows
# Requires Windows 10/11 with PowerShell 7+

param(
    [switch]$NonInteractive = $false
)

$ErrorActionPreference = "Stop"
$DotfilesRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Check for admin privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Relaunching as Administrator..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -WorkingDirectory $DotfilesRoot
    exit
}

# Load library functions
. "$DotfilesRoot\lib\os.ps1"
. "$DotfilesRoot\lib\ui.ps1"
. "$DotfilesRoot\lib\package.ps1"
. "$DotfilesRoot\lib\symlink.ps1"

# Detect OS
Detect-OS

# Run Windows setup
. "$DotfilesRoot\lib\setup-windows.ps1"
```

#### lib/os.ps1

```powershell
function Detect-OS {
    $os = [System.Environment]::OSVersion
    $version = $os.Version

    if ($os.Platform -eq "Win32NT") {
        $global:OS_TYPE = "windows"
        $global:OS_VERSION = "$($version.Major).$($version.Minor)"
        Write-Host "Detected OS: Windows $($global:OS_VERSION)"
    } else {
        Write-Error "Unsupported OS: $($os.Platform)"
        exit 1
    }
}
```

#### lib/package.ps1

```powershell
function Install-Package {
    param([string]$PackageName)

    # Try winget first (Windows 11 / Windows 10 with App Installer)
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "[INFO] Installing: $PackageName via winget"
        winget install --id $PackageName --silent --accept-package-agreements
    } else {
        Write-Warning "winget not available. Please install manually: $PackageName"
    }
}
```

#### lib/symlink.ps1

```powershell
function New-Symlink {
    param(
        [string]$Source,
        [string]$Target
    )

    if (!(Test-Path $Source)) {
        Write-Error "Source does not exist: $Source"
        return
    }

    # Backup existing file
    if ((Test-Path $Target) -and !(Get-Item $Target).Attributes -match "ReparsePoint") {
        $backup = "$Target.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Write-Host "[INFO] Backing up: $Target -> $backup"
        Move-Item $Target $backup
    }

    # Remove existing symlink
    if ((Test-Path $Target) -and (Get-Item $Target).Attributes -match "ReparsePoint") {
        Remove-Item $Target -Force
    }

    # Create directory if needed
    $targetDir = Split-Path $Target
    if (!(Test-Path $targetDir)) {
        New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
    }

    # Create symlink
    Write-Host "[INFO] Linking: $Source -> $Target"
    New-Item -Path $Target -ItemType SymbolicLink -Value $Source -Force | Out-Null
}
```

#### lib/setup-windows.ps1

```powershell
# Main setup orchestrator for Windows

Write-Header "Setting up dotfiles for Windows"

# Install core tools
function Install-CoreTools {
    $toolsDir = Join-Path $DotfilesRoot "tools\core"

    foreach ($toolDir in Get-ChildItem $toolsDir -Directory) {
        $toolScript = Join-Path $toolDir.FullName "tool.ps1"

        if (Test-Path $toolScript) {
            Write-Header "Installing: $($toolDir.Name)"
            & $toolScript
        }
    }
}

Install-CoreTools

Write-Header "Setup Complete!"
Write-Host "Please restart your terminal to apply changes."
```

### 7.4 Windows-Specific Tool Modules

#### tools/core/fish/tool.ps1

Fish doesn't run natively on Windows. Options:

1. Skip fish on Windows, use PowerShell instead
2. Install fish via WSL

Recommended: Skip fish on Windows.

```powershell
# Fish is not available on native Windows
Write-Host "[INFO] Fish shell is not available on native Windows"
Write-Host "[INFO] Consider using WSL or PowerShell"
```

#### tools/platform/windows/terminal/tool.ps1

```powershell
# Windows Terminal configuration

$terminalPackage = Get-AppxPackage | Where-Object {$_.Name -match "WindowsTerminal"}

if ($null -eq $terminalPackage) {
    Write-Warning "Windows Terminal not found. Installing via winget..."
    winget install --id Microsoft.WindowsTerminal --silent
}

$terminalFolder = "$env:LOCALAPPDATA\Packages\$($terminalPackage.PackageFamilyName)\LocalState"
$targetFile = "$terminalFolder\settings.json"
$sourceFile = Join-Path (Split-Path $PSScriptRoot) "terminal\settings.json"

New-Symlink -Source $sourceFile -Target $targetFile

Write-Host "[SUCCESS] Windows Terminal configured"
```

Copy existing config:

```powershell
cp ..\windows\terminal\settings.json v2\tools\platform\windows\terminal\settings.json
```

#### tools/platform/windows/capslock-ctrl/tool.ps1

```powershell
# Remap Caps Lock to Ctrl via registry

$registryPath = "HKLM:\System\CurrentControlSet\Control\Keyboard Layout"
$registryName = "Scancode Map"

# Binary value that maps Caps Lock (0x3A) to Left Ctrl (0x1D)
$scancodeMap = [byte[]](
    0x00, 0x00, 0x00, 0x00,  # Header
    0x00, 0x00, 0x00, 0x00,  # Header
    0x02, 0x00, 0x00, 0x00,  # 2 mappings
    0x1D, 0x00, 0x3A, 0x00,  # Map Caps Lock to Ctrl
    0x00, 0x00, 0x00, 0x00   # Null terminator
)

Write-Host "[INFO] Remapping Caps Lock to Ctrl..."
Set-ItemProperty -Path $registryPath -Name $registryName -Value $scancodeMap -Type Binary

Write-Host "[SUCCESS] Caps Lock remapped to Ctrl"
Write-Host "[WARNING] System restart required for changes to take effect"
```

#### tools/platform/windows/powershell/tool.ps1

```powershell
# PowerShell profile configuration

$profileDir = Split-Path $PROFILE
$sourceFile = Join-Path (Split-Path $PSScriptRoot) "powershell\Microsoft.PowerShell_profile.ps1"

if (!(Test-Path $profileDir)) {
    New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
}

New-Symlink -Source $sourceFile -Target $PROFILE

Write-Host "[SUCCESS] PowerShell profile configured"
```

Copy existing config:

```powershell
cp ..\Microsoft.PowerShell_profile.ps1 v2\tools\platform\windows\powershell\Microsoft.PowerShell_profile.ps1
```

### 7.5 Windows Testing

Can't use Docker for Windows. Use GitHub Actions instead:

#### .github/workflows/test-windows.yml

```yaml
name: Test Windows Setup

on:
  push:
    paths:
      - "v2/**"
  pull_request:
    paths:
      - "v2/**"
  workflow_dispatch:

jobs:
  test-windows:
    name: Test on Windows
    runs-on: windows-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run setup
        working-directory: v2
        shell: pwsh
        run: |
          Set-ExecutionPolicy Bypass -Scope Process -Force
          .\setup.ps1

      - name: Verify PowerShell profile
        shell: pwsh
        run: |
          Test-Path $PROFILE

      - name: Verify Windows Terminal config
        shell: pwsh
        run: |
          $terminalPackage = Get-AppxPackage | Where-Object {$_.Name -match "WindowsTerminal"}
          $settingsPath = "$env:LOCALAPPDATA\Packages\$($terminalPackage.PackageFamilyName)\LocalState\settings.json"
          Test-Path $settingsPath
```

## Implementation Checklist

### Phase 6: macOS (Estimated 2-3 days)

- [ ] Update lib/os.sh for macOS detection
- [ ] Update lib/package.sh with Homebrew support
- [ ] Create lib/setup-macos.sh
- [ ] Update setup entry point for macOS routing
- [ ] Update all tool modules with macOS package names
- [ ] Create tools/platform/macos/iterm2/
- [ ] Create tools/platform/macos/homebrew/
- [ ] Copy macos/iterm2 configs to v2
- [ ] Create .github/workflows/test-macos.yml
- [ ] Test on real macOS machine
- [ ] Update all documentation

### Phase 7: Windows (Estimated 3-5 days)

- [ ] Create setup.ps1 entry point
- [ ] Create lib/*.ps1 libraries (os, package, symlink, ui)
- [ ] Create lib/setup-windows.ps1
- [ ] Create tools/*/tool.ps1 for all tools
- [ ] Create tools/platform/windows/terminal/
- [ ] Create tools/platform/windows/capslock-ctrl/
- [ ] Create tools/platform/windows/powershell/
- [ ] Copy windows/ configs to v2
- [ ] Create .github/workflows/test-windows.yml
- [ ] Test on real Windows machine
- [ ] Update all documentation

## Key Design Decisions

### Why Not One Language for All Platforms?

**Considered:**

- Python (cross-platform but adds dependency)
- Go (requires compilation, adds complexity)
- Node.js (requires Node.js installed first)

**Chosen:**

- Bash for Unix (native, no dependencies)
- PowerShell for Windows (native on Windows 10+)

**Rationale:** Use native tools, no external dependencies.

### Why Not WSL for Windows?

WSL is an option but:

- Not all Windows users have WSL
- Native Windows support more broadly applicable
- Can still support WSL by detecting it as Linux

## Migration Path

When adding new platforms:

1. **Keep Ubuntu working** - Don't break existing functionality
2. **Test each platform independently** - Separate CI/CD workflows
3. **Gradual rollout** - One platform at a time
4. **Document differences** - Clear docs for each platform

## References

**From current implementation:**

- Ubuntu install scripts: `../install/ubuntu/*.sh`
- macOS install scripts: `../install/macos/*.sh`
- Windows install scripts: `../install/windows/*.ps1`
- macOS configs: `../macos/iterm2/`
- Windows configs: `../windows/terminal/`
- PowerShell profile: `../Microsoft.PowerShell_profile.ps1`

**Keep these for reference during implementation!**
