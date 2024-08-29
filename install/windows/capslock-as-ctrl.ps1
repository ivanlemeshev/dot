# This script remaps Caps Lock to Left Ctrl using the Windows registry.
# It requires rebooting the system to take effect.

Write-Host "Remapping Caps Lock to Left Ctrl..."

$registryPath = "HKLM:\System\CurrentControlSet\Control\Keyboard Layout"
$propertyName = "Scancode Map"

# 0x02 -> One key to remap
# 0x1d -> Left Ctrl
# 0x3a -> Caps Lock
$propertyValue = 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x1d, 0x00, 0x3a, 0x00, 0x00, 0x00, 0x00, 0x00

try {
    Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction Stop

    Write-Host "Property exists. Modifying existing property..."
    Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue
}
catch {
    Write-Host "Property does not exist. Creating new property..."
    New-ItemProperty -Path $registryPath -Name $propertyName -PropertyType Binary -Value $propertyValue
}
