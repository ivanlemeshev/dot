#!/usr/bin/env pwsh
#MISE description="Reset Neovim with --yes or preview with --dry-run"

$ErrorActionPreference = 'Stop'
$yes = $false
$dryRun = $false
foreach ($argument in $args) {
    switch ($argument) {
        '--yes' { $yes = $true }
        '--dry-run' { $dryRun = $true }
        default { throw "Unknown argument: $argument" }
    }
}
$root = [IO.Path]::GetFullPath((Split-Path -Parent (Split-Path -Parent $PSScriptRoot))).TrimEnd('\')
$paths = @((Join-Path $env:LOCALAPPDATA 'nvim'), (Join-Path $env:LOCALAPPDATA 'nvim-data'))
foreach ($path in $paths) {
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    $fullPath = [IO.Path]::GetFullPath($path).TrimEnd('\')
    if (-not $item.LinkType -and ($fullPath -eq $root -or $fullPath.StartsWith("$root\", [StringComparison]::OrdinalIgnoreCase) -or $root.StartsWith("$fullPath\", [StringComparison]::OrdinalIgnoreCase))) {
        throw "The reset path contains the setup source: $path"
    }
    Write-Host "Reset path: $path"
}
if ($dryRun) { return }
if (-not $yes) { throw 'Review --dry-run, then pass --yes to remove these paths.' }
foreach ($path in $paths) {
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) { continue }
    if ($item.LinkType -and $item.PSIsContainer) {
        [IO.Directory]::Delete($path)
    } else {
        Remove-Item -LiteralPath $path -Recurse -Force
    }
}
Write-Host 'Neovim reset completes. Run bootstrap to restore the configuration link.'
