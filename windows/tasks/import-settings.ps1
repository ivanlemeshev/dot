#!/usr/bin/env pwsh
#MISE description="Import legacy machine settings without executing config.env"

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
& python (Join-Path $root 'utilities.py') 'import-settings' @args
exit $LASTEXITCODE
