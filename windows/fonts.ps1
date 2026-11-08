function Install-NerdFont {
    $registryPath = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    $fontDirectory = Join-Path $env:LOCALAPPDATA 'Microsoft/Windows/Fonts'
    $regularFont = Join-Path $fontDirectory 'JetBrainsMonoNLNerdFontMono-Regular.ttf'
    $registryName = 'JetBrainsMonoNLNerdFontMono-Regular (TrueType)'
    $registered = Get-ItemProperty -LiteralPath $registryPath -Name $registryName -ErrorAction SilentlyContinue
    if ((Test-Path -LiteralPath $regularFont) -and $null -ne $registered -and
        $registered.PSObject.Properties[$registryName].Value -eq $regularFont) { return }

    $temporary = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $temporary -Force | Out-Null
    try {
        $archive = Join-Path $temporary 'JetBrainsMono.zip'
        Invoke-WebRequest 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip' -OutFile $archive
        Expand-Archive -LiteralPath $archive -DestinationPath (Join-Path $temporary 'fonts')
        New-Item -ItemType Directory -Path $fontDirectory -Force | Out-Null
        if (-not (Test-Path -LiteralPath $registryPath)) { New-Item -Path $registryPath | Out-Null }
        foreach ($font in Get-ChildItem (Join-Path $temporary 'fonts') -Recurse -Filter '*.ttf') {
            $target = Join-Path $fontDirectory $font.Name
            Copy-Item -LiteralPath $font.FullName -Destination $target -Force
            New-ItemProperty -LiteralPath $registryPath -Name "$($font.BaseName) (TrueType)" -PropertyType String -Value $target -Force | Out-Null
        }
        if (-not (Test-Path -LiteralPath $regularFont)) { throw 'The configured Nerd Font is missing from the archive.' }
    } finally {
        Remove-Item -LiteralPath $temporary -Recurse -Force
    }
    Write-Host 'The Nerd Font is installed. Open a new terminal to load it.'
}
