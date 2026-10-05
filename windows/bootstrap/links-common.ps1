function Resolve-DotfilesPath($path) {
    return [System.IO.Path]::GetFullPath($path).TrimEnd('\')
}

function Set-DotfilesLink($source, $target, $name) {
    if (-not (Test-Path -LiteralPath $source)) {
        Write-Warning "$name source not found: $source"
        return
    }

    $parent = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -Path $parent -ItemType Directory -Force | Out-Null
    }

    $targetItem = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if ($null -ne $targetItem) {
        if ($targetItem.LinkType -in @('SymbolicLink', 'Junction')) {
            $existingTarget = @($targetItem.Target)[0]
            if ((Resolve-DotfilesPath $existingTarget) -eq
                (Resolve-DotfilesPath $source)) {
                Write-Host "$name already linked."
                return
            }

            Write-Host "Updating $name link..."
            Remove-Item -LiteralPath $target -Force
        } else {
            $backup = "$target.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Host "Backing up existing $name to $backup"
            Move-Item -LiteralPath $target -Destination $backup
        }
    }

    New-Item -Path $target -ItemType SymbolicLink -Value $source | Out-Null
    Write-Host "$name linked."
}
