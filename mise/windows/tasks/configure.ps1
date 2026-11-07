#!/usr/bin/env pwsh
#MISE description="Configure Windows tools and applications"

$ErrorActionPreference = 'Stop'
& (Join-Path (Split-Path -Parent $PSScriptRoot) 'configure.ps1')
