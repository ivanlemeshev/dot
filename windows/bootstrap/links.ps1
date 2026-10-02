#region yt-dlp Helpers

$ytDlpHelpersSource = "$repoRoot\windows\powershell\yt-dlp.ps1"
$ytDlpHelpersDirectory = "$env:USERPROFILE\.config\powershell"
$ytDlpHelpersTarget = "$ytDlpHelpersDirectory\yt-dlp.ps1"

if (-not (Test-Path $ytDlpHelpersSource)) {
    Write-Warning "yt-dlp helpers source not found: $ytDlpHelpersSource"
    Write-Warning "Skipping yt-dlp helpers setup."
}
else {
    if (-not (Test-Path $ytDlpHelpersDirectory)) {
        New-Item $ytDlpHelpersDirectory -ItemType Directory -Force | Out-Null
    }

    if (Test-Path $ytDlpHelpersTarget) {
        $ytDlpHelpersItem = Get-Item $ytDlpHelpersTarget
        $existing = $ytDlpHelpersItem.Target

        if ($ytDlpHelpersItem.LinkType -eq "SymbolicLink" -and `
                $existing -eq $ytDlpHelpersSource) {
            Write-Host "yt-dlp helpers already linked."
        }
        elseif ($ytDlpHelpersItem.LinkType -eq "SymbolicLink") {
            Write-Host "Updating yt-dlp helpers link..."
            Remove-Item $ytDlpHelpersTarget -Force
            New-Item $ytDlpHelpersTarget -ItemType SymbolicLink `
                -Value $ytDlpHelpersSource | Out-Null
            Write-Host "yt-dlp helpers link updated."
        }
        else {
            $backup = "$ytDlpHelpersTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Host "Backing up existing yt-dlp helpers to $backup"
            Move-Item $ytDlpHelpersTarget $backup
            New-Item $ytDlpHelpersTarget -ItemType SymbolicLink `
                -Value $ytDlpHelpersSource | Out-Null
            Write-Host "yt-dlp helpers linked."
        }
    }
    else {
        New-Item $ytDlpHelpersTarget -ItemType SymbolicLink `
            -Value $ytDlpHelpersSource | Out-Null
        Write-Host "yt-dlp helpers linked."
    }
}

#endregion

#region PowerShell Profiles

$powerShellProfileSource = "$repoRoot\windows\powershell\profile.ps1"
$documentsDirectory = [Environment]::GetFolderPath("MyDocuments")
$powerShellProfileTargets = @(
    (Join-Path $documentsDirectory "WindowsPowerShell\profile.ps1"),
    (Join-Path $documentsDirectory "PowerShell\profile.ps1")
)

foreach ($powerShellProfileTarget in $powerShellProfileTargets) {
    $profileDirectory = Split-Path -Parent $powerShellProfileTarget
    if (-not (Test-Path $profileDirectory)) {
        New-Item $profileDirectory -ItemType Directory -Force | Out-Null
    }

    if (Test-Path $powerShellProfileTarget) {
        $profileItem = Get-Item $powerShellProfileTarget
        if ($profileItem.LinkType -eq "SymbolicLink" -and
            $profileItem.Target -eq $powerShellProfileSource) {
            Write-Host "PowerShell profile already linked: $powerShellProfileTarget"
            continue
        }

        if ($profileItem.LinkType -eq "SymbolicLink") {
            Remove-Item $powerShellProfileTarget -Force
        }
        else {
            $backup = "$powerShellProfileTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Move-Item $powerShellProfileTarget $backup
            Write-Host "Backed up existing PowerShell profile to $backup"
        }
    }

    New-Item $powerShellProfileTarget -ItemType SymbolicLink `
        -Value $powerShellProfileSource | Out-Null
    Write-Host "PowerShell profile linked: $powerShellProfileTarget"
}

#endregion

#region Codex Skills

$codexSkillsSource = "$repoRoot\.codex\skills"
$codexSkillsTarget = "$env:USERPROFILE\.codex\skills"

if (-not (Test-Path $codexSkillsSource)) {
    Write-Warning "Codex skills source not found: $codexSkillsSource"
    Write-Warning "Skipping Codex skills setup."
}
else {
    if (-not (Test-Path $codexSkillsTarget)) {
        New-Item $codexSkillsTarget -ItemType Directory -Force | Out-Null
    }

    Get-ChildItem -Force $codexSkillsSource -Directory | Where-Object {
        $_.Name -ne ".system"
    } | ForEach-Object {
        $codexSkillSource = $_.FullName
        $codexSkillTarget = Join-Path $codexSkillsTarget $_.Name

        if (Test-Path $codexSkillTarget) {
            $codexSkillItem = Get-Item $codexSkillTarget
            $existing = $codexSkillItem.Target

            if ($codexSkillItem.LinkType -eq "SymbolicLink" -and `
                    $existing -eq $codexSkillSource) {
                Write-Host "Codex skill already linked: $($_.Name)"
            }
            else {
                if ($codexSkillItem.LinkType -eq "SymbolicLink") {
                    Write-Host "Updating Codex skill link: $($_.Name)"
                    Remove-Item $codexSkillTarget -Force
                }
                else {
                    $backup = "$codexSkillTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
                    Write-Host "Backing up existing Codex skill to $backup"
                    Move-Item $codexSkillTarget $backup
                }

                New-Item $codexSkillTarget -ItemType SymbolicLink `
                    -Value $codexSkillSource | Out-Null
                Write-Host "Codex skill linked: $($_.Name)"
            }
        }
        else {
            New-Item $codexSkillTarget -ItemType SymbolicLink `
                -Value $codexSkillSource | Out-Null
            Write-Host "Codex skill linked: $($_.Name)"
        }
    }
}

#endregion

#region Windows Terminal Settings

$termDir = Get-WindowsTerminalSettingsDirectory

if ($null -eq $termDir) {
    Write-Warning "Windows Terminal not found. Skipping..."
}
else {
    $source = Join-Path $repoRoot "windows\terminal\settings.json"

    if (-not (Test-Path $termDir)) {
        New-Item $termDir -ItemType Directory -Force | Out-Null
    }

    if (-not (Test-Path $source)) {
        Write-Warning "Terminal settings source not found: $source"
        Write-Warning "Skipping Windows Terminal settings."
    }
    else {
        Set-WindowsTerminalSettings $termDir $source
        Write-Host "Windows Terminal settings updated."
    }
}

#endregion

#region VSCode Settings

if (-not (Test-VSCodeInstallation)) {
    Write-Warning "VSCode not found. Skipping..."
}
else {
    $vscodeDir = "$env:APPDATA\Code\User"

    $settingsTarget = "$vscodeDir\settings.json"
    $settingsSource = "$repoRoot\windows\vscode\settings.json"

    $keybindingsTarget = "$vscodeDir\keybindings.json"
    $keybindingsSource = "$repoRoot\windows\vscode\keybindings.json"

    if (-not (Test-Path $vscodeDir)) {
        New-Item $vscodeDir -ItemType Directory -Force | Out-Null
    }

    if (-not (Test-Path $settingsSource)) {
        Write-Warning "VSCode settings source not found: $settingsSource"
        Write-Warning "Skipping VSCode settings."
    }
    elseif (Test-Path $settingsTarget) {
        $targetItem = Get-Item $settingsTarget
        $existing = $targetItem.Target

        if ($targetItem.LinkType -eq "SymbolicLink" -and $existing -eq $settingsSource) {
            Write-Host "VSCode settings already linked."
        }
        elseif ($targetItem.LinkType -eq "SymbolicLink") {
            Write-Host "Updating VSCode settings link..."
            Remove-Item $settingsTarget -Force
            New-Item $settingsTarget -ItemType SymbolicLink `
                -Value $settingsSource | Out-Null
            Write-Host "VSCode settings updated."
        }
        else {
            $backup = "$settingsTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Host "Backing up existing VSCode settings to $backup"
            Move-Item $settingsTarget $backup
            New-Item $settingsTarget -ItemType SymbolicLink `
                -Value $settingsSource | Out-Null
            Write-Host "VSCode settings created."
        }
    }
    else {
        Write-Host "Creating VSCode settings link..."
        New-Item $settingsTarget -ItemType SymbolicLink `
            -Value $settingsSource | Out-Null
        Write-Host "VSCode settings created."
    }

    if (-not (Test-Path $keybindingsSource)) {
        Write-Warning "VSCode keybindings source not found: $keybindingsSource"
        Write-Warning "Skipping VSCode keybindings."
    }
    elseif (Test-Path $keybindingsTarget) {
        $targetItem = Get-Item $keybindingsTarget
        $existing = $targetItem.Target

        if ($targetItem.LinkType -eq "SymbolicLink" -and $existing -eq $keybindingsSource) {
            Write-Host "VSCode keybindings already linked."
        }
        elseif ($targetItem.LinkType -eq "SymbolicLink") {
            Write-Host "Updating VSCode keybindings link..."
            Remove-Item $keybindingsTarget -Force
            New-Item $keybindingsTarget -ItemType SymbolicLink `
                -Value $keybindingsSource | Out-Null
            Write-Host "VSCode keybindings updated."
        }
        else {
            $backup = "$keybindingsTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Host "Backing up existing VSCode keybindings to $backup"
            Move-Item $keybindingsTarget $backup
            New-Item $keybindingsTarget -ItemType SymbolicLink `
                -Value $keybindingsSource | Out-Null
            Write-Host "VSCode keybindings created."
        }
    }
    else {
        Write-Host "Creating VSCode keybindings link..."
        New-Item $keybindingsTarget -ItemType SymbolicLink `
            -Value $keybindingsSource | Out-Null
        Write-Host "VSCode keybindings created."
    }
}

#endregion
