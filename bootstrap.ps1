[CmdletBinding()]
param([switch]$DryRun, [switch]$NoShell)

$ErrorActionPreference = 'Stop'
$originalLocation = Get-Location

try {
    . (Join-Path $PSScriptRoot 'windows/helpers.ps1')
    . (Join-Path $PSScriptRoot 'windows/toolchains.ps1')
    Assert-Windows
    $MiseRoot = $PSScriptRoot
    $env:MISE_CONFIG_DIR = $MiseRoot
    Set-Location $MiseRoot

    if ($DryRun) {
        Write-Host 'Bootstrap upgrades declared WinGet packages and MSYS2 toolchain packages before configuration.'
        Update-ProcessPath
        $mise = Find-Mise
        if ($null -eq $mise) { throw 'Install mise before the dry run.' }
        $env:MISE_TRUSTED_CONFIG_PATHS = $MiseRoot
        Invoke-Checked $mise @('bootstrap', 'packages', 'upgrade', '--manager', 'winget', '--dry-run')
        Invoke-Checked $mise @('bootstrap', '--dry-run', '--only', 'packages')
        if (-not (Test-WindowsMsys2)) {
            if (Test-Path -LiteralPath 'C:\msys64') { throw 'C:\msys64 exists but its MSYS2 runtime is incomplete.' }
            Invoke-Checked $mise @('bootstrap', 'packages', 'apply', 'winget:MSYS2.MSYS2', '--dry-run')
        }
        Invoke-Checked $mise @('dot', 'apply', '--dry-run', '--force')
        return
    }

    if (-not (Test-Administrator)) {
        $arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"")
        if ($NoShell) { $arguments += '-NoShell' }
        Start-Process -FilePath (Get-Process -Id $PID).Path -ArgumentList $arguments -Verb RunAs -WorkingDirectory $MiseRoot
        return
    }

    $target = Join-Path $HOME '.config/mise'

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null
        Install-Module Microsoft.WinGet.Client -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
        Import-Module Microsoft.WinGet.Client
        Repair-WinGetPackageManager -Force -Latest
    }
    Update-ProcessPath
    Install-WinGetPackage 'Git.Git'
    Install-WinGetPackage 'Microsoft.PowerShell'
    Install-WinGetPackage 'jdx.mise'
    $mise = Find-Mise
    if ($null -eq $mise) { throw 'WinGet does not provide a working mise command.' }
    $miseVersion = & $mise --version | Out-String
    if ($miseVersion -notmatch '(\d+\.\d+\.\d+)' -or [version]$Matches[1] -lt [version]'2026.11.1') {
        Update-RequiredPackage 'jdx.mise'
        $mise = Find-Mise
    }
    Invoke-Checked $mise @('--version')

    Set-RepositoryLink $MiseRoot $target
    $env:MISE_CONFIG_DIR = $target
    $miseDirectory = Split-Path -Parent $mise
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if (($userPath -split ';') -notcontains $miseDirectory) {
        [Environment]::SetEnvironmentVariable('Path', "$miseDirectory;$userPath", 'User')
    }
    $env:PATH = "$miseDirectory;$env:PATH"

    Set-LocalGitConfig
    Invoke-Checked $mise @('trust', (Join-Path $MiseRoot 'config.toml'))
    Invoke-Checked $mise @('bootstrap', 'packages', 'upgrade', '--manager', 'winget', '--yes')
    Invoke-Checked $mise @('bootstrap', '--yes', '--only', 'packages')
    Invoke-Checked $mise @('install')
    Invoke-Checked $mise @('exec', '--', 'python', (Join-Path $MiseRoot 'migration.py'))
    Backup-ConflictingDotfiles $mise
    Invoke-Checked $mise @('dot', 'apply', '--yes')
    Update-ProcessPath
    Invoke-Checked $mise @('run', 'configure')
    Invoke-Checked $mise @('run', 'verify')
    if (-not $NoShell) {
        Invoke-Checked pwsh @('-NoLogo', '-NoExit')
    }
} catch {
    Write-Host "Bootstrap fails: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace
    if (-not $NoShell -and [Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
        Read-Host 'Press Enter to close this window' | Out-Null
    }
    throw
} finally {
    try {
        if (-not $DryRun -and (Get-Command Repair-MiseHistoryOwnership -ErrorAction SilentlyContinue) -and (Test-Administrator)) {
            Repair-MiseHistoryOwnership
        }
    } finally {
        Set-Location $originalLocation
    }
}
