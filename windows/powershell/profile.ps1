[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Shell tools supply initialization code for this process.')]
param()

$env:HOME = $HOME
$env:MISE_STATE_DIR = Join-Path $env:LOCALAPPDATA 'mise/state'
$env:DOTFILES_DOCUMENTS = [Environment]::GetFolderPath('MyDocuments')
if (-not $env:DOTFILES_DOCUMENTS) { $env:DOTFILES_DOCUMENTS = Join-Path $HOME 'Documents' }
$env:BAT_CONFIG_DIR = Join-Path $HOME ".config/bat"
$env:PATH = "$(Join-Path $HOME '.local/bin');$(Join-Path $HOME '.julia/bin');$env:PATH"

$env:BAT_THEME = "custom"
$env:RIPGREP_CONFIG_PATH = Join-Path $env:USERPROFILE ".config\ripgrep\config"
$paletteState = if ($env:DOTFILES_PALETTE_STATE) { $env:DOTFILES_PALETTE_STATE } else { Join-Path $HOME '.local/state/dotfiles-palette' }
$modePath = Join-Path $paletteState 'mode'
$env:DOTFILES_HIGHLIGHT_MODE = 'full'
$minimalHighlight = (Test-Path -LiteralPath $modePath -PathType Leaf) -and ([IO.File]::ReadAllText($modePath)).Trim() -ceq 'min'
if ($minimalHighlight) {
    $env:DOTFILES_HIGHLIGHT_MODE = 'min'
    $env:BAT_THEME = 'custom-min'
    $env:RIPGREP_CONFIG_PATH = Join-Path $env:USERPROFILE '.config/ripgrep/config-min'
}

if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    $selectionFg = 0
    $selectionBg = 8
    $statusFallback = '-'
    $profileItem = Get-Item -LiteralPath $PSCommandPath
    $profileSource = $profileItem
    if ($profileItem.Target) {
        $profileTarget = [string]@($profileItem.Target)[0]
        if (-not [IO.Path]::IsPathRooted($profileTarget)) {
            $profileTarget = Join-Path $profileItem.DirectoryName $profileTarget
        }
        $profileSource = Get-Item -LiteralPath $profileTarget
    }
    $rolesPath = Join-Path $profileSource.Directory.Parent.Parent.FullName 'palettes/color-roles.txt'
    $selectionPath = Join-Path $paletteState 'selection'
    if ((Test-Path -LiteralPath $rolesPath) -and (Test-Path -LiteralPath $selectionPath)) {
        $paletteName = ([IO.File]::ReadAllText($selectionPath)).Trim()
        foreach ($role in Get-Content -LiteralPath $rolesPath) {
            $name, $fg, $bg, $fallback = $role -split ' '
            if ($name -ceq $paletteName) {
                $selectionFg = $fg
                $selectionBg = $bg
                $statusFallback = $fallback
                break
            }
        }
    }
    $env:DOTFILES_SELECTION_FG = $selectionFg
    $env:DOTFILES_SELECTION_BG = $selectionBg
    $env:DOTFILES_STATUS_FG = if (($statusFallback -split ',') -contains '3') { 'brightwhite' } else { 'yellow' }
    $selectionColor = "$([char]27)[0;38;5;$selectionFg;48;5;${selectionBg}m"
    $readLineColors = @{
        ContinuationPrompt = [ConsoleColor]::DarkGray
        Default            = [ConsoleColor]::Gray
        Comment            = [ConsoleColor]::DarkGray
        Keyword            = [ConsoleColor]::DarkRed
        String             = [ConsoleColor]::DarkGreen
        Operator           = [ConsoleColor]::DarkCyan
        Variable           = [ConsoleColor]::Gray
        Command            = [ConsoleColor]::DarkYellow
        Parameter          = [ConsoleColor]::Gray
        Type               = [ConsoleColor]::DarkBlue
        Number             = [ConsoleColor]::DarkMagenta
        Member             = [ConsoleColor]::DarkBlue
        Emphasis           = [ConsoleColor]::DarkYellow
        Error              = [ConsoleColor]::Red
        Selection          = $selectionColor
    }
    if ((Get-Module PSReadLine).Version -ge [version]'2.2.0') {
        $readLineColors.InlinePrediction = [ConsoleColor]::DarkGray
        $readLineColors.ListPrediction = [ConsoleColor]::DarkYellow
        $readLineColors.ListPredictionSelected = $selectionColor
        $readLineColors.ListPredictionTooltip = [ConsoleColor]::DarkGray
    }
    if ($minimalHighlight) {
        foreach ($role in @('Keyword', 'Operator', 'Type', 'Number', 'Member')) {
            $readLineColors[$role] = [ConsoleColor]::Gray
        }
    }
    Set-PSReadLineOption -Colors $readLineColors
}

if ($Host.Name -eq "ConsoleHost" -and -not [Console]::IsOutputRedirected) {
    [Console]::Write("$([char]27)[2 q")
}

$ytDlpProfile = Join-Path $env:USERPROFILE ".config\powershell\yt-dlp.ps1"
if (Test-Path $ytDlpProfile) {
    . $ytDlpProfile
}

if (Test-Path "C:\msys64\ucrt64\bin") {
    $msysUcrtBin = "C:\msys64\ucrt64\bin"
    if (($env:PATH -split ";") -notcontains $msysUcrtBin) {
        $env:PATH = "$msysUcrtBin;$env:PATH"
    }
}

if ($PSVersionTable.PSVersion.Major -ge 7) {
    if ($null -ne $PSStyle) {
        $PSStyle.FileInfo.Directory = $PSStyle.Foreground.Blue
        $PSStyle.FileInfo.SymbolicLink = $PSStyle.Foreground.Cyan
        $PSStyle.FileInfo.Executable = $PSStyle.Foreground.Green
        $extensionColor = $PSStyle.Foreground.Yellow
        if ($minimalHighlight) {
            $PSStyle.FileInfo.SymbolicLink = $PSStyle.Foreground.White
            $PSStyle.FileInfo.Executable = $PSStyle.Foreground.White
            $extensionColor = $PSStyle.Foreground.White
        }
        foreach ($extension in @($PSStyle.FileInfo.Extension.Keys)) {
            $PSStyle.FileInfo.Extension[$extension] = $extensionColor
        }
        $formatColors = @{
            FormatAccent           = $PSStyle.Foreground.White
            TableHeader            = $PSStyle.Foreground.White
            CustomTableHeaderLabel = $PSStyle.Foreground.White
            ErrorAccent            = $PSStyle.Foreground.Cyan
            Error                  = $PSStyle.Foreground.BrightRed
            Warning                = $PSStyle.Foreground.BrightYellow
            Verbose                = $PSStyle.Foreground.Yellow
            Debug                  = $PSStyle.Foreground.Yellow
            FeedbackName           = $PSStyle.Foreground.White
            FeedbackText           = $PSStyle.Foreground.White
            FeedbackAction         = $PSStyle.Foreground.Yellow
        }
        foreach ($formatColor in $formatColors.GetEnumerator()) {
            if ($null -ne $PSStyle.Formatting.PSObject.Properties[$formatColor.Key]) {
                $PSStyle.Formatting.($formatColor.Key) = $formatColor.Value
            }
        }
    }

    $miseProfileCommand = Get-Command mise -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $miseProfileCommand) {
        (& $miseProfileCommand.Source activate pwsh) | Out-String | Invoke-Expression
    }
}

if ($PSVersionTable.PSVersion.Major -ge 7 -and [Environment]::UserInteractive -and -not [Console]::IsOutputRedirected) {
    $worktrunk = Get-Command git-wt -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $worktrunk) {
        (& $worktrunk.Source config shell init powershell --cmd git-wt) | Out-String | Invoke-Expression
    }
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        oh-my-posh init pwsh --config (Join-Path $HOME '.config/oh-my-posh/theme.omp.json') | Out-String | Invoke-Expression
    }
}
