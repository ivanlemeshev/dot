$ErrorActionPreference = 'Stop'
$MiseRoot = Split-Path -Parent $PSScriptRoot
$StateDirectory = Join-Path $HOME '.local/state/dotfiles-windows'

function Invoke-Checked {
    param([string]$Command, [string[]]$Arguments)
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Command fails with exit code $LASTEXITCODE."
    }
}

function Assert-Windows {
    if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
        throw 'This task requires Windows.'
    }
    if ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64') {
        throw 'This setup requires 64-bit PowerShell on Windows x64.'
    }
}

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Update-ProcessPath {
    $env:DOTFILES_DOCUMENTS = [Environment]::GetFolderPath('MyDocuments')
    if (-not $env:DOTFILES_DOCUMENTS) {
        $env:DOTFILES_DOCUMENTS = Join-Path $HOME 'Documents'
    }
    # NOTE: Keep activated mise tools ahead of Windows aliases and fallback tools.
    $paths = @($env:PATH -split ';')
    $paths += @(
        (Join-Path $HOME '.local/bin'),
        (Join-Path $HOME '.julia/bin'),
        (Join-Path $env:LOCALAPPDATA 'Microsoft/WinGet/Links'),
        (Join-Path $env:LOCALAPPDATA 'Microsoft/WindowsApps'),
        (Join-Path $env:ProgramFiles 'Git/cmd'),
        (Join-Path $env:ProgramFiles 'PowerShell/7'),
        (Join-Path $env:ProgramFiles 'Neovim/bin'),
        (Join-Path $env:ProgramFiles 'LLVM/bin'),
        (Join-Path $env:ProgramFiles 'CMake/bin'),
        (Join-Path $env:LOCALAPPDATA 'Programs/Microsoft VS Code/bin'),
        'C:\msys64\ucrt64\bin'
    )
    $paths += [Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
    $paths += [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
    $env:PATH = ($paths | Where-Object { $_ } | Select-Object -Unique) -join ';'
}

function Find-Mise {
    $command = Get-Command mise -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $command) {
        return $command.Source
    }
    $candidates = @(
        (Join-Path $HOME '.local/bin/mise.exe'),
        (Join-Path $env:LOCALAPPDATA 'Microsoft/WinGet/Links/mise.exe'),
        (Join-Path $env:LOCALAPPDATA 'mise/bin/mise.exe')
    )
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }
    return $null
}

function Install-WinGetPackage {
    param([string]$Id)
    & winget list --id $Id --exact --source winget --accept-source-agreements --disable-interactivity *> $null
    if ($LASTEXITCODE -eq 0) {
        return
    }
    Invoke-Checked winget @('install', '--id', $Id, '--exact', '--source', 'winget', '--silent', '--accept-package-agreements', '--accept-source-agreements', '--disable-interactivity')
    Update-ProcessPath
}

function Save-StateText {
    param([string]$Name, [string]$Value)
    New-Item -ItemType Directory -Path $StateDirectory -Force | Out-Null
    [IO.File]::WriteAllText((Join-Path $StateDirectory $Name), $Value, [Text.UTF8Encoding]::new($false))
}

function Set-LocalGitConfig {
    $localConfig = Join-Path $HOME '.config/git/config.local'
    New-Item -ItemType Directory -Path (Split-Path -Parent $localConfig) -Force | Out-Null
    if (-not (Test-Path -LiteralPath $localConfig)) {
        [IO.File]::WriteAllText($localConfig, '')
    }
    $values = @{
        'init.defaultBranch' = $env:GIT_DEFAULT_BRANCH
        'user.name'          = $env:GIT_USER_NAME
        'user.email'         = $env:GIT_USER_EMAIL
    }
    foreach ($key in $values.Keys) {
        if (-not [string]::IsNullOrWhiteSpace($values[$key])) {
            Invoke-Checked git @('config', '--file', $localConfig, '--replace-all', $key, $values[$key])
        } else {
            $existing = & git config --file $localConfig --get $key
            if ($LASTEXITCODE -eq 0) {
                continue
            }
            if ($LASTEXITCODE -ne 1) {
                throw 'Cannot read the local Git configuration.'
            }
            $previous = & git config --global --get $key
            if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($previous)) {
                Invoke-Checked git @('config', '--file', $localConfig, '--replace-all', $key, $previous)
            } elseif ($LASTEXITCODE -ne 1 -and $LASTEXITCODE -ne 0) {
                throw 'Cannot read the existing global Git configuration.'
            }
        }
    }
}

function Set-RepositoryLink {
    param([string]$Source, [string]$Target)
    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Source is missing: $Source"
    }
    $item = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
    if ($null -ne $item) {
        if ($item.LinkType -eq 'SymbolicLink' -and
            [IO.Path]::GetFullPath(@($item.Target)[0]) -eq [IO.Path]::GetFullPath($Source)) {
            return
        }
        $backup = "$Target.backup.$([DateTime]::UtcNow.ToString('yyyyMMddHHmmssfff'))"
        Move-Item -LiteralPath $Target -Destination $backup
        Write-Host "Backup: $backup"
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $Target) -Force | Out-Null
    New-Item -ItemType SymbolicLink -Path $Target -Value $Source | Out-Null
}

function Backup-Dotfile {
    param([string]$Target)
    if ($Target.StartsWith('~/') -or $Target.StartsWith('~\')) {
        $Target = Join-Path $HOME $Target.Substring(2)
    }
    $item = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) {
        return
    }
    $statePath = Join-Path $StateDirectory 'links.json'
    $records = @()
    if (Test-Path -LiteralPath $statePath) {
        $records = @((Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json))
    }
    if (@($records | Where-Object target -eq $Target).Count) {
        throw "A previous backup exists for $Target. Review links.json before replacement."
    }
    $backup = "$Target.backup.$([Guid]::NewGuid().ToString('N'))"
    $records += [pscustomobject]@{ target = $Target; backup = $backup }
    Save-StateText 'links.json' (ConvertTo-Json -InputObject @($records) -Depth 10)
    Move-Item -LiteralPath $Target -Destination $backup
    Write-Host "Backup: $backup"
}

function Backup-ConflictingDotfiles {
    param([string]$Mise)
    $json = & $Mise dot status --json
    if ($LASTEXITCODE -ne 0) {
        throw 'The dotfile status command fails.'
    }
    $status = ($json -join "`n") | ConvertFrom-Json
    if (@($status.files | Where-Object state -eq source_missing).Count) {
        throw 'A dotfile source is missing.'
    }
    foreach ($entry in $status.files | Where-Object state -eq differs) {
        if ($entry.mode -ne 'symlink') {
            throw "Unexpected dotfile mode: $($entry.mode)"
        }
        Backup-Dotfile $entry.target
    }
}

function Restore-DotfileBackups {
    $statePath = Join-Path $StateDirectory 'links.json'
    if (-not (Test-Path -LiteralPath $statePath)) {
        return
    }
    foreach ($record in @((Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json))) {
        if ($null -eq (Get-Item -LiteralPath $record.backup -Force -ErrorAction SilentlyContinue)) {
            continue
        }
        if ($null -ne (Get-Item -LiteralPath $record.target -Force -ErrorAction SilentlyContinue)) {
            throw "The restore target exists: $($record.target)"
        }
        Move-Item -LiteralPath $record.backup -Destination $record.target
    }
    Remove-Item -LiteralPath $statePath
}

function Update-RequiredPackage {
    param([string]$Id)
    Invoke-Checked winget @('upgrade', '--id', $Id, '--exact', '--source', 'winget', '--silent', '--accept-package-agreements', '--accept-source-agreements', '--disable-interactivity')
    Update-ProcessPath
}

function Assert-EditorVersions {
    param([switch]$Upgrade)
    $requirements = @(
        @{ command = 'nvim'; pattern = 'NVIM v(\d+\.\d+\.\d+)'; minimum = '0.12.0'; package = 'Neovim.Neovim' },
        @{ command = 'tree-sitter'; pattern = 'tree-sitter (\d+\.\d+\.\d+)'; minimum = '0.26.1'; package = 'tree-sitter.tree-sitter-cli' }
    )
    foreach ($requirement in $requirements) {
        $output = & $requirement.command --version | Out-String
        $valid = $LASTEXITCODE -eq 0 -and $output -match $requirement.pattern -and [version]$Matches[1] -ge [version]$requirement.minimum
        if (-not $valid -and $Upgrade) {
            Update-RequiredPackage $requirement.package
            $output = & $requirement.command --version | Out-String
            $valid = $LASTEXITCODE -eq 0 -and $output -match $requirement.pattern -and [version]$Matches[1] -ge [version]$requirement.minimum
        }
        if (-not $valid) {
            throw "$($requirement.command) $($requirement.minimum) or later is required."
        }
    }
}

function Get-RequiredVSCodeExtensions {
    return @('teabyii.ayu', 'JonathanHarty.gruvbox-material-icon-theme', 'streetsidesoftware.code-spell-checker', 'streetsidesoftware.code-spell-checker-russian', 'ms-vscode.PowerShell')
}
