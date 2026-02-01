# Windows dotfiles setup
# Run as Administrator: Set-ExecutionPolicy RemoteSigned

$ErrorActionPreference = "Stop"

# Set UTF-8 encoding for emoji support
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Get script directory
$DOTFILES_ROOT = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $DOTFILES_ROOT

# Check for Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
	Write-Host "❌ This script requires Administrator privileges" -ForegroundColor Red
	Write-Host "💡 Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Cyan
	exit 1
}

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host "  Dotfiles Setup for Windows" -ForegroundColor Blue
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host ""
Write-Host "Dotfiles directory: $DOTFILES_ROOT"
Write-Host ""

# Detect CI environment
$isCI = $env:CI -eq "true" -or $env:GITHUB_ACTIONS -eq "true"
$needsRestart = $false

# Remap Caps Lock to Ctrl
Write-Host "📦 Remapping Caps Lock to Left Ctrl..." -ForegroundColor Blue

$registryPath = "HKLM:\System\CurrentControlSet\Control\Keyboard Layout"
$propertyName = "Scancode Map"
$propertyValue = 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x1d, 0x00, 0x3a, 0x00, 0x00, 0x00, 0x00, 0x00

try
{
	Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction Stop | Out-Null
	Write-Host "💡 Caps Lock already remapped" -ForegroundColor Blue
} catch
{
	Write-Host "💡 Creating registry entry..." -ForegroundColor Blue
	New-ItemProperty -Path $registryPath -Name $propertyName -PropertyType Binary -Value $propertyValue | Out-Null
	Write-Host "✅ Caps Lock remapped to Ctrl (requires restart)" -ForegroundColor Green
	$needsRestart = $true
}

# 2. Install Nerd Font
Write-Host ""
Write-Host "📦 Installing Nerd Font..." -ForegroundColor Blue

$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"
$fontZip = "$env:TEMP\FiraCode.zip"
$fontDir = "$env:TEMP\FiraCode"

Write-Host "💡 Downloading FiraCode Nerd Font..." -ForegroundColor Blue
Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip

Write-Host "💡 Extracting fonts..." -ForegroundColor Blue
Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force

Write-Host "💡 Installing fonts..." -ForegroundColor Blue
$fonts = Get-ChildItem -Path $fontDir -Filter "*.ttf"
$shellApp = New-Object -ComObject Shell.Application
$fontsFolder = $shellApp.Namespace(0x14)

foreach ($font in $fonts)
{
	Write-Host "  Installing: $($font.Name)" -ForegroundColor Gray
	$fontsFolder.CopyHere($font.FullName, 0x10)
}

Remove-Item -Path $fontZip -Force
Remove-Item -Path $fontDir -Recurse -Force

Write-Host "✅ Nerd Font installed" -ForegroundColor Green

# 3. Symlink Windows Terminal settings
Write-Host ""
Write-Host "📦 Configuring Windows Terminal..." -ForegroundColor Blue

$terminalPackage = Get-AppxPackage | Where-Object {$_.Name -match "WindowsTerminal"}

if ($null -eq $terminalPackage)
{
	Write-Host "⚠️ Windows Terminal not found. Skipping..." -ForegroundColor Yellow
} else
{
	$terminalFolder = "$env:LOCALAPPDATA\Packages\$($terminalPackage.PackageFamilyName)\LocalState"
	$targetFile = "$terminalFolder\settings.json"
	$sourceFile = "$DOTFILES_ROOT\windows\terminal\settings.json"

	if (!(Test-Path -Path $sourceFile))
	{
		Write-Host "⚠️ Terminal settings file not found: $sourceFile" -ForegroundColor Yellow
	} else
	{
		if (Test-Path -Path $targetFile)
		{
			Write-Host "💡 Removing existing settings..." -ForegroundColor Blue
			Remove-Item -Path $targetFile -Force
		}

		if (!(Test-Path -Path $terminalFolder))
		{
			New-Item -Path $terminalFolder -ItemType Directory -Force | Out-Null
		}

		New-Item -Path $targetFile -ItemType SymbolicLink -Value $sourceFile | Out-Null
		Write-Host "✅ Windows Terminal settings linked" -ForegroundColor Green
	}
}

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host "  Setup Complete!" -ForegroundColor Blue
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host ""

if ($needsRestart -and -not $isCI)
{
	Write-Host "⚠️ System restart required for Caps Lock remap to take effect" -ForegroundColor Yellow
	Write-Host ""
	Write-Host -NoNewLine "Press any key to restart now (Ctrl+C to cancel)..."
	$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	Restart-Computer
} elseif ($needsRestart -and $isCI)
{
	Write-Host "⚠️ Restart required for Caps Lock (skipped in CI)" -ForegroundColor Yellow
} else
{
	Write-Host "✅ No restart needed - all changes applied!" -ForegroundColor Green
}
