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
Write-Host ''

Write-Host "Current user profile directory: $env:USERPROFILE"
Write-Host ''

Write-Host 'Installing JetBrains Mono Nerd font...';
$fontUrl = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip'
$fontOutputFile = "$scriptDirectory\JetBrainsMono.zip"
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($fontUrl, $fontOutputFile)
    Write-Host "JetBrainsMono.zip downloaded successfully."
}
catch {
    Write-Host "Error downloading JetBrainsMono.zip: $($_.Exception.Message)"
}
Write-Host 'Unzipping JetBrainsMono.zip...'
$destinationFolder = "$scriptDirectory\JetBrainsMono"
Expand-Archive -Path $fontOutputFile -DestinationPath $destinationFolder -Force
Write-Host 'Installing fonts...'
$fontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)
$tempFontsFolder  = "C:\Windows\Temp\Fonts"
New-Item $tempFontsFolder -Type Directory -Force | Out-Null
Get-ChildItem -Path $destinationFolder -Include '*.ttf' -Recurse | ForEach {
    If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
        $font = "$tempFontsFolder\$($_.Name)"
        Copy-Item $($_.FullName) -Destination $tempFontsFolder
        $fontsFolder.CopyHere($font,0x10)
        Remove-Item $font -Force
    }
}
Write-Host 'Cleaning up...'
Remove-Item -Path $fontOutputFile -Force
Remove-Item -Path $destinationFolder -Recurse -Force
Write-Host ''

Write-Host 'Creating symbolic link for .wezterm.lua...';
if (Test-Path -Path $env:USERPROFILE\.wezterm.lua) {
    Write-Host "Symbolic link already exists: $env:USERPROFILE\.wezterm.lua"
} else {
    New-Item -Path $env:USERPROFILE\.wezterm.lua -ItemType SymbolicLink -Value "$scriptDirectory\.wezterm.lua"
}
Write-Host ''

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install powershell
choco install starship
choco install gh

Write-Host 'Creating symbolic link for Microsoft.PowerShell_profile.ps1...';
if (-not (Test-Path -Path $env:USERPROFILE\Documents\WindowsPowerShell)) {
    New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell -ItemType Directory -Force | Out-Null
}
if (Test-Path -Path $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1) {
    Write-Host "Symbolic link already exists: $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
} else {
    New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -ItemType SymbolicLink -Value "$scriptDirectory\Microsoft.PowerShell_profile.ps1"
}
Write-Host ''

Write-Host 'Creating symbolic link for starship.toml...';
if (Test-Path -Path $env:USERPROFILE\starship.toml) {
    Write-Host "Symbolic link already exists: $env:USERPROFILE\starship.toml"
} else {
    New-Item -Path $env:USERPROFILE\starship.toml -ItemType SymbolicLink -Value "$scriptDirectory\starship.toml"
}
Write-Host ''

Write-Host -NoNewLine 'Press any key to continue...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
