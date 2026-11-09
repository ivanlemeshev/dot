. (Join-Path $PSScriptRoot 'keyboard-map.ps1')

function Set-CapsLockMapping {
    $path = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout'
    $current = (Get-Item -LiteralPath $path).GetValue('Scancode Map', $null)
    $updated = [byte[]](Get-CapsLockScancodeMap $current)
    if (Test-ByteArrayEqual $current $updated) { return }
    $statePath = Join-Path $StateDirectory 'keyboard.json'
    if (-not (Test-Path -LiteralPath $statePath)) {
        $state = @{
            previous = if ($null -eq $current) { $null } else { [Convert]::ToBase64String($current) }
            applied  = [Convert]::ToBase64String($updated)
        }
        Save-StateText 'keyboard.json' ($state | ConvertTo-Json)
    }
    New-ItemProperty -LiteralPath $path -Name 'Scancode Map' -PropertyType Binary -Value $updated -Force | Out-Null
    Write-Host 'Caps Lock maps to Ctrl. Restart Windows to apply the change.'
}

function Restore-CapsLockMapping {
    $statePath = Join-Path $StateDirectory 'keyboard.json'
    if (-not (Test-Path -LiteralPath $statePath)) { return }
    $state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    $path = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout'
    $current = (Get-Item -LiteralPath $path).GetValue('Scancode Map', $null)
    if (-not (Test-ByteArrayEqual $current ([Convert]::FromBase64String($state.applied)))) {
        throw 'The keyboard map changes after setup. Keep the current map and review keyboard.json.'
    }
    if ($null -eq $state.previous) {
        Remove-ItemProperty -LiteralPath $path -Name 'Scancode Map'
    } else {
        Set-ItemProperty -LiteralPath $path -Name 'Scancode Map' -Value ([Convert]::FromBase64String($state.previous))
    }
    Remove-Item -LiteralPath $statePath
    Write-Host 'The previous keyboard map is restored. Restart Windows to apply it.'
}
