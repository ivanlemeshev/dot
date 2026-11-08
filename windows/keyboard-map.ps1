function Test-ByteArrayEqual($left, $right) {
    if ($null -eq $left -or $null -eq $right) {
        return $false
    }

    if ($left.Length -ne $right.Length) {
        return $false
    }

    for ($index = 0; $index -lt $left.Length; $index++) {
        if ($left[$index] -ne $right[$index]) {
            return $false
        }
    }

    return $true
}

function New-ScancodeMap([System.Collections.ArrayList]$mappings) {
    $bytes = New-Object System.Collections.Generic.List[byte]
    $bytes.AddRange([byte[]](0, 0, 0, 0, 0, 0, 0, 0))
    $bytes.AddRange([BitConverter]::GetBytes([UInt32]($mappings.Count + 1)))

    foreach ($mapping in $mappings) {
        $bytes.AddRange([byte[]]$mapping)
    }

    $bytes.AddRange([byte[]](0, 0, 0, 0))
    return [byte[]]$bytes.ToArray()
}

function Get-ScancodeMappings([byte[]]$value) {
    if ($null -eq $value -or $value.Length -lt 16) {
        throw 'Scancode Map value is too short.'
    }

    for ($index = 0; $index -lt 8; $index++) {
        if ($value[$index] -ne 0) {
            throw 'Scancode Map header is not supported.'
        }
    }

    $count = [BitConverter]::ToUInt32($value, 8)
    $expectedLength = 12 + (4 * $count)
    if ($count -lt 1 -or $value.Length -ne $expectedLength) {
        throw 'Scancode Map length does not match its mapping count.'
    }

    $terminatorOffset = 12 + (4 * ($count - 1))
    if (($value[$terminatorOffset] -ne 0) -or
        ($value[$terminatorOffset + 1] -ne 0) -or
        ($value[$terminatorOffset + 2] -ne 0) -or
        ($value[$terminatorOffset + 3] -ne 0)) {
        throw 'Scancode Map terminator is not supported.'
    }

    $mappings = New-Object System.Collections.ArrayList
    for ($index = 0; $index -lt ($count - 1); $index++) {
        $offset = 12 + (4 * $index)
        [void]$mappings.Add([byte[]]@(
                $value[$offset],
                $value[$offset + 1],
                $value[$offset + 2],
                $value[$offset + 3]
            ))
    }

    return ,$mappings
}

function Get-CapsLockScancodeMap([byte[]]$currentValue) {
    $capsLockToCtrl = [byte[]](0x1d, 0, 0x3a, 0)
    if ($null -eq $currentValue) {
        $mappings = New-Object System.Collections.ArrayList
    } else {
        $mappings = Get-ScancodeMappings $currentValue
        foreach ($mapping in $mappings) {
            if (Test-ByteArrayEqual $mapping $capsLockToCtrl) {
                return [byte[]]$currentValue
            }
        }
    }

    $updatedMappings = New-Object System.Collections.ArrayList
    foreach ($mapping in $mappings) {
        if (-not ($mapping[2] -eq 0x3a -and $mapping[3] -eq 0)) {
            [void]$updatedMappings.Add($mapping)
        }
    }
    [void]$updatedMappings.Add($capsLockToCtrl)

    return New-ScancodeMap $updatedMappings
}
