[CmdletBinding()]
param(
    [ValidateSet('list', 'current', 'use', 'prepare')]
    [string]$Action = 'list',
    [string]$Name
)

$ErrorActionPreference = 'Stop'

function Get-PaletteStateDirectory {
    if ($env:DOTFILES_PALETTE_STATE) {
        return [IO.Path]::GetFullPath($env:DOTFILES_PALETTE_STATE)
    }
    return Join-Path $HOME '.local/state/dotfiles-palette'
}

function Get-PaletteName {
    $selection = Join-Path (Get-PaletteStateDirectory) 'selection'
    if (Test-Path -LiteralPath $selection) {
        return ([IO.File]::ReadAllText($selection)).Trim()
    }
    return 'charcoal-pastel'
}

function Get-PaletteDirectory([string]$PaletteName) {
    if ($PaletteName -cnotmatch '^[a-z][a-z0-9-]*$') {
        throw "Invalid palette name: $PaletteName"
    }
    $directory = Join-Path (Split-Path -Parent $PSScriptRoot) "palettes/$PaletteName"
    foreach ($file in @('ghostty', 'konsole.colorscheme', 'iterm2.json', 'windows-terminal.json')) {
        if (-not (Test-Path -LiteralPath (Join-Path $directory $file) -PathType Leaf)) {
            throw "Palette is missing or incomplete: $PaletteName"
        }
    }
    return $directory
}

function Set-PaletteLink([string]$Path, [string]$Target) {
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if ($null -ne $item) {
        if ($item.LinkType -ne 'SymbolicLink') {
            throw "The palette link path contains another file: $Path"
        }
        if (@($item.Target)[0] -eq $Target) { return }
        Remove-Item -LiteralPath $Path -Force
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $Path) -Force | Out-Null
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target | Out-Null
}

function Set-UnixPalette([string]$Directory) {
    $state = Get-PaletteStateDirectory
    $root = Split-Path -Parent $PSScriptRoot
    Set-PaletteLink (Join-Path $state 'ghostty/config') (Join-Path $root 'ghostty/config')
    Set-PaletteLink (Join-Path $state 'ghostty/themes/custom') (Join-Path $state 'active/ghostty')
    Set-PaletteLink (Join-Path $state 'active') $Directory
}

function Invoke-Palette {
    param([string]$Command, [string]$PaletteName)
    if ($Command -ne 'use' -and $PaletteName) {
        throw 'Only use accepts a palette name.'
    }
    $current = Get-PaletteName
    $currentDirectory = Get-PaletteDirectory $current
    switch ($Command) {
        'list' {
            Get-ChildItem -LiteralPath (Split-Path -Parent $currentDirectory) -Directory |
                Sort-Object Name | ForEach-Object {
                    $marker = if ($_.Name -eq $current) { '*' } else { ' ' }
                    "$marker $($_.Name)"
                }
        }
        'current' { $current }
        { $_ -in 'use', 'prepare' } {
            $selected = if ($Command -eq 'prepare') { $current } else { $PaletteName }
            $directory = Get-PaletteDirectory $selected
            $windows = [Environment]::OSVersion.Platform -eq [PlatformID]::Win32NT
            $state = Get-PaletteStateDirectory
            New-Item -ItemType Directory -Path $state -Force | Out-Null
            try {
                if ($windows) {
                    if ($Command -eq 'use') {
                        $root = Split-Path -Parent $PSScriptRoot
                        . (Join-Path $root 'windows/helpers.ps1')
                        . (Join-Path $root 'windows/terminal.ps1')
                        $terminal = Get-WindowsTerminalSettingsDirectory
                        if ($null -eq $terminal) { throw 'Windows Terminal settings directory is unavailable.' }
                        Set-WindowsTerminalSettings $terminal (Join-Path $root 'windows/terminal/settings.json') -ThemesOnly -PaletteName $selected
                    }
                } else {
                    Set-UnixPalette $directory
                }
                $selection = Join-Path $state 'selection'
                if (-not (Test-Path -LiteralPath $selection) -or [IO.File]::ReadAllText($selection) -cne "$selected`n") {
                    [IO.File]::WriteAllText($selection, "$selected`n", [Text.UTF8Encoding]::new($false))
                }
            } catch {
                if (-not $windows) { Set-UnixPalette $currentDirectory }
                throw
            }
            if ($Command -eq 'use') {
                Write-Output "Palette: $selected. Reload or restart the terminal."
            }
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-Palette $Action $Name
}
