#!/usr/bin/env pwsh
#MISE description="Set repository Git identity with --repo, --name, and --email"

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
& python (Join-Path $root 'utilities.py') 'set-git-repo-user' @args
exit $LASTEXITCODE
