Write-Host "Checking Windows packages..."

Install-WingetPackage "Git.Git" "Git"
Install-WingetPackage "GitHub.cli" "GitHub CLI"
Install-WingetPackage "Microsoft.PowerShell" "PowerShell 7"
Install-WingetPackage "jdx.mise" "mise"
if ($null -eq (Get-MiseCommand)) {
    Write-Host "mise was not found after the winget install. Trying the official installer..."
    try {
        $miseInstaller = Invoke-RestMethod "https://mise.run/powershell" -ErrorAction Stop
        Invoke-Expression $miseInstaller
    } catch {
        Write-Warning "The official mise installer failed: $($_.Exception.Message)"
    }

    if ($null -eq (Get-MiseCommand)) {
        throw "mise installation failed. Node.js shims cannot run without mise."
    }
}
Install-WingetPackage "Racket.Racket" "Racket"
Install-WingetPackage "BurntSushi.ripgrep.MSVC" "ripgrep"
Install-WingetPackage "sharkdp.fd" "fd"
Install-WingetPackage "junegunn.fzf" "fzf"
Install-WingetPackage "tree-sitter.tree-sitter-cli" "Tree-sitter CLI"
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install --id "Microsoft.VisualStudio.2022.BuildTools" --exact `
        --source winget `
        --override "--wait --passive --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" `
        --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to install Visual Studio C++ Build Tools."
    }
} else {
    Write-Warning "winget not found. Skipping Visual Studio C++ Build Tools."
}
Install-WingetPackage "Neovim.Neovim" "Neovim"
Install-WingetPackage "marlocarlo.psmux" "psmux"
Install-WingetPackage "max-sixty.worktrunk" "Worktrunk"
