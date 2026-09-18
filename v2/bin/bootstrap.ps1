[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$v2Directory = Split-Path -Parent $PSScriptRoot
$manifest = Join-Path $v2Directory 'packages\common.txt'
$sourceDirectory = Join-Path $v2Directory 'home'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  [Console]::Error.WriteLine('WinGet is required. Install App Installer from the Microsoft Store.')
  exit 2
}

& (Join-Path $v2Directory 'packages\winget.ps1') -Manifest $manifest
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
  winget install --id twpayne.chezmoi --exact --silent --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

chezmoi apply --source $sourceDirectory
exit $LASTEXITCODE
