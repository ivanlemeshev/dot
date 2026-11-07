#!/usr/bin/env pwsh
#MISE description="Reset Neovim with --yes or preview with --dry-run"

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
& python (Join-Path $root 'utilities.py') 'reset-nvim' @args
exit $LASTEXITCODE
