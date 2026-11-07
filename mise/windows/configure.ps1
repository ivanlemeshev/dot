$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'helpers.ps1')
. (Join-Path $PSScriptRoot 'toolchains.ps1')
. (Join-Path $PSScriptRoot 'fonts.ps1')
. (Join-Path $PSScriptRoot 'keyboard.ps1')
. (Join-Path $PSScriptRoot 'terminal.ps1')
Assert-Windows
if (-not (Test-Administrator)) { throw 'Run Windows configuration from an elevated PowerShell.' }
Update-ProcessPath
Assert-EditorVersions -Upgrade
Install-WindowsLua
Install-WindowsCompiler
Set-LocalGitConfig
Install-NerdFont
Set-CapsLockMapping
Invoke-Checked gh @('config', 'set', 'editor', 'nvim')
Invoke-Checked gh @('config', 'set', 'pager', 'less')
Invoke-Checked gh @('config', 'set', 'git_protocol', 'ssh', '--host', 'github.com')
Invoke-Checked bat @('cache', '--build')
$extensions = @(& code --list-extensions)
if ($LASTEXITCODE -ne 0) { throw 'The VS Code extension list is unavailable.' }
foreach ($extension in Get-RequiredVSCodeExtensions) {
    if ($extensions -notcontains $extension) { Invoke-Checked code @('--install-extension', $extension) }
}
Invoke-Checked npm @('install', '--global', '@openai/codex')
$previousGoBin = $env:GOBIN
try {
    $env:GOBIN = Join-Path $HOME '.local/bin'
    Invoke-Checked go @('install', 'github.com/fullstorydev/grpcurl/cmd/grpcurl@latest')
} finally { $env:GOBIN = $previousGoBin }
Invoke-Checked julia @('-e', 'using Pkg; Pkg.Apps.add("Runic")')

$terminal = Get-WindowsTerminalSettingsDirectory
if ($null -eq $terminal) { throw 'Windows Terminal settings directory is unavailable.' }
Set-WindowsTerminalSettings $terminal (Join-Path $PSScriptRoot 'terminal/settings.json')

if ($env:WINDOWS_TIMEZONE -and (Get-TimeZone).Id -ne $env:WINDOWS_TIMEZONE) {
    Set-TimeZone -Id $env:WINDOWS_TIMEZONE
}
if ($env:MACHINE_NAME -and $env:COMPUTERNAME -ne $env:MACHINE_NAME) {
    Rename-Computer -NewName $env:MACHINE_NAME -Force
    Write-Host 'The computer name changes after the next restart.'
}

$env:MISE_NVIM_INSTALL = '1'
try {
    Invoke-Checked nvim @('--headless', '-u', 'NONE', '-l', (Join-Path $MiseRoot 'nvim/bootstrap.lua'))
} finally { Remove-Item Env:MISE_NVIM_INSTALL -ErrorAction SilentlyContinue }
