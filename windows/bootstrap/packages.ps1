Write-Host "Checking Windows packages..."

Install-WingetPackage "Git.Git" "Git"
Install-WingetPackage "GitHub.cli" "GitHub CLI"
Install-WingetPackage "Microsoft.PowerShell" "PowerShell 7"
Install-WingetPackage "jdx.mise" "mise"
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
