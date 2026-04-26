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
	$pwshExe = Join-Path $PSHOME 'pwsh.exe'
	$relaunchExe = if (Test-Path $pwshExe)
	{ $pwshExe
 } else
	{ "powershell.exe"
 }

	Start-Process $relaunchExe `
		"-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
		-Verb RunAs -WorkingDirectory $scriptDir
	exit
}

Write-Host "Current directory: $scriptDir"
Write-Host "Repository root: $repoRoot"
Write-Host "User profile: $env:USERPROFILE"
Write-Host ""

$restartRequired = $false

#region Package Installation

function Install-WingetPackage($id, $name)
{
	if (-not (Get-Command winget -ErrorAction SilentlyContinue))
	{
		Write-Warning "winget not found. Skipping $name."
		return $false
	}

	Write-Host "Checking $name..."
	$null = winget list --id $id --exact --source winget `
		--accept-source-agreements 2>$null

	if ($LASTEXITCODE -eq 0)
	{
		Write-Host "$name already installed. Checking for updates..."
		winget upgrade --id $id --exact --source winget `
			--accept-package-agreements --accept-source-agreements

		if ($LASTEXITCODE -eq 0)
		{
			Write-Host "$name updated or already current."
			return $true
		}

		Write-Warning "Failed to update $name."
		return $false
	}

	Write-Host "Installing $name..."
	winget install --id $id --exact --source winget `
		--accept-package-agreements --accept-source-agreements

	if ($LASTEXITCODE -ne 0)
	{
		Write-Warning "Failed to install $name."
		return $false
	}

	Write-Host "$name installed."
	return $true
}

function Get-MiseCommand
{
	$command = Get-Command mise -ErrorAction SilentlyContinue
	if ($null -ne $command)
	{
		return $command.Source
	}

	$candidates = @(
		"$env:LOCALAPPDATA\Microsoft\WinGet\Links\mise.exe",
		"$env:LOCALAPPDATA\mise\bin\mise.exe",
		"$env:ProgramFiles\mise\bin\mise.exe",
		"$env:ProgramFiles\mise\mise.exe"
	)

	foreach ($candidate in $candidates)
	{
		if (Test-Path $candidate)
		{
			return $candidate
		}
	}

	return $null
}

function Get-MiseToolVersion($configFile, $tool)
{
	if (-not (Test-Path $configFile))
	{
		return $null
	}

	$pattern = "^\s*$([regex]::Escape($tool))\s*=\s*`"([^`"]+)`""
	$line = Get-Content $configFile | Where-Object {
		$_ -match $pattern
	} | Select-Object -First 1

	if ($null -eq $line)
	{
		return $null
	}

	return [regex]::Match($line, $pattern).Groups[1].Value
}

function Install-NpmGlobalPackage($package, $commandName, $name)
{
	if (Get-Command $commandName -ErrorAction SilentlyContinue)
	{
		Write-Host "$name already installed. Updating..."
	} else
	{
		Write-Host "Installing $name..."
	}

	if (Get-Command npm -ErrorAction SilentlyContinue)
	{
		npm install -g $package
	} else
	{
		$mise = Get-MiseCommand
		if ($null -eq $mise)
		{
			Write-Warning "npm and mise not found. Skipping $name."
			Write-Warning "If mise was just installed, restart PowerShell and rerun this script."
			return $false
		}

		Write-Host "Using mise-provided npm for $name..."
		$nodeVersion = Get-MiseToolVersion "$repoRoot\.config\mise\config.toml" "node"

		if ($null -eq $nodeVersion)
		{
			Write-Warning "Node.js version not found in mise config. Skipping $name."
			return $false
		}

		& $mise --yes --no-config exec "node@$nodeVersion" -- npm install -g $package
	}

	if ($LASTEXITCODE -ne 0)
	{
		Write-Warning "Failed to install $name."
		return $false
	}

	Write-Host "$name installed."
	return $true
}

Write-Host "Checking Windows packages..."

Install-WingetPackage "Git.Git" "Git"
Install-WingetPackage "GitHub.cli" "GitHub CLI"
Install-WingetPackage "Neovim.Neovim" "Neovim"
Install-WingetPackage "Microsoft.PowerShell" "PowerShell 7"
Install-WingetPackage "jdx.mise" "mise"
Install-WingetPackage "BurntSushi.ripgrep.MSVC" "ripgrep"
Install-WingetPackage "sharkdp.fd" "fd"
Install-WingetPackage "marlocarlo.psmux" "psmux"

#endregion

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

#region mise Configuration

function Add-LineIfMissing($path, $line)
{
	$parent = Split-Path -Parent $path

	if (-not (Test-Path $parent))
	{
		New-Item $parent -ItemType Directory -Force | Out-Null
	}

	if (-not (Test-Path $path))
	{
		New-Item $path -ItemType File -Force | Out-Null
	}

	$content = Get-Content $path -ErrorAction SilentlyContinue
	if ($content -contains $line)
	{
		return $false
	}

	Add-Content -Path $path -Value $line
	return $true
}

Write-Host ""
Write-Host "Setting up mise configuration..."

$miseTargetDir = "$env:USERPROFILE\.config\mise"
$miseSourceDir = "$repoRoot\.config\mise"

if (-not (Test-Path $miseSourceDir))
{
	Write-Warning "mise config source not found: $miseSourceDir"
	Write-Warning "Skipping mise configuration."
} elseif (Test-Path $miseTargetDir)
{
	$miseTargetItem = Get-Item $miseTargetDir
	$existing = $miseTargetItem.Target

	if ($miseTargetItem.LinkType -eq "SymbolicLink" -and $existing -eq $miseSourceDir)
	{
		Write-Host "mise configuration already linked."
	} elseif ($miseTargetItem.LinkType -eq "SymbolicLink")
	{
		Write-Host "Updating mise configuration link..."
		Remove-Item $miseTargetDir -Force
		New-Item $miseTargetDir -ItemType SymbolicLink `
			-Value $miseSourceDir | Out-Null
		Write-Host "mise configuration updated."
	} else
	{
		$backup = "$miseTargetDir.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
		Write-Host "Backing up existing mise configuration to $backup"
		Move-Item $miseTargetDir $backup
		New-Item $miseTargetDir -ItemType SymbolicLink `
			-Value $miseSourceDir | Out-Null
		Write-Host "mise configuration created."
	}
} else
{
	$miseConfigParent = Split-Path -Parent $miseTargetDir
	if (-not (Test-Path $miseConfigParent))
	{
		New-Item $miseConfigParent -ItemType Directory -Force | Out-Null
	}

	Write-Host "Creating mise configuration link..."
	New-Item $miseTargetDir -ItemType SymbolicLink `
		-Value $miseSourceDir | Out-Null
	Write-Host "mise configuration created."
}

$mise = Get-MiseCommand
if ($null -ne $mise)
{
	$miseConfigFile = "$miseSourceDir\config.toml"
	if (Test-Path $miseConfigFile)
	{
		Write-Host "Trusting mise config..."
		& $mise --yes trust $miseConfigFile

		if ($LASTEXITCODE -ne 0)
		{
			Write-Warning "mise trust failed."
		}
	}

	$bootstrapTools = @("go", "golangci-lint", "node", "python", "zig", "lua")
	Write-Host "Installing Windows-compatible mise bootstrap tools..."
	& $mise --yes install @bootstrapTools

	if ($LASTEXITCODE -ne 0)
	{
		Write-Warning "mise install failed."
	} else
	{
		Write-Host "mise bootstrap tools installed."
	}

	# Load mise into this shell so installed tools are available immediately.
	(& $mise activate pwsh) | Out-String | Invoke-Expression
	& $mise reshim

	$miseProfileLine = "(& `"$mise`" activate pwsh) | Out-String | Invoke-Expression"

	if (Add-LineIfMissing $PROFILE.CurrentUserAllHosts $miseProfileLine)
	{
		Write-Host "Added mise activation to PowerShell profile."
	} else
	{
		Write-Host "mise activation already present in PowerShell profile."
	}
} else
{
	Write-Warning "mise not found. If it was just installed, restart PowerShell and rerun this script."
}

Install-NpmGlobalPackage "@openai/codex" "codex" "Codex CLI"

#endregion


Write-Host ""
Write-Host "Setting up configuration files..."

#region Windows Terminal Settings

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

#region VSCode Settings

$term = Get-AppxPackage | Where-Object {
	$_.Name -match "VisualStudioCode"
}

if ($null -eq $term)
{
	Write-Warning "VSCode not found. Skipping..."
} else
{
	$vscodeDir = "$env:APPDATA\Code\User"

	$settingsTarget = "$vscodeDir\settings.json"
	$settingsSource = "$repoRoot\windows\vscode\settings.json"

	$keybindingsTarget = "$vscodeDir\keybindings.json"
	$keybindingsSource = "$repoRoot\windows\vscode\keybindings.json"

	if (-not (Test-Path $vscodeDir))
	{
		New-Item $vscodeDir -ItemType Directory -Force | Out-Null
	}

	if (-not (Test-Path $settingsSource))
	{
		Write-Warning "VSCode settings source not found: $settingsSource"
		Write-Warning "Skipping VSCode settings."
	} elseif (Test-Path $settingsTarget)
	{
		$targetItem = Get-Item $settingsTarget
		$existing = $targetItem.Target

		if ($targetItem.LinkType -eq "SymbolicLink" -and $existing -eq $source)
		{
			Write-Host "VSCode settings already linked."
		} elseif ($targetItem.LinkType -eq "SymbolicLink")
		{
			Write-Host "Updating VSCode settings link..."
			Remove-Item $settingsTarget -Force
			New-Item $settingsTarget -ItemType SymbolicLink `
				-Value $settingsSource | Out-Null
			Write-Host "VSCode settings updated."
		} else
		{
			$backup = "$settingsTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
			Write-Host "Backing up existing VSCode settings to $backup"
			Move-Item $settingsTarget $backup
			New-Item $settingsTarget -ItemType SymbolicLink `
				-Value $settingsSource | Out-Null
			Write-Host "VSCode settings created."
		}
	} else
	{
		Write-Host "Creating VSCode settings link..."
		New-Item $settingsTarget -ItemType SymbolicLink `
			-Value $settingsSource | Out-Null
		Write-Host "VSCode settings created."
	}

	if (-not (Test-Path $keybindingsSource))
	{
		Write-Warning "VSCode keybindings source not found: $keybindingsSource"
		Write-Warning "Skipping VSCode keybindings."
	} elseif (Test-Path $keybindingsTarget)
	{
		$targetItem = Get-Item $keybindingsTarget
		$existing = $targetItem.Target

		if ($targetItem.LinkType -eq "SymbolicLink" -and $existing -eq $source)
		{
			Write-Host "VSCode keybindings already linked."
		} elseif ($targetItem.LinkType -eq "SymbolicLink")
		{
			Write-Host "Updating VSCode keybindings link..."
			Remove-Item $keybindingsTarget -Force
			New-Item $keybindingsTarget -ItemType SymbolicLink `
				-Value $keybindingsSource | Out-Null
			Write-Host "VSCode keybindings updated."
		} else
		{
			$backup = "$keybindingsTarget.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
			Write-Host "Backing up existing VSCode keybindings to $backup"
			Move-Item $keybindingsTarget $backup
			New-Item $keybindingsTarget -ItemType SymbolicLink `
				-Value $keybindingsSource | Out-Null
			Write-Host "VSCode keybindings created."
		}
	} else
	{
		Write-Host "Creating VSCode keybindings link..."
		New-Item $keybindingsTarget -ItemType SymbolicLink `
			-Value $keybindingsSource | Out-Null
		Write-Host "VSCode keybindings created."
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
