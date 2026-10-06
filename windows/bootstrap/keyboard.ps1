function Set-CapsLockAsCtrl {
    Write-Host 'Checking Caps Lock to Left Ctrl mapping...'

    $regPath = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout'
    $regName = 'Scancode Map'
    $registryKey = Get-Item -LiteralPath $regPath -ErrorAction Stop
    $currentValue = $registryKey.GetValue($regName, $null)

    try {
        $updatedValue = Get-CapsLockScancodeMap $currentValue
    } catch {
        Write-Warning 'Existing keyboard remap is not recognized. Skipping Caps Lock mapping to avoid overwriting it.'
        Write-Warning $_.Exception.Message
        return $false
    }

    if (Test-ByteArrayEqual $currentValue $updatedValue) {
        Write-Host 'Caps Lock already mapped. No changes needed.'
        return $false
    }

    try {
        if ($null -eq $currentValue) {
            New-ItemProperty -LiteralPath $regPath -Name $regName `
                -PropertyType Binary -Value $updatedValue -ErrorAction Stop |
                Out-Null
            Write-Host 'Caps Lock mapping created.'
        } else {
            Set-ItemProperty -LiteralPath $regPath -Name $regName `
                -Value $updatedValue -ErrorAction Stop
            Write-Host 'Caps Lock mapping updated.'
        }

        return $true
    } catch {
        Write-Warning "Caps Lock mapping could not be saved: $($_.Exception.Message)"
        return $false
    }
}

if (Set-CapsLockAsCtrl) {
    $restartRequired = $true
}
