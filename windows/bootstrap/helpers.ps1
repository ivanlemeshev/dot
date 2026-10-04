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
    if ($null -ne $term) {
        return Join-Path $env:LOCALAPPDATA `
            "Packages\$($term.PackageFamilyName)\LocalState"
    }

    $candidates = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState",
        "$env:LOCALAPPDATA\Microsoft\Windows Terminal"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    return $null
}

function Set-WindowsTerminalSettings {
    param($directory, $sharedSettingsPath)

    $target = Join-Path $directory "settings.json"
    $localSettings = Join-Path $directory "settings.local.json"
    $sharedSettings = Join-Path $directory "settings.shared.json"
    $shared = Get-Content $sharedSettingsPath -Raw | ConvertFrom-Json
    $sharedDefaults = $shared.profiles.defaults

    if ($null -eq $sharedDefaults) {
        throw "Terminal profile defaults are missing from $sharedSettingsPath"
    }

    $settings = $null
    $migrateLocalSettings = $false
    if (Test-Path $target) {
        $targetItem = Get-Item $target
        if ($targetItem.LinkType -eq "SymbolicLink" -or
            $targetItem.LinkType -eq "Junction") {
            if (Test-Path $localSettings) {
                $settings = Get-Content $localSettings -Raw | ConvertFrom-Json
            }
            else {
                $settings = Get-Content $target -Raw | ConvertFrom-Json
            }
            $migrateLocalSettings = $true
        }
        else {
            $settings = Get-Content $target -Raw | ConvertFrom-Json
            if ($settings.import -and (Test-Path $localSettings)) {
                $settings = Get-Content $localSettings -Raw | ConvertFrom-Json
                $migrateLocalSettings = $true
            }
        }
    }
    elseif (Test-Path $localSettings) {
        $settings = Get-Content $localSettings -Raw | ConvertFrom-Json
        $migrateLocalSettings = $true
    }

    if ($null -eq $settings) {
        $settings = [pscustomobject]@{
            '$schema' = "https://aka.ms/terminal-profiles-schema"
            profiles = [pscustomobject]@{
                defaults = [pscustomobject]@{}
                list = @()
            }
        }
    }

    if ($null -eq $settings.profiles) {
        $settings | Add-Member -Force -NotePropertyName profiles `
            -NotePropertyValue ([pscustomobject]@{})
    }
    if ($null -eq $settings.profiles.defaults) {
        $settings.profiles | Add-Member -Force -NotePropertyName defaults `
            -NotePropertyValue ([pscustomobject]@{})
    }
    if ($null -eq $settings.profiles.defaults.font) {
        $settings.profiles.defaults | Add-Member -Force -NotePropertyName font `
            -NotePropertyValue ([pscustomobject]@{})
    }
    if ($null -eq $settings.profiles.list) {
        $settings.profiles | Add-Member -Force -NotePropertyName list `
            -NotePropertyValue @()
    }

    foreach ($setting in $sharedDefaults.PSObject.Properties) {
        if ($setting.Name -eq "font") {
            if ($null -eq $settings.profiles.defaults.font) {
                $settings.profiles.defaults | Add-Member -Force `
                    -NotePropertyName font -NotePropertyValue ([pscustomobject]@{})
            }

            foreach ($fontSetting in $setting.Value.PSObject.Properties) {
                $settings.profiles.defaults.font | Add-Member -Force `
                    -NotePropertyName $fontSetting.Name `
                    -NotePropertyValue $fontSetting.Value
            }
        }
        else {
            $settings.profiles.defaults | Add-Member -Force `
                -NotePropertyName $setting.Name -NotePropertyValue $setting.Value
        }
    }

    foreach ($scheme in $shared.schemes) {
        $schemes = @($settings.schemes | Where-Object {
            $_.name -ne $scheme.name
        }) + $scheme
        $settings | Add-Member -Force -NotePropertyName schemes `
            -NotePropertyValue $schemes
    }

    foreach ($theme in $shared.themes) {
        $themes = @($settings.themes | Where-Object {
            $_.name -ne $theme.name
        }) + $theme
        $settings | Add-Member -Force -NotePropertyName themes `
            -NotePropertyValue $themes
    }

    foreach ($keybinding in $shared.keybindings) {
        $keybindingKeys = ConvertTo-Json -InputObject $keybinding.keys -Compress
        $keybindings = @($settings.keybindings | Where-Object {
            (ConvertTo-Json -InputObject $_.keys -Compress) -ne $keybindingKeys
        })
        $keybindings += $keybinding
        $settings | Add-Member -Force -NotePropertyName keybindings `
            -NotePropertyValue $keybindings
    }

    if ($migrateLocalSettings -and (Test-Path $target)) {
        $backup = "$target.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Copy-Item $target $backup
        if ((Get-Item $target).LinkType -in @("SymbolicLink", "Junction")) {
            Remove-Item $target -Force
        }
    }

    $settings | ConvertTo-Json -Depth 100 |
        Set-Content -Path $target -Encoding utf8

    if (Test-Path $sharedSettings) {
        $sharedItem = Get-Item $sharedSettings
        if ($sharedItem.LinkType -in @("SymbolicLink", "Junction")) {
            Remove-Item $sharedSettings -Force
        }
        else {
            $backup = "$sharedSettings.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Move-Item $sharedSettings $backup
        }
    }
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
