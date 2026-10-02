function Install-WingetPackage($id, $name) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Warning "winget not found. Skipping $name."
        return $false
    }

    Write-Host "Checking $name..."
    $null = winget list --id $id --exact --source winget `
        --accept-source-agreements 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "$name already installed. Checking for updates..."
        winget upgrade --id $id --exact --source winget `
            --accept-package-agreements --accept-source-agreements

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$name updated or already current."
            return $true
        }

        Write-Warning "Failed to update $name."
        return $false
    }

    Write-Host "Installing $name..."
    winget install --id $id --exact --source winget `
        --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to install $name."
        return $false
    }

    Write-Host "$name installed."
    return $true
}

function Get-MiseCommand {
    $command = Get-Command mise -CommandType Application `
        -ErrorAction SilentlyContinue
    if ($null -ne $command -and (Test-MiseCommand $command.Source)) {
        return $command.Source
    }

    $candidates = @(
        "$env:LOCALAPPDATA\Microsoft\WinGet\Links\mise.exe",
        "$env:LOCALAPPDATA\mise\bin\mise.exe",
        "$env:ProgramFiles\mise\bin\mise.exe",
        "$env:ProgramFiles\mise\mise.exe"
    )

    foreach ($candidate in $candidates) {
        if ((Test-Path $candidate) -and (Test-MiseCommand $candidate)) {
            return $candidate
        }
    }

    return $null
}

function Test-MiseCommand($path) {
    $previousErrorActionPreference = $ErrorActionPreference

    try {
        $ErrorActionPreference = "Stop"
        & $path --version *> $null
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
}

function Get-MiseToolVersion($configFile, $tool) {
    if (-not (Test-Path $configFile)) {
        return $null
    }

    $pattern = "^\s*$([regex]::Escape($tool))\s*=\s*`"([^`"]+)`""
    $line = Get-Content $configFile | Where-Object {
        $_ -match $pattern
    } | Select-Object -First 1

    if ($null -eq $line) {
        return $null
    }

    return [regex]::Match($line, $pattern).Groups[1].Value
}

function Install-NpmGlobalPackage($package, $commandName, $name) {
    if (Get-Command $commandName -ErrorAction SilentlyContinue) {
        Write-Host "$name already installed. Updating..."
    }
    else {
        Write-Host "Installing $name..."
    }

    if (Get-Command npm -ErrorAction SilentlyContinue) {
        npm install -g $package
    }
    else {
        $mise = Get-MiseCommand
        if ($null -eq $mise) {
            Write-Warning "npm and mise not found. Skipping $name."
            Write-Warning "If mise was just installed, restart PowerShell and rerun this script."
            return $false
        }

        Write-Host "Using mise-provided npm for $name..."
        $nodeVersion = Get-MiseToolVersion "$repoRoot\.config\mise\config.toml" "node"

        if ($null -eq $nodeVersion) {
            Write-Warning "Node.js version not found in mise config. Skipping $name."
            return $false
        }

        & $mise --yes --no-config exec "node@$nodeVersion" -- npm install -g $package
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to install $name."
        return $false
    }

    Write-Host "$name installed."
    return $true
}

function Install-MSYS2 {
    $msysEnv = "C:\msys64\usr\bin\env.exe"
    if (Test-Path $msysEnv) {
        return $msysEnv
    }

    Write-Host "MSYS2 is required for the Windows Lua toolchain."
    if (-not (Install-WingetPackage "MSYS2.MSYS2" "MSYS2")) {
        Write-Warning "MSYS2 could not be installed. Skipping Lua and LuaRocks setup."
        return $null
    }

    if (-not (Test-Path $msysEnv)) {
        Write-Warning "MSYS2 was installed, but $msysEnv was not found."
        Write-Warning "Skipping Lua and LuaRocks setup."
        return $null
    }

    return $msysEnv
}

function Get-WindowsTerminalSettingsDirectory {
    $term = Get-AppxPackage -Name "Microsoft.WindowsTerminal*" `
        -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $term) {
        return $null
    }

    return Join-Path $env:LOCALAPPDATA `
        "Packages\$($term.PackageFamilyName)\LocalState"
}

function Test-VSCodeInstallation {
    $appPackage = Get-AppxPackage -Name "Microsoft.VisualStudioCode*" `
        -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $appPackage) {
        return $true
    }

    $candidates = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
        "$env:ProgramFiles\Microsoft VS Code\Code.exe",
        "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe"
    )

    return $null -ne ($candidates | Where-Object { Test-Path $_ } |
        Select-Object -First 1)
}
