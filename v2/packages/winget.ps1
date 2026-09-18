[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$Manifest
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -Path $Manifest -PathType Leaf)) {
  [Console]::Error.WriteLine("Manifest does not exist: $Manifest")
  exit 2
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  [Console]::Error.WriteLine('WinGet is required. Install App Installer from the Microsoft Store.')
  exit 2
}

$packages = foreach ($capability in Get-Content -Path $Manifest) {
  switch ($capability) {
    'git' { 'Git.Git' }
    '' { }
    default {
      [Console]::Error.WriteLine("Unsupported capability: $capability")
      exit 2
    }
  }
}

foreach ($package in $packages) {
  winget install --id $package --exact --silent --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}
