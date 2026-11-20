[CmdletBinding()]
param(
    [ValidateSet('setup', 'format', 'format:check', 'lint')]
    [string]$Mode,
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Paths
)

$ErrorActionPreference = 'Stop'
$moduleVersion = '1.25.0'
if ($Mode -eq 'setup') {
    if (-not (Get-Module -ListAvailable PSScriptAnalyzer | Where-Object Version -EQ $moduleVersion)) {
        Install-Module PSScriptAnalyzer -RequiredVersion $moduleVersion -Scope CurrentUser -Repository PSGallery -Force
    }
    Import-Module PSScriptAnalyzer -RequiredVersion $moduleVersion
    exit
}
Import-Module PSScriptAnalyzer -RequiredVersion $moduleVersion
$formatSettings = Import-PowerShellDataFile (Join-Path (Get-Module PSScriptAnalyzer).ModuleBase 'Settings/CodeFormattingOTBS.psd1')
# NOTE: Command casing depends on the host platform and installed modules.
$formatSettings.IncludeRules = [string[]]@($formatSettings.IncludeRules | Where-Object { $_ -ne 'PSUseCorrectCasing' })
$lintSettings = @{
    IncludeRules = [string[]]@(
        'PSAvoidAssignmentToAutomaticVariable'
        'PSAvoidDefaultValueSwitchParameter'
        'PSAvoidUsingEmptyCatchBlock'
        'PSAvoidUsingInvokeExpression'
        'PSAvoidUsingPlainTextForPassword'
        'PSAvoidUsingConvertToSecureStringWithPlainText'
        'PSMisleadingBacktick'
        'PSUseDeclaredVarsMoreThanAssignments'
    )
}
$failed = $false
foreach ($path in $Paths) {
    $source = [IO.File]::ReadAllText((Join-Path (Get-Location) $path))
    $tokens = $null
    $parseErrors = $null
    $null = [Management.Automation.Language.Parser]::ParseInput($source, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors) {
        $parseErrors | Format-Table -AutoSize | Out-Host
        $failed = $true
        continue
    }
    if ($Mode -eq 'lint') {
        $issues = @(Invoke-ScriptAnalyzer -ScriptDefinition $source -Severity Error, Warning -Settings $lintSettings)
        if ($issues) {
            Write-Output $path
            $issues | Format-Table RuleName, Line, Message -AutoSize | Out-Host
            $failed = $true
        }
    } else {
        $formatted = (Invoke-Formatter -ScriptDefinition $source -Settings $formatSettings).Replace("`r`n", "`n").TrimEnd("`n") + "`n"
        if ($formatted -cne $source) {
            if ($Mode -eq 'format') {
                [IO.File]::WriteAllText((Join-Path (Get-Location) $path), $formatted, [Text.UTF8Encoding]::new($false))
                Write-Output "Formatted $path"
            } else {
                Write-Output "Formatting differs: $path"
                $failed = $true
            }
        }
    }
}
if ($failed) { exit 1 }
