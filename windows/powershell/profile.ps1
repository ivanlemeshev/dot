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
        $PSStyle.FileInfo.Directory = $PSStyle.Background.White +
        $PSStyle.Foreground.Black + $PSStyle.Bold
    }

    $miseProfileCommand = Get-Command mise -CommandType Application -ErrorAction SilentlyContinue
    if ($null -ne $miseProfileCommand) {
        (& $miseProfileCommand.Source activate pwsh) | Out-String | Invoke-Expression
    }
}
