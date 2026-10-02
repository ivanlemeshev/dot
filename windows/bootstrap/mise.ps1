#region mise Configuration
Write-Host "Setting up mise configuration..."

$miseTargetDir = "$env:USERPROFILE\.config\mise"
$miseSourceDir = "$repoRoot\.config\mise"

if (-not (Test-Path $miseSourceDir)) {
    Write-Warning "mise config source not found: $miseSourceDir"
    Write-Warning "Skipping mise configuration."
}
elseif (Test-Path $miseTargetDir) {
    $miseTargetItem = Get-Item $miseTargetDir
    $existing = $miseTargetItem.Target

    if ($miseTargetItem.LinkType -eq "SymbolicLink" -and $existing -eq $miseSourceDir) {
        Write-Host "mise configuration already linked."
    }
    elseif ($miseTargetItem.LinkType -eq "SymbolicLink") {
        Write-Host "Updating mise configuration link..."
        Remove-Item $miseTargetDir -Force
        New-Item $miseTargetDir -ItemType SymbolicLink `
            -Value $miseSourceDir | Out-Null
        Write-Host "mise configuration updated."
    }
    else {
        $backup = "$miseTargetDir.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Write-Host "Backing up existing mise configuration to $backup"
        Move-Item $miseTargetDir $backup
        New-Item $miseTargetDir -ItemType SymbolicLink `
            -Value $miseSourceDir | Out-Null
        Write-Host "mise configuration created."
    }
}
else {
    $miseConfigParent = Split-Path -Parent $miseTargetDir
    if (-not (Test-Path $miseConfigParent)) {
        New-Item $miseConfigParent -ItemType Directory -Force | Out-Null
    }

    Write-Host "Creating mise configuration link..."
    New-Item $miseTargetDir -ItemType SymbolicLink `
        -Value $miseSourceDir | Out-Null
    Write-Host "mise configuration created."
}

$mise = Get-MiseCommand
if ($null -ne $mise) {
    $miseConfigFile = "$miseSourceDir\config.toml"
    if (Test-Path $miseConfigFile) {
        Write-Host "Trusting mise config..."
        & $mise --yes trust $miseConfigFile

        if ($LASTEXITCODE -ne 0) {
            Write-Warning "mise trust failed."
        }
    }

    $bootstrapTools = @("go", "golangci-lint", "node", "python", "zig")
    Write-Host "Installing Windows-compatible mise bootstrap tools..."
    & $mise --yes install @bootstrapTools

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "mise install failed."
    }
    else {
        Write-Host "mise bootstrap tools installed."
    }

    $msysEnv = Install-MSYS2
    if ($null -ne $msysEnv) {
        Write-Host "Installing Lua with MSYS2..."
        & $msysEnv MSYSTEM=UCRT64 CHERE_INVOKING=1 /usr/bin/bash -lc `
            "pacman -Sy --needed --noconfirm mingw-w64-ucrt-x86_64-lua mingw-w64-ucrt-x86_64-lua-luarocks"

        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to install Lua with MSYS2."
        }
        else {
            $msysUcrtBin = "C:\msys64\ucrt64\bin"
            if (($env:PATH -split ";") -notcontains $msysUcrtBin) {
                $env:PATH = "$msysUcrtBin;$env:PATH"
            }

            $lua = Join-Path $msysUcrtBin "lua.exe"
            $luarocks = Join-Path $msysUcrtBin "luarocks"
            $luarocksAdmin = Join-Path $msysUcrtBin "luarocks-admin"
            $luarocksCmd = Join-Path $msysUcrtBin "luarocks.cmd"
            $luarocksAdminCmd = Join-Path $msysUcrtBin "luarocks-admin.cmd"

            if (Test-Path $luarocks) {
                @(
                    "@echo off",
                    "`"$lua`" `"$luarocks`" %*"
                ) | Set-Content -Path $luarocksCmd -Encoding ASCII
            }

            if (Test-Path $luarocksAdmin) {
                @(
                    "@echo off",
                    "`"$lua`" `"$luarocksAdmin`" %*"
                ) | Set-Content -Path $luarocksAdminCmd -Encoding ASCII
            }

            if ((Test-Path $lua) -and (Test-Path $luarocks)) {
                & $lua -v
                & $msysEnv MSYSTEM=UCRT64 CHERE_INVOKING=1 /usr/bin/bash -lc "luarocks --version"
                Write-Host "Lua installed."
            }
            else {
                Write-Warning "Lua installed, but lua.exe or luarocks was not found in $msysUcrtBin."
            }
        }
    }

    if ($PSVersionTable.PSVersion.Major -ge 7) {
        (& $mise activate pwsh) | Out-String | Invoke-Expression
    }
    & $mise reshim

}
else {
    Write-Warning "mise not found. If it was just installed, restart PowerShell and rerun this script."
}

Install-NpmGlobalPackage "@openai/codex" "codex" "Codex CLI"
Install-NpmGlobalPackage "@fission-ai/openspec@latest" "openspec" "OpenSpec"

#endregion
