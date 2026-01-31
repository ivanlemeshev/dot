# Run the following command in PowerShell as an Administrator to allow local
# scripts to run:
#
# Set-ExecutionPolicy RemoteSigned - allow local scripts to run\
#
# Run the following command in PowerShell as an Administrator to prevent local
# scripts from running after you have finished:
#
# Set-ExecutionPolicy Restricted - prevent local scripts from running

$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $scriptDirectory

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -WorkingDirectory $scriptDirectory
	exit
}

Write-Host "Current directory: $scriptDirectory"
Write-Host "Current user profile directory: $env:USERPROFILE"

Import-Module .\install\windows\capslock-as-ctrl.ps1
Import-Module .\install\windows\install-nerd-font.ps1

Write-Host "Creating symbolic link for Microsoft.PowerShell_profile.ps1...";
if (-not (Test-Path -Path $env:USERPROFILE\Documents\WindowsPowerShell))
{
	New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell -ItemType Directory -Force | Out-Null
}
if (Test-Path -Path $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1)
{
	Write-Host "Symbolic link already exists: $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
} else
{
	New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -ItemType SymbolicLink -Value "$scriptDirectory\Microsoft.PowerShell_profile.ps1"
}

Write-Host "Creating symbolic link for starship.toml..."
if (Test-Path -Path $env:USERPROFILE\starship.toml)
{
	Write-Host "Symbolic link already exists: $env:USERPROFILE\starship.toml"
} else
{
	New-Item -Path $env:USERPROFILE\starship.toml -ItemType SymbolicLink -Value "$scriptDirectory\starship.toml"
}

Write-Host "Creating symbolic link for Windows Terminal settings.json..."

$terminalPackage = Get-AppxPackage | Where-Object {$_.Name -match "WindowsTerminal"}

if ($null -eq $terminalPackage)
{
	Write-Warning "Windows Terminal (Stable) not found via Appx. Skipping..."
} else
{
	$terminalFolder = "$env:LOCALAPPDATA\Packages\$($terminalPackage.PackageFamilyName)\LocalState"
	$targetFile = "$terminalFolder\settings.json"
	$sourceFile = "$scriptDirectory\windows\terminal\settings.json"

	if (Test-Path -Path $targetFile)
	{
		Write-Host "Existing settings found. Removing to ensure fresh link..."
		Remove-Item -Path $targetFile -Force
	}

	if (!(Test-Path -Path $terminalFolder))
	{
		New-Item -Path $terminalFolder -ItemType Directory -Force
	}

	New-Item -Path $targetFile -ItemType SymbolicLink -Value $sourceFile
	Write-Host "Success: Symbolic link created for Windows Terminal."
}

Write-Host "The system will now restart to apply the changes."
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Restart-Computer
