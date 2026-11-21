[CmdletBinding()]
param(
    [ValidateSet('setup', 'syntax', 'lint')]
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
if ($Mode -eq 'lint') {
    Import-Module PSScriptAnalyzer -RequiredVersion $moduleVersion
}
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
    }
}
if ($failed) { exit 1 }
