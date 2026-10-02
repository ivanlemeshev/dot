function Get-GitCommand {
    $command = Get-Command git -CommandType Application `
        -ErrorAction SilentlyContinue
    if ($null -ne $command) {
        return $command.Source
    }

    $candidates = @(
        "$env:ProgramFiles\Git\cmd\git.exe",
        "${env:ProgramFiles(x86)}\Git\cmd\git.exe",
        "$env:LOCALAPPDATA\Programs\Git\cmd\git.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    return $null
}

function Get-GitSettings {
    $settings = @{}
    $configFile = Join-Path $repoRoot "config.env"
    if (-not (Test-Path $configFile)) {
        return $settings
    }

    foreach ($line in Get-Content $configFile) {
        if ($line -match '^\s*export\s+(GIT_USER_NAME|GIT_USER_EMAIL|GIT_DEFAULT_BRANCH)="(.*)"\s*$') {
            $settings[$Matches[1]] = $Matches[2]
        }
    }

    return $settings
}

function Set-DotfilesGitConfig {
    $git = Get-GitCommand
    if ($null -eq $git) {
        Write-Warning "Git was not found. Skipping Git configuration."
        return
    }

    $settings = Get-GitSettings
    $defaultBranch = $settings["GIT_DEFAULT_BRANCH"]
    if ([string]::IsNullOrWhiteSpace($defaultBranch)) {
        $defaultBranch = Read-Host "What default branch name do you want to use? [main]"
        if ([string]::IsNullOrWhiteSpace($defaultBranch)) {
            $defaultBranch = "main"
        }
    }

    $userEmail = $settings["GIT_USER_EMAIL"]
    if ([string]::IsNullOrWhiteSpace($userEmail)) {
        $userEmail = Read-Host "What user email do you want to use?"
    }

    $userName = $settings["GIT_USER_NAME"]
    if ([string]::IsNullOrWhiteSpace($userName)) {
        $userName = Read-Host "What user name do you want to use?"
    }

    Write-Host "Configuring Git..."
    & $git config --global init.defaultBranch $defaultBranch
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to set the default Git branch."
    }
    & $git config --global user.email $userEmail
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to set the Git user email."
    }
    & $git config --global user.name $userName
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to set the Git user name."
    }
    & $git config --global diff.tool nvim_difftool
    & $git config --global difftool.nvim_difftool.cmd `
        'nvim -c "packadd nvim.difftool" -c "DiffTool $LOCAL $REMOTE"'
    & $git config --global alias.lg `
        "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to complete Git configuration."
    }

    Write-Host "Git configuration complete."
}

Set-DotfilesGitConfig
