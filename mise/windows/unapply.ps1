$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'helpers.ps1')
. (Join-Path $PSScriptRoot 'keyboard.ps1')
. (Join-Path $PSScriptRoot 'terminal.ps1')
Assert-Windows
if (-not (Test-Administrator)) { throw 'Run Windows configuration removal from an elevated PowerShell.' }
Invoke-Checked (Find-Mise) @('dot', 'unapply', '--yes')
Remove-WindowsSkills
Restore-DotfileBackups
Restore-CapsLockMapping
Restore-WindowsTerminalSettings
