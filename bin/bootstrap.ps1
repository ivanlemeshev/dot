# Run as Administrator:
#
# To allow script execution, run PowerShell as Administrator and execute:
# Set-ExecutionPolicy RemoteSigned
#
# To revert to default policy, run as Administrator:
# Set-ExecutionPolicy Restricted

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Split-Path -Parent $scriptDir
$originalLocation = Get-Location

Set-Location $scriptDir

try {
    # Check if running as Administrator
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $isAdmin) {
        $pwshExe = Join-Path $PSHOME 'pwsh.exe'
        $relaunchExe = if (Test-Path $pwshExe) {
            $pwshExe
        }
        else {
            "powershell.exe"
        }

        Start-Process $relaunchExe `
            "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
            -Verb RunAs -WorkingDirectory $scriptDir

        return
    }

    Write-Host "Current directory: $scriptDir"
    Write-Host "Repository root: $repoRoot"
    Write-Host "User profile: $env:USERPROFILE"
    Write-Host ""

    $restartRequired = $false

    $bootstrapDir = Join-Path $repoRoot "windows\bootstrap"
    . (Join-Path $bootstrapDir "helpers.ps1")
    . (Join-Path $bootstrapDir "packages.ps1")
    . (Join-Path $bootstrapDir "git.ps1")
    . (Join-Path $bootstrapDir "keyboard-map.ps1")
    . (Join-Path $bootstrapDir "keyboard.ps1")
    . (Join-Path $bootstrapDir "terminal.ps1")
    . (Join-Path $bootstrapDir "fonts.ps1")
    . (Join-Path $bootstrapDir "links-common.ps1")
    . (Join-Path $bootstrapDir "mise.ps1")
    . (Join-Path $bootstrapDir "links.ps1")
    . $PROFILE.CurrentUserAllHosts

    Write-Host ""
    Write-Host "Setup completed!"

    if ($restartRequired) {
        Write-Host ""
        Write-Host "Restart required."
        Write-Host -NoNewLine "Press Enter to restart (or close to restart later)..."
        Read-Host | Out-Null
        Restart-Computer
    }
    else {
        Write-Host ""
        Write-Host "No restart required. All changes applied."
        Read-Host "Press Enter to exit" | Out-Null
    }
}
finally {
    Set-Location $originalLocation
}
