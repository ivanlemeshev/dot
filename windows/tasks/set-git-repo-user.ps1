#!/usr/bin/env pwsh
#MISE description="Set repository Git identity with --repo, --name, and --email"

$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path -Parent $PSScriptRoot) 'helpers.ps1')
$values = @{}
for ($index = 0; $index -lt $args.Count; $index += 2) {
    $key = $args[$index]
    if ($key -notin @('--repo', '--name', '--email')) { throw "Unknown argument: $key" }
    if ($index + 1 -ge $args.Count) { throw "A value is missing for $key." }
    $values[$key] = $args[$index + 1]
}
if (-not $values['--repo']) { throw 'Pass --repo with a repository path.' }
$repository = $values['--repo']
Invoke-Checked git @('-C', $repository, 'rev-parse', '--git-dir') | Out-Null
$name = if ($values.ContainsKey('--name')) { $values['--name'] } else { Read-Host 'Git user name' }
$email = if ($values.ContainsKey('--email')) { $values['--email'] } else { Read-Host 'Git user email' }
if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($email) -or "$name$email" -match '[\r\n\x00]') {
    throw 'Git name and email must contain nonempty single-line values.'
}
Invoke-Checked git @('-C', $repository, 'config', '--local', '--replace-all', 'user.name', $name)
Invoke-Checked git @('-C', $repository, 'config', '--local', '--replace-all', 'user.email', $email)
Write-Host 'Repository Git identity changes. Other settings stay unchanged.'
