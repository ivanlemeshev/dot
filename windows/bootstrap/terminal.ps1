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

function Merge-WindowsTerminalSettings($settings, $shared) {
    $sharedDefaults = $shared.profiles.defaults
    if ($null -eq $sharedDefaults) {
        throw 'Terminal profile defaults are missing from shared settings.'
    }

    if ($null -eq $settings) {
        $settings = [pscustomobject]@{
            '$schema' = 'https://aka.ms/terminal-profiles-schema'
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
        if ($setting.Name -eq 'font') {
            foreach ($fontSetting in $setting.Value.PSObject.Properties) {
                $settings.profiles.defaults.font | Add-Member -Force `
                    -NotePropertyName $fontSetting.Name `
                    -NotePropertyValue $fontSetting.Value
            }
        } else {
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

    return $settings
}

function Set-WindowsTerminalSettings {
    param($directory, $sharedSettingsPath)

    $target = Join-Path $directory "settings.json"
    $localSettings = Join-Path $directory "settings.local.json"
    $sharedSettings = Join-Path $directory "settings.shared.json"
    $shared = Get-Content $sharedSettingsPath -Raw | ConvertFrom-Json

    $settings = $null
    $migrateLocalSettings = $false
    if (Test-Path $target) {
        $targetItem = Get-Item $target
        if ($targetItem.LinkType -in @('SymbolicLink', 'Junction')) {
            if (Test-Path $localSettings) {
                $settings = Get-Content $localSettings -Raw | ConvertFrom-Json
            } else {
                $settings = Get-Content $target -Raw | ConvertFrom-Json
            }
            $migrateLocalSettings = $true
        } else {
            $settings = Get-Content $target -Raw | ConvertFrom-Json
            if ($settings.import -and (Test-Path $localSettings)) {
                $settings = Get-Content $localSettings -Raw | ConvertFrom-Json
                $migrateLocalSettings = $true
            }
        }
    } elseif (Test-Path $localSettings) {
        $settings = Get-Content $localSettings -Raw | ConvertFrom-Json
        $migrateLocalSettings = $true
    }

    $settings = Merge-WindowsTerminalSettings $settings $shared

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
        } else {
            $backup = "$sharedSettings.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Move-Item $sharedSettings $backup
        }
    }
}
