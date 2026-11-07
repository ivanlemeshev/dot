function Install-WindowsLua {
    $msys = 'C:\msys64\usr\bin\env.exe'
    if (-not (Test-Path -LiteralPath $msys)) { throw 'The MSYS2 package is missing from C:\msys64.' }
    $lua = 'C:\msys64\ucrt64\bin\lua.exe'
    $gcc = 'C:\msys64\ucrt64\bin\gcc.exe'
    $gdb = 'C:\msys64\ucrt64\bin\gdb.exe'
    $rocks = 'C:\msys64\ucrt64\bin\luarocks'
    if (-not ((Test-Path -LiteralPath $lua) -and (Test-Path -LiteralPath $gcc) -and (Test-Path -LiteralPath $gdb) -and (Test-Path -LiteralPath $rocks))) {
        Invoke-Checked $msys @('MSYSTEM=UCRT64', 'CHERE_INVOKING=1', '/usr/bin/bash', '-lc', 'pacman -Syu --noconfirm')
        Invoke-Checked $msys @('MSYSTEM=UCRT64', 'CHERE_INVOKING=1', '/usr/bin/bash', '-lc', 'pacman -Syu --noconfirm')
        Invoke-Checked $msys @('MSYSTEM=UCRT64', 'CHERE_INVOKING=1', '/usr/bin/bash', '-lc', 'pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-lua mingw-w64-ucrt-x86_64-lua-luarocks mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-gdb')
    }
    Invoke-Checked $lua @('-v')
    Invoke-Checked $gcc @('--version')
    Invoke-Checked $msys @('MSYSTEM=UCRT64', 'CHERE_INVOKING=1', '/usr/bin/bash', '-lc', 'luarocks --version')
}

function Install-WindowsCompiler {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
    $installation = if (Test-Path -LiteralPath $vswhere) {
        & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    }
    if (-not $installation) {
        $existing = if (Test-Path -LiteralPath $vswhere) { & $vswhere -latest -products Microsoft.VisualStudio.Product.BuildTools -property installationPath }
        if ($existing) {
            $installer = Join-Path (Split-Path -Parent $vswhere) 'setup.exe'
            $process = Start-Process -FilePath $installer -ArgumentList @('modify', '--installPath', "`"$existing`"", '--passive', '--norestart', '--add', 'Microsoft.VisualStudio.Workload.VCTools', '--includeRecommended') -Wait -PassThru
            if ($process.ExitCode -notin @(0, 3010)) { throw "Visual Studio modification fails with exit code $($process.ExitCode)." }
        } else {
            $arguments = @('install', '--id', 'Microsoft.VisualStudio.2022.BuildTools', '--exact', '--source', 'winget', '--override', '--wait --passive --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended', '--accept-package-agreements', '--accept-source-agreements', '--disable-interactivity')
            Invoke-Checked winget $arguments
        }
        $installation = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    }
    if (-not $installation) { throw 'The Visual Studio C++ compiler component is missing.' }
}
