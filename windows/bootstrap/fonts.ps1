#region Nerd Fonts Installation

function Install-NerdFonts {
    Write-Host ""
    Write-Host "Checking Nerd Fonts installation..."

    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    $installedFonts = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
    $fontRegistryNames = @()

    if ($null -ne $installedFonts) {
        $fontRegistryNames = @($installedFonts.PSObject.Properties.Name)
    }

    $fonts = @{
        "JetBrainsMono"            = "JetBrainsMono"
        "Iosevka"                  = "Iosevka Nerd Font Mono"
        "IoskeleyMono-NL-NerdFont" = "IoskeleyMonoNL Nerd Font Mono"
    }

    $changed = $false

    foreach ($fontName in $fonts.Keys) {
        $fontFamily = $fonts[$fontName]
        $fontFamilyKey = $fontFamily -replace "[^a-zA-Z0-9]", ""
        $matchingRegistryNames = @($fontRegistryNames | Where-Object {
                ($_ -replace "[^a-zA-Z0-9]", "") -like "$fontFamilyKey*"
            })

        if ($matchingRegistryNames.Count -gt 0) {
            Write-Host "$fontFamily already registered. Skipping..."
            continue
        }

        Write-Host "Installing $fontName Nerd Font..."

        $url = "https://github.com/ryanoasis/nerd-fonts/" +
        "releases/latest/download/$fontName.zip"
        if ($fontName -like "IoskeleyMono-*") {
            $url = "https://github.com/ahatem/IoskeleyMono/" +
            "releases/latest/download/$fontName.zip"
        }
        $zipFile = "$scriptDir\$fontName.zip"

        try {
            Write-Host "Downloading..."
            $web = New-Object System.Net.WebClient
            $web.DownloadFile($url, $zipFile)
            Write-Host "Downloaded successfully."
        }
        catch {
            Write-Host "Error: $($_.Exception.Message)"
            continue
        }

        Write-Host "Extracting fonts..."
        $extractDir = "$scriptDir\NerdFonts"
        Expand-Archive -Path $zipFile `
            -DestinationPath $extractDir -Force

        $fontsFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"

        if (-not (Test-Path $fontsFolder)) {
            New-Item -Path $fontsFolder -ItemType Directory -Force | Out-Null
        }

        $count = 0

        foreach ($ext in @("*.ttf", "*.otf")) {
            Get-ChildItem $extractDir -Include $ext -Recurse |
            ForEach-Object {
                $fontFile = $_.Name
                $fontPath = $_.FullName
                $fontDest = "$fontsFolder\$fontFile"
                $fontBaseName = $_.BaseName
                $registryName = "$fontBaseName (TrueType)"

                if (-not (Test-Path $fontDest)) {
                    Write-Host "Installing $fontFile..."
                    Copy-Item $fontPath -Destination $fontDest -Force
                    $count++
                }

                $registeredFont = Get-ItemProperty -Path $regPath `
                    -Name $registryName -ErrorAction SilentlyContinue
                $registeredPath = $null

                if ($null -ne $registeredFont) {
                    $registeredPath = $registeredFont.PSObject.Properties[$registryName].Value
                }

                if ($registeredPath -ne $fontDest) {
                    try {
                        Write-Host "Registering $fontBaseName..."
                        New-ItemProperty -Path $regPath `
                            -Name $registryName `
                            -PropertyType String `
                            -Value $fontDest `
                            -Force | Out-Null
                        $count++
                    }
                    catch {
                        Write-Host "Warning: Could not register $fontBaseName in registry"
                    }
                }
            }
        }

        Write-Host "Installed or repaired $count font entries."
        Write-Host "Cleaning up..."
        Remove-Item $zipFile -Force -ErrorAction SilentlyContinue
        Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue

        if ($count -gt 0) {
            $changed = $true
        }
    }

    if ($changed) {
        Write-Host "Nerd Fonts installation completed."
    }
    else {
        Write-Host "All fonts already installed."
    }

    return $changed
}

Install-NerdFonts

#endregion
