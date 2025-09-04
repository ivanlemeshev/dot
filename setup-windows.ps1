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

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -WorkingDirectory $scriptDirectory
    exit
}

Write-Host "Current directory: $scriptDirectory"
Write-Host "Current user profile directory: $env:USERPROFILE"

Import-Module .\install\windows\capslock-as-ctrl.ps1
Import-Module .\install\windows\install-nerd-font.ps1
Import-Module .\install\windows\install-choco-packages.ps1

Write-Host "Creating symbolic link for .wezterm.lua...";
if (Test-Path -Path $env:USERPROFILE\.wezterm.lua) {
    Write-Host "Symbolic link already exists: $env:USERPROFILE\.wezterm.lua"
}
else {
    New-Item -Path $env:USERPROFILE\.wezterm.lua -ItemType SymbolicLink -Value "$scriptDirectory\.wezterm.lua"
}

Write-Host "Creating symbolic link for rio\config.toml...";
if (!((Get-Item -Path "$env:USERPROFILE\AppData\Local\rio\config.toml").Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
    Remove-Item -Path "$env:USERPROFILE\AppData\Local\rio\config.toml"
}

if (Test-Path -Path "$env:USERPROFILE\AppData\Local\rio\config.toml") {
    Write-Host "Symbolic link already exists: $env:USERPROFILE\AppData\Local\rio\config.toml"
}
else {
    New-Item -Path $env:USERPROFILE\AppData\Local\rio\config.toml -ItemType SymbolicLink -Value "$scriptDirectory\rio\config.toml"
}

Write-Host "Install catppuccin theme for rio...";
Remove-Item -Path "$env:USERPROFILE\AppData\Local\rio\themes" -Recurse -Force
git clone https://github.com/catppuccin/rio.git "$scriptDirectory\rio\catppuccin"
Copy-Item -Path "$scriptDirectory\rio\catppuccin\themes\" -Destination "$env:USERPROFILE\AppData\Local\rio\" -Recurse
Remove-Item -Path "$scriptDirectory\rio\catppuccin" -Recurse -Force

Write-Host "Creating symbolic link for Microsoft.PowerShell_profile.ps1...";
if (-not (Test-Path -Path $env:USERPROFILE\Documents\WindowsPowerShell)) {
    New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell -ItemType Directory -Force | Out-Null
}
if (Test-Path -Path $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1) {
    Write-Host "Symbolic link already exists: $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
}
else {
    New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -ItemType SymbolicLink -Value "$scriptDirectory\Microsoft.PowerShell_profile.ps1"
}

Write-Host "Creating symbolic link for starship.toml...";
if (Test-Path -Path $env:USERPROFILE\starship.toml) {
    Write-Host "Symbolic link already exists: $env:USERPROFILE\starship.toml"
}
else {
    New-Item -Path $env:USERPROFILE\starship.toml -ItemType SymbolicLink -Value "$scriptDirectory\starship.toml"
}

Write-Host "The system will now restart to apply the changes."
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Restart-Computer
