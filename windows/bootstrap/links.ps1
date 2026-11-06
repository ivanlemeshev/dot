$ytDlpSource = Join-Path $repoRoot 'windows\powershell\yt-dlp.ps1'
$ytDlpTarget = Join-Path $env:USERPROFILE '.config\powershell\yt-dlp.ps1'
Set-DotfilesLink $ytDlpSource $ytDlpTarget 'yt-dlp helpers'

$neovimSource = Join-Path $repoRoot '.config\nvim'
$neovimTarget = Join-Path $env:LOCALAPPDATA 'nvim'
Set-DotfilesLink $neovimSource $neovimTarget 'Neovim configuration'

$psmuxSource = Join-Path $repoRoot '.config\psmux\psmux.conf'
$psmuxTarget = Join-Path $env:USERPROFILE '.psmux.conf'
Set-DotfilesLink $psmuxSource $psmuxTarget 'PSMux configuration'

$profileSource = Join-Path $repoRoot 'windows\powershell\profile.ps1'
$documentsDirectory = [Environment]::GetFolderPath('MyDocuments')
$profileTargets = @(
    (Join-Path $documentsDirectory 'WindowsPowerShell\profile.ps1'),
    (Join-Path $documentsDirectory 'PowerShell\profile.ps1')
)
foreach ($profileTarget in $profileTargets) {
    Set-DotfilesLink $profileSource $profileTarget 'PowerShell profile'
}

$codexSkillsSource = Join-Path $repoRoot '.codex\skills'
if (Test-Path -LiteralPath $codexSkillsSource) {
    Get-ChildItem -Force -Directory $codexSkillsSource |
        Where-Object { $_.Name -ne '.system' } |
        ForEach-Object {
            $target = Join-Path $env:USERPROFILE ".codex\skills\$($_.Name)"
            Set-DotfilesLink $_.FullName $target "Codex skill $($_.Name)"
        }
} else {
    Write-Warning "Codex skills source not found: $codexSkillsSource"
}

$termDir = Get-WindowsTerminalSettingsDirectory
if ($null -eq $termDir) {
    Write-Warning 'Windows Terminal not found. Skipping.'
} else {
    $terminalSource = Join-Path $repoRoot 'windows\terminal\settings.json'
    if (-not (Test-Path -LiteralPath $termDir)) {
        New-Item -Path $termDir -ItemType Directory -Force | Out-Null
    }

    if (-not (Test-Path -LiteralPath $terminalSource)) {
        Write-Warning "Terminal settings source not found: $terminalSource"
    } else {
        Set-WindowsTerminalSettings $termDir $terminalSource
        Write-Host 'Windows Terminal settings updated.'
    }
}

if (-not (Test-VSCodeInstallation)) {
    Write-Warning 'VS Code not found. Skipping.'
} else {
    $vscodeDir = Join-Path $env:APPDATA 'Code\User'
    $vscodeFiles = @(
        @{ Name = 'VS Code settings'; Source = 'windows\vscode\settings.json'; Target = 'settings.json' },
        @{ Name = 'VS Code keybindings'; Source = 'windows\vscode\keybindings.json'; Target = 'keybindings.json' }
    )

    foreach ($file in $vscodeFiles) {
        $source = Join-Path $repoRoot $file.Source
        $target = Join-Path $vscodeDir $file.Target
        Set-DotfilesLink $source $target $file.Name
    }
}

$batCommand = Get-Command bat -CommandType Application -ErrorAction SilentlyContinue
if ($null -ne $batCommand) {
    $batConfigDirectory = (& $batCommand.Source --config-dir).Trim()
    if ($LASTEXITCODE -ne 0 -or -not $batConfigDirectory) {
        throw 'The bat configuration directory is unavailable.'
    }
    Set-DotfilesLink (Join-Path $repoRoot '.config\bat') $batConfigDirectory 'bat configuration'
    & $batCommand.Source cache --build
    if ($LASTEXITCODE -ne 0) {
        throw 'The bat theme cache fails to build.'
    }
}

Set-DotfilesLink (Join-Path $repoRoot '.config\ripgrep\config') (Join-Path $env:USERPROFILE '.config\ripgrep\config') 'ripgrep colors'
$gitColorsTarget = Join-Path $env:USERPROFILE '.config\git\colors'
Set-DotfilesLink (Join-Path $repoRoot '.config\git\colors') $gitColorsTarget 'Git colors'
$gitIncludes = @(git config --global --get-all include.path)
if ($gitColorsTarget -notin $gitIncludes) {
    git config --global --add include.path $gitColorsTarget
    if ($LASTEXITCODE -ne 0) {
        throw 'The Git color include fails to install.'
    }
}
