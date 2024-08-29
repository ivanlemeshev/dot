Write-Host "Installing JetBrains Mono Nerd fonts..."

Write-Host "Downloading the fonts archive..."

$fontFilename = "JetBrainsMono.zip"
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$fontFilename"
$fontOutputFile = "$scriptDirectory\$fontFilename"

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($fontUrl, $fontOutputFile)
    Write-Host "The fonts archive has been downloaded successfully."
}
catch {
    Write-Host "Error downloading the fonts archive: $($_.Exception.Message)"
}

Write-Host "Unzipping the fonts archive..."

# The variable $scriptDirectory is defined in the parent script.
$destinationFolder = "$scriptDirectory\NerdFonts"
Expand-Archive -Path $fontOutputFile -DestinationPath $destinationFolder -Force

Write-Host "Installing the fonts..."
$fontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)
$tempFontsFolder = "C:\Windows\Temp\Fonts"
New-Item $tempFontsFolder -Type Directory -Force | Out-Null
Get-ChildItem -Path $destinationFolder -Include "*.ttf" -Recurse | ForEach {
    If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
        $font = "$tempFontsFolder\$($_.Name)"
        Copy-Item $($_.FullName) -Destination $tempFontsFolder
        $fontsFolder.CopyHere($font, 0x10)
        Remove-Item $font -Force
    }
}

Write-Host "Cleaning up the downloaded and unzipped files..."
Remove-Item -Path $fontOutputFile -Force
Remove-Item -Path $destinationFolder -Recurse -Force
