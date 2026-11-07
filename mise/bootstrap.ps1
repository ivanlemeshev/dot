[CmdletBinding()]
param([switch]$DryRun, [switch]$NoShell)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'windows/helpers.ps1')
Assert-Windows
$MiseRoot = $PSScriptRoot
$env:MISE_CONFIG_DIR = $MiseRoot
$env:HOME = $HOME

if ($DryRun) {
    Update-ProcessPath
    $mise = Find-Mise
    if ($null -eq $mise) { throw 'Install mise before the dry run.' }
    $env:MISE_TRUSTED_CONFIG_PATHS = $MiseRoot
    Invoke-Checked $mise @('bootstrap', '--dry-run', '--only', 'packages')
    Invoke-Checked $mise @('dot', 'apply', '--dry-run', '--force')
    return
}

if (-not (Test-Administrator)) {
    $arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"")
    if ($NoShell) { $arguments += '-NoShell' }
    $process = Start-Process -FilePath (Get-Process -Id $PID).Path -ArgumentList $arguments -Verb RunAs -Wait -PassThru
    if ($process.ExitCode -ne 0) { throw "Elevated bootstrap fails with exit code $($process.ExitCode)." }
    return
}

$target = Join-Path $HOME '.config/mise'
$current = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
if ($null -ne $current) {
    if ($current.LinkType -ne 'SymbolicLink' -or
        [IO.Path]::GetFullPath(@($current.Target)[0]).TrimEnd('\') -ne [IO.Path]::GetFullPath($MiseRoot).TrimEnd('\')) {
        throw "Move the existing mise configuration before setup: $target"
    }
}

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

if ($null -eq $current) {
    Set-RepositoryLink $MiseRoot $target
}
$env:MISE_CONFIG_DIR = $target
$miseDirectory = Split-Path -Parent $mise
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $miseDirectory) {
    [Environment]::SetEnvironmentVariable('Path', "$miseDirectory;$userPath", 'User')
}
$env:PATH = "$miseDirectory;$env:PATH"

Set-LocalGitConfig
Invoke-Checked $mise @('trust', (Join-Path $MiseRoot 'config.toml'))
Invoke-Checked $mise @('bootstrap', '--yes', '--only', 'packages')
Backup-ConflictingDotfiles $mise
Invoke-Checked $mise @('dot', 'apply', '--yes')
Update-ProcessPath
Invoke-Checked $mise @('install')
Invoke-Checked $mise @('run', 'configure')
Invoke-Checked $mise @('run', 'verify')
if (-not $NoShell) {
    Invoke-Checked pwsh @('-NoLogo', '-NoExit')
}
