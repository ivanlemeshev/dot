#!/usr/bin/env pwsh
#MISE description="Remove Windows configuration links and restore adapter settings"

$ErrorActionPreference = 'Stop'
& (Join-Path (Split-Path -Parent $PSScriptRoot) 'unapply.ps1')
