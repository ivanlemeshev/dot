function Get-WindowsTerminalSettingsDirectory {
    $term = if (Get-Command Get-AppxPackage -ErrorAction SilentlyContinue) {
        Get-AppxPackage -Name "Microsoft.WindowsTerminal*" -ErrorAction SilentlyContinue | Select-Object -First 1
    }
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
            profiles  = [pscustomobject]@{
                defaults = [pscustomobject]@{}
                list     = @()
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

    foreach ($profile in $settings.profiles.list) {
        $profile | Add-Member -Force -NotePropertyName colorScheme `
            -NotePropertyValue $sharedDefaults.colorScheme
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
    param([string]$Directory, [string]$SharedSettingsPath)
    $target = Join-Path $Directory 'settings.json'
    $statePath = Join-Path $StateDirectory 'terminal.json'
    $item = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    $original = if ($null -ne $item) {
        [IO.File]::ReadAllBytes($target)
    } else {
        $null
    }
    $settings = if ($null -ne $original) {
        [Text.Encoding]::UTF8.GetString($original).TrimStart([char]0xfeff) | ConvertFrom-Json
    } else {
        $null
    }
    $local = Join-Path $Directory 'settings.local.json'
    if ($null -ne $item -and ($item.LinkType -eq 'SymbolicLink' -or $settings.import) -and (Test-Path -LiteralPath $local)) {
        $settings = Get-Content -LiteralPath $local -Raw | ConvertFrom-Json
    }
    $shared = Get-Content -LiteralPath $SharedSettingsPath -Raw | ConvertFrom-Json
    $settings = Merge-WindowsTerminalSettings $settings $shared
    $settings | Add-Member -Force -NotePropertyName theme -NotePropertyValue 'custom'
    $text = ($settings | ConvertTo-Json -Depth 100) + "`n"
    if ($null -ne $original -and [Text.Encoding]::UTF8.GetString($original) -eq $text) {
        return
    }
    $state = if (Test-Path -LiteralPath $statePath) {
        Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    } else {
        [pscustomobject]@{
            target   = $target
            previous = if ($null -eq $original) {
                $null
            } else {
                [Convert]::ToBase64String($original)
            }
            link     = if ($null -ne $item -and $item.LinkType -eq 'SymbolicLink') {
                @($item.Target)[0]
            } else {
                $null
            }
            applied  = $null
        }
    }
    if ($null -ne $item -and $item.LinkType -eq 'SymbolicLink') {
        Remove-Item -LiteralPath $target -Force
    }
    New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    [IO.File]::WriteAllText($target, $text, [Text.UTF8Encoding]::new($false))
    $state.applied = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
    Save-StateText 'terminal.json' ($state | ConvertTo-Json -Depth 10)
}

function Restore-WindowsTerminalSettings {
    $statePath = Join-Path $StateDirectory 'terminal.json'
    if (-not (Test-Path -LiteralPath $statePath)) {
        return
    }
    $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    if ((Get-FileHash -LiteralPath $state.target -Algorithm SHA256).Hash -ne $state.applied) {
        throw 'Windows Terminal settings change after setup. Keep the current file and review terminal.json.'
    }
    if ($state.link) {
        Remove-Item -LiteralPath $state.target -Force
        New-Item -ItemType SymbolicLink -Path $state.target -Value $state.link | Out-Null
    } elseif ($null -ne $state.previous) {
        [IO.File]::WriteAllBytes($state.target, [Convert]::FromBase64String($state.previous))
    } else {
        Remove-Item -LiteralPath $state.target
    }
    Remove-Item -LiteralPath $statePath
}
