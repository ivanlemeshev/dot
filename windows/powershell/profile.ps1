$env:BAT_THEME = "custom"
$env:RIPGREP_CONFIG_PATH = Join-Path $env:USERPROFILE ".config\ripgrep\config"

if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    $selectionColor = "$([char]27)[30;104m"
    Set-PSReadLineOption -Colors @{
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
        InlinePrediction = [ConsoleColor]::Gray
        ListPrediction = [ConsoleColor]::DarkYellow
        ListPredictionSelected = $selectionColor
        ListPredictionTooltip = [ConsoleColor]::Gray
    }
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

    $miseProfileCommand = Get-Command mise -CommandType Application -ErrorAction SilentlyContinue
    if ($null -ne $miseProfileCommand) {
        (& $miseProfileCommand.Source activate pwsh) | Out-String | Invoke-Expression
    }
}
