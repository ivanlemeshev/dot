Set-ExecutionPolicy Bypass -Scope Process -Force; `
	[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
	Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://community.chocolatey.org/install.ps1"))

choco upgrade all -y
choco install -y powershell wezterm starship gh make zig
