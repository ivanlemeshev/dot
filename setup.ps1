# Run as Administrator:
#
# To allow script execution, run PowerShell as Administrator and execute:
# Set-ExecutionPolicy RemoteSigned
#
# To revert to default policy, run as Administrator:
# Set-ExecutionPolicy Restricted

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
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
Write-Host "User profile: $env:USERPROFILE"
Write-Host ""

$restartRequired = $false

#region CapsLock Remapping

function Set-CapsLockAsCtrl
{
	Write-Host "Checking Caps Lock to Left Ctrl mapping..."

	$regPath = "HKLM:\System\CurrentControlSet\Control\Keyboard Layout"
	$regName = "Scancode Map"

	# Remap: 0x3a (Caps Lock) -> 0x1d (Left Ctrl)
	$value = 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
	0x02,0x00,0x00,0x00,0x1d,0x00,0x3a,0x00,
	0x00,0x00,0x00,0x00

	try
	{
		$current = Get-ItemProperty -Path $regPath -Name $regName `
			-ErrorAction Stop | Select-Object -ExpandProperty $regName

		# Compare as joined strings for simplicity
		if (($current -join ',') -eq ($value -join ','))
		{
			Write-Host "Caps Lock already mapped. No changes needed."
			return $false
		}

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

	$fonts = @{
		"JetBrainsMono" = "JetBrainsMono Nerd Font"
		"Hack" = "Hack Nerd Font"
	}

	$changed = $false

	foreach ($fontName in $fonts.Keys)
	{
		$fontFamily = $fonts[$fontName]

		# Check registry for installed fonts
		$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
		$installed = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue |
			Get-Member -MemberType NoteProperty |
			Where-Object { $_.Name -like "*$fontFamily*" }

		if ($null -ne $installed)
		{
			Write-Host "$fontName already installed. Skipping..."
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

		$shellApp = New-Object -ComObject Shell.Application
		$fontsFolder = $shellApp.Namespace(0x14)
		$tempDir = "$env:windir\Temp\Fonts"
		New-Item $tempDir -Type Directory -Force | Out-Null

		$count = 0

		# Install TTF and OTF fonts
		foreach ($ext in @("*.ttf", "*.otf"))
		{
			Get-ChildItem $extractDir -Include $ext -Recurse |
				ForEach-Object {
					$fontDest = "$env:windir\Fonts\$($_.Name)"
					if (-not (Test-Path $fontDest))
					{
						$temp = "$tempDir\$($_.Name)"
						Copy-Item $_.FullName `
							-Destination $tempDir -Force
						$fontsFolder.CopyHere($temp, 0x10)
						Remove-Item $temp -Force
						$count++
					}
				}
		}

		Write-Host "Installed $count font files."
		Write-Host "Cleaning up..."
		Remove-Item $zipFile -Force
		Remove-Item $extractDir -Recurse -Force

		if ($count -gt 0)
		{ $changed = $true
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
	$source = "$scriptDir\windows\terminal\settings.json"

	if (-not (Test-Path $termDir))
	{
		New-Item $termDir -ItemType Directory -Force | Out-Null
	}

	if (Test-Path $target)
	{
		$existing = (Get-Item $target).Target
		if ($existing -eq $source)
		{
			Write-Host "Terminal settings already linked."
		} else
		{
			Write-Host "Updating Terminal settings link..."
			Remove-Item $target -Force
			New-Item $target -ItemType SymbolicLink `
				-Value $source | Out-Null
			Write-Host "Terminal settings updated."
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
}
