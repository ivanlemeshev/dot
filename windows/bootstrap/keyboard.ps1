#region CapsLock Remapping

function Test-ByteArrayEqual($left, $right) {
    if ($null -eq $left -or $null -eq $right) {
        return $false
    }

    if ($left.Length -ne $right.Length) {
        return $false
    }

    for ($i = 0; $i -lt $left.Length; $i++) {
        if ($left[$i] -ne $right[$i]) {
            return $false
        }
    }

    return $true
}

function New-ScancodeMap([System.Collections.ArrayList]$mappings) {
    $bytes = New-Object System.Collections.Generic.List[byte]
    $bytes.AddRange([byte[]](0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
    $bytes.AddRange([BitConverter]::GetBytes([UInt32]($mappings.Count + 1)))

    foreach ($mapping in $mappings) {
        $bytes.AddRange([byte[]]$mapping)
    }

    $bytes.AddRange([byte[]](0x00, 0x00, 0x00, 0x00))
    return [byte[]]$bytes.ToArray()
}

function Get-ScancodeMappings([byte[]]$value) {
    if ($null -eq $value -or $value.Length -lt 16) {
        throw "Scancode Map value is too short."
    }

    for ($i = 0; $i -lt 8; $i++) {
        if ($value[$i] -ne 0) {
            throw "Scancode Map header is not supported."
        }
    }

    $count = [BitConverter]::ToUInt32($value, 8)
    $expectedLength = 12 + (4 * $count)

    if ($count -lt 1 -or $value.Length -ne $expectedLength) {
        throw "Scancode Map length does not match its mapping count."
    }

    $terminatorOffset = 12 + (4 * ($count - 1))
    if (($value[$terminatorOffset] -ne 0) -or
        ($value[$terminatorOffset + 1] -ne 0) -or
        ($value[$terminatorOffset + 2] -ne 0) -or
        ($value[$terminatorOffset + 3] -ne 0)) {
        throw "Scancode Map terminator is not supported."
    }

    $mappings = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt ($count - 1); $i++) {
        $offset = 12 + (4 * $i)
        [void]$mappings.Add([byte[]]@(
                $value[$offset],
                $value[$offset + 1],
                $value[$offset + 2],
                $value[$offset + 3]
            ))
    }

    return $mappings
}

function Set-CapsLockAsCtrl {
    Write-Host "Checking Caps Lock to Left Ctrl mapping..."

    $regPath = "HKLM:\System\CurrentControlSet\Control\Keyboard Layout"
    $regName = "Scancode Map"

    # Remap: 0x3a (Caps Lock) -> 0x1d (Left Ctrl)
    $desiredMapping = [byte[]](0x1d, 0x00, 0x3a, 0x00)
    $mappings = New-Object System.Collections.ArrayList
    [void]$mappings.Add($desiredMapping)
    $value = New-ScancodeMap $mappings

    try {
        $current = Get-ItemProperty -Path $regPath -Name $regName `
            -ErrorAction Stop | Select-Object -ExpandProperty $regName

        if (Test-ByteArrayEqual $current $value) {
            Write-Host "Caps Lock already mapped. No changes needed."
            return $false
        }

        try {
            $currentMappings = Get-ScancodeMappings $current
        }
        catch {
            Write-Warning "Existing keyboard remap is not recognized. Skipping Caps Lock mapping to avoid overwriting it."
            Write-Warning $_.Exception.Message
            return $false
        }

        foreach ($mapping in $currentMappings) {
            if (Test-ByteArrayEqual $mapping $desiredMapping) {
                Write-Host "Caps Lock already mapped. Existing keyboard remaps preserved."
                return $false
            }
        }

        $updatedMappings = New-Object System.Collections.ArrayList
        foreach ($mapping in $currentMappings) {
            # Preserve other mappings, but replace any existing Caps Lock source mapping.
            if (-not ($mapping[2] -eq 0x3a -and $mapping[3] -eq 0x00)) {
                [void]$updatedMappings.Add($mapping)
            }
        }
        [void]$updatedMappings.Add($desiredMapping)

        $value = New-ScancodeMap $updatedMappings

        Write-Host "Updating Caps Lock mapping..."
        Set-ItemProperty -Path $regPath -Name $regName -Value $value
        Write-Host "Caps Lock mapping updated."
        return $true
    }
    catch {
        Write-Host "Creating Caps Lock mapping..."
        New-ItemProperty -Path $regPath -Name $regName `
            -PropertyType Binary -Value $value | Out-Null
        Write-Host "Caps Lock mapping created."
        return $true
    }
}

if (Set-CapsLockAsCtrl) {
    $restartRequired = $true
}

#endregion
