# Windows verification script

$ErrorActionPreference = "Stop"

# Set UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$failed = 0

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host "  Verifying Windows Setup" -ForegroundColor Blue
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host ""

# Check Caps Lock registry
Write-Host "Checking Caps Lock remap..." -ForegroundColor Blue
try
{
	Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -ErrorAction Stop | Out-Null
	Write-Host "✅ Caps Lock registry entry exists" -ForegroundColor Green
} catch
{
	Write-Host "❌ Caps Lock registry entry not found" -ForegroundColor Red
	$failed = 1
}

# Check fonts
Write-Host ""
Write-Host "Checking Nerd Fonts..." -ForegroundColor Blue

# Check for sample fonts in filesystem (matches what setup script checks)
$requiredFonts = @(
	"JetBrainsMonoNerdFont-Regular.ttf",
	"HackNerdFont-Regular.ttf"
)
$fontsFound = 0

foreach ($fontFile in $requiredFonts)
{
	$fontPath = "C:\Windows\Fonts\$fontFile"
	if (Test-Path $fontPath)
	{
		$fontFamily = $fontFile -replace 'NerdFont.*', ''
		Write-Host "✅ $fontFamily Nerd Font installed" -ForegroundColor Green
		$fontsFound++
	} else
	{
		$fontFamily = $fontFile -replace 'NerdFont.*', ''
		Write-Host "❌ $fontFamily Nerd Font not found" -ForegroundColor Red
	}
}

if ($fontsFound -eq 0)
{
	Write-Host "❌ No Nerd Fonts found" -ForegroundColor Red
	$failed = 1
} elseif ($fontsFound -lt $requiredFonts.Count)
{
	Write-Host "⚠️ Some fonts missing ($fontsFound/$($requiredFonts.Count))" -ForegroundColor Yellow
	$failed = 1
}

# Check Windows Terminal settings
Write-Host ""
Write-Host "Checking Windows Terminal..." -ForegroundColor Blue
$terminalPackage = Get-AppxPackage | Where-Object {$_.Name -match "WindowsTerminal"}

if ($null -eq $terminalPackage)
{
	Write-Host "⚠️ Windows Terminal not installed (skipping)" -ForegroundColor Yellow
} else
{
	$terminalFolder = "$env:LOCALAPPDATA\Packages\$($terminalPackage.PackageFamilyName)\LocalState"
	$targetFile = "$terminalFolder\settings.json"

	if (Test-Path -Path $targetFile)
	{
		$item = Get-Item -Path $targetFile
		if ($item.LinkType -eq "SymbolicLink")
		{
			Write-Host "✅ Windows Terminal settings symlinked" -ForegroundColor Green
		} else
		{
			Write-Host "❌ Windows Terminal settings exists but is not a symlink" -ForegroundColor Red
			$failed = 1
		}
	} else
	{
		Write-Host "❌ Windows Terminal settings not found" -ForegroundColor Red
		$failed = 1
	}
}

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host "  Verification Complete" -ForegroundColor Blue
Write-Host "================================================================================" -ForegroundColor Blue
Write-Host ""

if ($failed -eq 0)
{
	Write-Host "✅ All checks passed!" -ForegroundColor Green
	exit 0
} else
{
	Write-Host "❌ Some checks failed" -ForegroundColor Red
	exit 1
}
