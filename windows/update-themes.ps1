$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'helpers.ps1')
. (Join-Path $PSScriptRoot 'terminal.ps1')
Assert-Windows

$terminal = Get-WindowsTerminalSettingsDirectory
if ($null -eq $terminal) {
    throw 'Windows Terminal settings directory is unavailable.'
}
Set-WindowsTerminalSettings $terminal (Join-Path $PSScriptRoot 'terminal/settings.json') -ThemesOnly
Write-Host 'Windows Terminal themes are up to date.'
