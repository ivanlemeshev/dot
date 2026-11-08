$env:HOME = $HOME
$env:DOTFILES_DOCUMENTS = [Environment]::GetFolderPath('MyDocuments')
if (-not $env:DOTFILES_DOCUMENTS) { $env:DOTFILES_DOCUMENTS = Join-Path $HOME 'Documents' }
$env:BAT_CONFIG_DIR = Join-Path $HOME ".config/bat"
$env:PATH = "$(Join-Path $HOME '.local/bin');$(Join-Path $HOME '.julia/bin');$env:PATH"

$env:BAT_THEME = "custom"
$env:RIPGREP_CONFIG_PATH = Join-Path $env:USERPROFILE ".config\ripgrep\config"

if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    $selectionColor = "$([char]27)[30;104m"
    $readLineColors = @{
        ContinuationPrompt = [ConsoleColor]::Gray
        Default = [ConsoleColor]::White
        Comment = [ConsoleColor]::Gray
        Keyword = [ConsoleColor]::DarkYellow
        String = [ConsoleColor]::Yellow
        Operator = [ConsoleColor]::DarkCyan
        Variable = [ConsoleColor]::White
        Command = [ConsoleColor]::DarkGreen
        Parameter = [ConsoleColor]::Blue
        Type = [ConsoleColor]::Blue
        Number = [ConsoleColor]::Magenta
        Member = [ConsoleColor]::White
        Emphasis = [ConsoleColor]::Yellow
        Error = [ConsoleColor]::Red
        Selection = $selectionColor
    }
    if ((Get-Module PSReadLine).Version -ge [version]'2.2.0') {
        $readLineColors.InlinePrediction = [ConsoleColor]::Gray
        $readLineColors.ListPrediction = [ConsoleColor]::DarkYellow
        $readLineColors.ListPredictionSelected = $selectionColor
        $readLineColors.ListPredictionTooltip = [ConsoleColor]::Gray
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
        $PSStyle.FileInfo.Directory = $PSStyle.Foreground.BrightBlue
        $PSStyle.FileInfo.SymbolicLink = $PSStyle.Foreground.Cyan
        $PSStyle.FileInfo.Executable = $PSStyle.Foreground.Green
        foreach ($extension in @($PSStyle.FileInfo.Extension.Keys)) {
            $PSStyle.FileInfo.Extension[$extension] = $PSStyle.Foreground.Yellow
        }
        $formatColors = @{
            FormatAccent = $PSStyle.Foreground.White
            TableHeader = $PSStyle.Foreground.White
            CustomTableHeaderLabel = $PSStyle.Foreground.White
            ErrorAccent = $PSStyle.Foreground.Cyan
            Error = $PSStyle.Foreground.BrightRed
            Warning = $PSStyle.Foreground.Yellow
            Verbose = $PSStyle.Foreground.Yellow
            Debug = $PSStyle.Foreground.Yellow
            FeedbackName = $PSStyle.Foreground.White
            FeedbackText = $PSStyle.Foreground.White
            FeedbackAction = $PSStyle.Foreground.BrightWhite
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
