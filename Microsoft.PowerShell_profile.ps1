# Set the STARSHIP_CONFIG environment variable to the path of your starship.toml
$ENV:STARSHIP_CONFIG = "$HOME\starship.toml"

# Enable starship prompt for PowerShell
Invoke-Expression (&starship init powershell)
