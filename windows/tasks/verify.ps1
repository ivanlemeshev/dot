#!/usr/bin/env pwsh
#MISE description="Verify Windows tools and configuration"

$ErrorActionPreference = 'Stop'
& (Join-Path (Split-Path -Parent $PSScriptRoot) 'verify.ps1')
