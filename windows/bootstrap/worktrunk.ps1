$command = Get-Command git-wt -CommandType Application -ErrorAction SilentlyContinue
$commandPath = if ($null -ne $command) { $command.Source } else { $null }

if ($null -eq $commandPath) {
    $candidate = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Links\git-wt.exe"
    if (Test-Path $candidate) {
        $commandPath = $candidate
    }
}

if ($null -eq $commandPath) {
    Write-Warning "Worktrunk command not found. Skipping shell integration."
    return
}

& $commandPath config shell install --yes
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to install Worktrunk shell integration."
    return
}

& $commandPath --version *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Worktrunk verification failed."
}
