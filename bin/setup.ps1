# Run as Administrator:
#
# To allow script execution, run PowerShell as Administrator and execute:
# Set-ExecutionPolicy RemoteSigned
#
# To revert to default policy, run as Administrator:
# Set-ExecutionPolicy Restricted

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Split-Path -Parent $scriptDir
Set-Location $scriptDir

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal]`
		[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
	[Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin)
{
	Start-Process powershell.exe `
		"-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
		-Verb RunAs -WorkingDirectory $scriptDir
	exit
}

Write-Host "Current directory: $scriptDir"
Write-Host "Repository root: $repoRoot"
Write-Host "User profile: $env:USERPROFILE"
Write-Host ""

$restartRequired = $false

#region CapsLock Remapping

function Test-ByteArrayEqual($left, $right)
{
	if ($null -eq $left -or $null -eq $right)
	{
		return $false
	}

	if ($left.Length -ne $right.Length)
	{
		return $false
	}

	for ($i = 0; $i -lt $left.Length; $i++)
	{
		if ($left[$i] -ne $right[$i])
		{
			return $false
		}
	}

	return $true
}

function New-ScancodeMap([System.Collections.ArrayList]$mappings)
{
	$bytes = New-Object System.Collections.Generic.List[byte]
	$bytes.AddRange([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00))
	$bytes.AddRange([BitConverter]::GetBytes([UInt32]($mappings.Count + 1)))

	foreach ($mapping in $mappings)
	{
		$bytes.AddRange([byte[]]$mapping)
	}

	$bytes.AddRange([byte[]](0x00,0x00,0x00,0x00))
	return [byte[]]$bytes.ToArray()
}

function Get-ScancodeMappings([byte[]]$value)
{
	if ($null -eq $value -or $value.Length -lt 16)
	{
		throw "Scancode Map value is too short."
	}

	for ($i = 0; $i -lt 8; $i++)
	{
		if ($value[$i] -ne 0)
		{
			throw "Scancode Map header is not supported."
		}
	}

	$count = [BitConverter]::ToUInt32($value, 8)
	$expectedLength = 12 + (4 * $count)

	if ($count -lt 1 -or $value.Length -ne $expectedLength)
	{
		throw "Scancode Map length does not match its mapping count."
	}

	$terminatorOffset = 12 + (4 * ($count - 1))
	if (($value[$terminatorOffset] -ne 0) -or
		($value[$terminatorOffset + 1] -ne 0) -or
		($value[$terminatorOffset + 2] -ne 0) -or
		($value[$terminatorOffset + 3] -ne 0))
	{
		throw "Scancode Map terminator is not supported."
	}

	$mappings = New-Object System.Collections.ArrayList
	for ($i = 0; $i -lt ($count - 1); $i++)
	{
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

function Set-CapsLockAsCtrl
{
	Write-Host "Checking Caps Lock to Left Ctrl mapping..."

	$regPath = "HKLM:\System\CurrentControlSet\Control\Keyboard Layout"
	$regName = "Scancode Map"

	# Remap: 0x3a (Caps Lock) -> 0x1d (Left Ctrl)
	$desiredMapping = [byte[]](0x1d,0x00,0x3a,0x00)
	$mappings = New-Object System.Collections.ArrayList
	[void]$mappings.Add($desiredMapping)
	$value = New-ScancodeMap $mappings

	try
	{
		$current = Get-ItemProperty -Path $regPath -Name $regName `
			-ErrorAction Stop | Select-Object -ExpandProperty $regName

		if (Test-ByteArrayEqual $current $value)
		{
			Write-Host "Caps Lock already mapped. No changes needed."
			return $false
		}

		try
		{
			$currentMappings = Get-ScancodeMappings $current
		} catch
		{
			Write-Warning "Existing keyboard remap is not recognized. Skipping Caps Lock mapping to avoid overwriting it."
			Write-Warning $_.Exception.Message
			return $false
		}

		foreach ($mapping in $currentMappings)
		{
			if (Test-ByteArrayEqual $mapping $desiredMapping)
			{
				Write-Host "Caps Lock already mapped. Existing keyboard remaps preserved."
				return $false
			}
		}

		$updatedMappings = New-Object System.Collections.ArrayList
		foreach ($mapping in $currentMappings)
		{
			# Preserve other mappings, but replace any existing Caps Lock source mapping.
			if (-not ($mapping[2] -eq 0x3a -and $mapping[3] -eq 0x00))
			{
				[void]$updatedMappings.Add($mapping)
			}
		}
		[void]$updatedMappings.Add($desiredMapping)

		$value = New-ScancodeMap $updatedMappings

		Write-Host "Updating Caps Lock mapping..."
		Set-ItemProperty -Path $regPath -Name $regName -Value $value
		Write-Host "Caps Lock mapping updated."
		return $true
	} catch
	{
		Write-Host "Creating Caps Lock mapping..."
		New-ItemProperty -Path $regPath -Name $regName `
			-PropertyType Binary -Value $value | Out-Null
		Write-Host "Caps Lock mapping created."
		return $true
	}
}

if (Set-CapsLockAsCtrl)
{
	$restartRequired = $true
}

#endregion

#region Nerd Fonts Installation

function Install-NerdFonts
{
	Write-Host ""
	Write-Host "Checking Nerd Fonts installation..."

	$regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
	$installedFonts = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
	$fontRegistryNames = @()

	if ($null -ne $installedFonts)
	{
		$fontRegistryNames = @($installedFonts.PSObject.Properties.Name)
	}

	$fonts = @{
		"JetBrainsMono" = "JetBrainsMono"
		"Hack" = "Hack"
	}

	$changed = $false

	foreach ($fontName in $fonts.Keys)
	{
		$matchingRegistryNames = @($fontRegistryNames | Where-Object {
			$_ -match "$fontName.*Nerd"
		})

		if ($matchingRegistryNames.Count -gt 0)
		{
			Write-Host "$fontName Nerd Font already registered. Skipping..."
			continue
		}

		Write-Host "Installing $fontName Nerd Font..."

		$url = "https://github.com/ryanoasis/nerd-fonts/" +
		"releases/latest/download/$fontName.zip"
		$zipFile = "$scriptDir\$fontName.zip"

		try
		{
			Write-Host "Downloading..."
			$web = New-Object System.Net.WebClient
			$web.DownloadFile($url, $zipFile)
			Write-Host "Downloaded successfully."
		} catch
		{
			Write-Host "Error: $($_.Exception.Message)"
			continue
		}

		Write-Host "Extracting fonts..."
		$extractDir = "$scriptDir\NerdFonts"
		Expand-Archive -Path $zipFile `
			-DestinationPath $extractDir -Force

		$fontsFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"

		if (-not (Test-Path $fontsFolder))
		{
			New-Item -Path $fontsFolder -ItemType Directory -Force | Out-Null
		}

		$count = 0

		foreach ($ext in @("*.ttf", "*.otf"))
		{
			Get-ChildItem $extractDir -Include $ext -Recurse |
				ForEach-Object {
					$fontFile = $_.Name
					$fontPath = $_.FullName
					$fontDest = "$fontsFolder\$fontFile"
					$fontBaseName = $_.BaseName
					$registryName = "$fontBaseName (TrueType)"

					if (-not (Test-Path $fontDest))
					{
						Write-Host "Installing $fontFile..."
						Copy-Item $fontPath -Destination $fontDest -Force
						$count++
					}

					$registeredFont = Get-ItemProperty -Path $regPath `
						-Name $registryName -ErrorAction SilentlyContinue
					$registeredPath = $null

					if ($null -ne $registeredFont)
					{
						$registeredPath = $registeredFont.PSObject.Properties[$registryName].Value
					}

					if ($registeredPath -ne $fontDest)
					{
						try
						{
							Write-Host "Registering $fontBaseName..."
							New-ItemProperty -Path $regPath `
								-Name $registryName `
								-PropertyType String `
								-Value $fontDest `
								-Force | Out-Null
							$count++
						} catch
						{
							Write-Host "Warning: Could not register $fontBaseName in registry"
						}
					}
				}
		}

		Write-Host "Installed or repaired $count font entries."
		Write-Host "Cleaning up..."
		Remove-Item $zipFile -Force -ErrorAction SilentlyContinue
		Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue

		if ($count -gt 0)
		{
			$changed = $true
		}
	}

	if ($changed)
	{
		Write-Host "Nerd Fonts installation completed."
	} else
	{
		Write-Host "All fonts already installed."
	}

	return $changed
}

Install-NerdFonts

#endregion

#region Neovim Configuration

Write-Host ""
Write-Host "Setting up Neovim configuration..."

$nvimTarget = "$env:LOCALAPPDATA\nvim"
$nvimSource = "$repoRoot\.config\nvim"

if (-not (Test-Path $nvimSource))
{
	Write-Warning "Neovim config source not found: $nvimSource"
	Write-Warning "Skipping Neovim configuration."
} elseif (Test-Path $nvimTarget)
{
	$nvimTargetItem = Get-Item $nvimTarget
	$existing = $nvimTargetItem.Target

	if ($nvimTargetItem.LinkType -eq "SymbolicLink" -and $existing -eq $nvimSource)
	{
		Write-Host "Neovim configuration already linked."
	} elseif ($nvimTargetItem.LinkType -eq "SymbolicLink")
	{
		Write-Host "Updating Neovim configuration link..."
		Remove-Item $nvimTarget -Force
		New-Item $nvimTarget -ItemType SymbolicLink `
			-Value $nvimSource | Out-Null
		Write-Host "Neovim configuration updated."
	} else
	{
		$backup = "$nvimTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
		Write-Host "Backing up existing Neovim configuration to $backup"
		Move-Item $nvimTarget $backup
		New-Item $nvimTarget -ItemType SymbolicLink `
			-Value $nvimSource | Out-Null
		Write-Host "Neovim configuration created."
	}
} else
{
	Write-Host "Creating Neovim configuration link..."
	New-Item $nvimTarget -ItemType SymbolicLink `
		-Value $nvimSource | Out-Null
	Write-Host "Neovim configuration created."
}

#endregion

#region Windows Terminal Settings

Write-Host ""
Write-Host "Setting up configuration files..."

$term = Get-AppxPackage | Where-Object {
	$_.Name -match "WindowsTerminal"
}

if ($null -eq $term)
{
	Write-Warning "Windows Terminal not found. Skipping..."
} else
{
	$termDir = "$env:LOCALAPPDATA\Packages\" +
	"$($term.PackageFamilyName)\LocalState"
	$target = "$termDir\settings.json"
	$source = "$repoRoot\windows\terminal\settings.json"

	if (-not (Test-Path $termDir))
	{
		New-Item $termDir -ItemType Directory -Force | Out-Null
	}

	if (-not (Test-Path $source))
	{
		Write-Warning "Terminal settings source not found: $source"
		Write-Warning "Skipping Windows Terminal settings."
	} elseif (Test-Path $target)
	{
		$targetItem = Get-Item $target
		$existing = $targetItem.Target

		if ($targetItem.LinkType -eq "SymbolicLink" -and $existing -eq $source)
		{
			Write-Host "Terminal settings already linked."
		} elseif ($targetItem.LinkType -eq "SymbolicLink")
		{
			Write-Host "Updating Terminal settings link..."
			Remove-Item $target -Force
			New-Item $target -ItemType SymbolicLink `
				-Value $source | Out-Null
			Write-Host "Terminal settings updated."
		} else
		{
			$backup = "$target.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
			Write-Host "Backing up existing Terminal settings to $backup"
			Move-Item $target $backup
			New-Item $target -ItemType SymbolicLink `
				-Value $source | Out-Null
			Write-Host "Terminal settings created."
		}
	} else
	{
		Write-Host "Creating Terminal settings link..."
		New-Item $target -ItemType SymbolicLink `
			-Value $source | Out-Null
		Write-Host "Terminal settings created."
	}
}

#endregion

Write-Host ""
Write-Host "Setup completed!"

if ($restartRequired)
{
	Write-Host ""
	Write-Host "Restart required for keyboard mapping."
	Write-Host -NoNewLine `
		"Press any key to restart (or close to restart later)..."
	$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	Restart-Computer
} else
{
	Write-Host ""
	Write-Host "No restart required. All changes applied."
	Write-Host -NoNewLine `
		"Press any key to exit..."
	$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
