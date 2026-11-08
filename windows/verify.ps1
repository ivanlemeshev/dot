$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'helpers.ps1')
. (Join-Path $PSScriptRoot 'toolchains.ps1')
. (Join-Path $PSScriptRoot 'keyboard-map.ps1')
. (Join-Path $PSScriptRoot 'terminal.ps1')
Assert-Windows
Update-ProcessPath
Assert-WindowsMsys2
Assert-EditorVersions
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
if (-not (Test-Path -LiteralPath $vswhere)) { throw 'Visual Studio Build Tools is missing.' }
$compiler = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if ($LASTEXITCODE -ne 0 -or -not $compiler) { throw 'The Microsoft C++ compiler component is missing.' }
$mise = Find-Mise
if ($null -eq $mise) { throw 'The mise command is missing.' }
Invoke-Checked $mise @('bootstrap', 'packages', 'status', '--missing')
Invoke-Checked $mise @('dot', 'status', '--missing')
foreach ($tool in @('go', 'golangci-lint', 'julia', 'node', 'pnpm', 'python', 'rust', 'uv', 'zig')) {
    Invoke-Checked $mise @('where', $tool)
}
foreach ($command in @('git', 'gh', 'code', 'pwsh', 'nvim', 'bat', 'rg', 'fd', 'fzf', 'tree-sitter', 'psmux', 'git-wt', 'oh-my-posh', 'ffmpeg', 'yt-dlp', 'jq', 'less', 'lua', 'luarocks', 'gcc', 'gdb', 'clang', 'clang-format', 'clang-tidy', 'clangd', 'cmake', 'grpcurl', 'runic', 'codex', 'claude')) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) { throw "Required command is missing: $command" }
}
Invoke-Checked $mise @('exec', '--', 'node', '--version')
Invoke-Checked $mise @('exec', '--', 'python', '--version')
Invoke-Checked $mise @('exec', '--', 'go', 'version')
Invoke-Checked $mise @('exec', '--', 'rustc', '--version')
Invoke-Checked lua @('-v')
Invoke-Checked luarocks @('--version')
Invoke-Checked gcc @('--version')
Invoke-Checked clang-format @('--version')
Invoke-Checked ffmpeg @('-version')
Invoke-Checked ffprobe @('-version')
Invoke-Checked pwsh @('-NoProfile', '-Command', '$PSVersionTable.PSVersion.ToString()')
Invoke-Checked nvim @('--version')
Invoke-Checked tree-sitter @('--version')
Invoke-Checked psmux @('-V')
$extensions = @(& code --list-extensions)
if ($LASTEXITCODE -ne 0) { throw 'The VS Code extension list is unavailable.' }
foreach ($extension in Get-RequiredVSCodeExtensions) {
    if ($extensions -notcontains $extension) { throw "Required VS Code extension is missing: $extension" }
}
Invoke-Checked git-wt @('--version')
Invoke-Checked grpcurl @('-version')
Invoke-Checked runic @('--help')
Invoke-Checked codex @('--version')
Invoke-Checked claude @('--version')
if ($env:BAT_THEME -ne 'custom' -or $env:GH_ACCESSIBLE_COLORS -ne '1' -or (Test-Path Env:NO_COLOR) -or (Test-Path Env:GH_COLOR_LABELS)) {
    throw 'The activated terminal color environment is invalid.'
}
if (@(& bat --list-themes) -notcontains 'custom') { throw 'The custom bat theme is missing.' }
if ((& git config --get color.diff.old) -ne 'brightred') { throw 'Git does not load the shared color roles.' }
if (-not ((& gh help environment | Out-String).Contains('GH_ACCESSIBLE_COLORS'))) { throw 'GitHub CLI does not support accessible colors.' }
if (-not $env:FZF_DEFAULT_OPTS.StartsWith('--color=16,')) { throw 'fzf does not use the ANSI palette.' }
$map = (Get-Item 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout').GetValue('Scancode Map', $null)
if ($null -eq $map -or -not (Test-ByteArrayEqual $map ([byte[]](Get-CapsLockScancodeMap $map)))) { throw 'Caps Lock does not map to Ctrl.' }
$font = Join-Path $env:LOCALAPPDATA 'Microsoft/Windows/Fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf'
if (-not (Test-Path -LiteralPath $font)) { throw 'The configured Nerd Font is missing.' }
$terminalDirectory = Get-WindowsTerminalSettingsDirectory
if ($null -eq $terminalDirectory) { throw 'Windows Terminal is missing.' }
$terminal = Get-Content (Join-Path $terminalDirectory 'settings.json') -Raw | ConvertFrom-Json
$shared = Get-Content (Join-Path $PSScriptRoot 'terminal/settings.json') -Raw | ConvertFrom-Json
$scheme = @($terminal.schemes | Where-Object name -eq 'custom')
if ($scheme.Count -ne 1) { throw 'The custom Windows Terminal palette is missing or duplicated.' }
foreach ($property in $shared.schemes[0].PSObject.Properties) {
    if ($scheme[0].PSObject.Properties[$property.Name].Value -ne $property.Value) { throw "Windows Terminal palette differs: $($property.Name)" }
}
$env:MISE_NVIM_VERIFY = '1'
try {
    Invoke-Checked nvim @('--headless', '-u', 'NONE', '-l', (Join-Path $MiseRoot 'nvim/bootstrap.lua'))
} finally { Remove-Item Env:MISE_NVIM_VERIFY -ErrorAction SilentlyContinue }
Write-Host 'Windows tools, links, keyboard mapping, colors, and Neovim checks pass.'
