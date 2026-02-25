# LS_COLORS for ls, fd, etc. (Custom)
#
# Each color is defined once as a variable so you can change a color in one
# place instead of hunting through hundreds of entries.

# --- Custom palette (RGB values) ---
set -l fg0    "209;209;199"  # #d1d1c7
set -l bg0    "24;22;22"     # #181616
set -l red    "201;101;94"  # #c9655e
set -l green  "139;163;124"  # #8ba37c
set -l yellow "209;179;125"  # #d1b37d
set -l blue   "125;166;184"  # #7da6b8
set -l magenta "169;147;168"  # #a993a8
set -l cyan "135;163;161"  # #87a3a1
set -l dim    "138;138;129"  # #8a8a81

# --- ANSI style helpers ---
set -l n  "0;38;2"  # normal
set -l b  "1;38;2"  # bold
set -l it "3;38;2"  # italic

# --- Core file types ---
# rs = reset, mh = multi-hardlink, no = normal, fi = regular file,
# di = directory, ln = symlink, or = orphan symlink, mi = missing target,
# ex = executable, pi = named pipe, so = socket, do = door,
# bd = block device, cd = char device, su = setuid, sg = setgid,
# ca = capability, st = sticky, ow = other-writable, tw = sticky+ow
set -l ls \
    "rs=0" \
    "mh=1" \
    "no=$n;$fg0;48;2;$bg0" \
    "fi=$n;$fg0;48;2;$bg0" \
    "di=$n;$blue" \
    "ln=$it;$blue" \
    "or=$it;$red" \
    "mi=$n;$fg0;48;2;$red" \
    "ex=$b;$green" \
    "pi=$n;$magenta" \
    "so=$b;$magenta" \
    "do=$b;$magenta" \
    "bd=$b;$yellow" \
    "cd=$it;$yellow" \
    "su=$n;$fg0;48;2;$red" \
    "sg=$n;$bg0;48;2;$yellow" \
    "ca=$n;$bg0;48;2;$red" \
    "st=$n;$fg0;48;2;$blue" \
    "ow=$b;$green" \
    "tw=$it;$fg0;48;2;$blue"

# --- Plain text ---
set -a ls \
    "*.txt=$n;$fg0"

# --- Source code ---
set -a ls \
    "*.a=$b;$green" \
    "*.c=$n;$green" \
    "*.d=$n;$green" \
    "*.h=$n;$green" \
    "*.m=$n;$green" \
    "*.o=$it;$dim" \
    "*.p=$n;$green" \
    "*.r=$n;$green" \
    "*.t=$n;$green" \
    "*.v=$n;$green" \
    "*.as=$n;$green" \
    "*.bc=$it;$dim" \
    "*.cc=$n;$green" \
    "*.cp=$n;$green" \
    "*.cr=$n;$green" \
    "*.cs=$n;$green" \
    "*.di=$n;$green" \
    "*.el=$n;$green" \
    "*.ex=$n;$green" \
    "*.fs=$n;$green" \
    "*.go=$n;$green" \
    "*.gv=$n;$green" \
    "*.ha=$n;$green" \
    "*.hh=$n;$green" \
    "*.hi=$it;$dim" \
    "*.hs=$n;$green" \
    "*.jl=$n;$green" \
    "*.js=$n;$green" \
    "*.ko=$b;$green" \
    "*.kt=$n;$green" \
    "*.la=$it;$dim" \
    "*.ll=$n;$green" \
    "*.lo=$it;$dim" \
    "*.ml=$n;$green" \
    "*.mn=$n;$green" \
    "*.nb=$n;$green" \
    "*.nu=$n;$green" \
    "*.pl=$n;$green" \
    "*.pm=$n;$green" \
    "*.pp=$n;$green" \
    "*.py=$n;$green" \
    "*.rb=$n;$green" \
    "*.rs=$n;$green" \
    "*.sh=$n;$green" \
    "*.so=$b;$green" \
    "*.td=$n;$green" \
    "*.ts=$n;$green" \
    "*.vb=$n;$green" \
    "*.adb=$n;$green" \
    "*.ads=$n;$green" \
    "*.asa=$n;$green" \
    "*.asm=$n;$green" \
    "*.awk=$n;$green" \
    "*.bat=$b;$green" \
    "*.bsh=$n;$green" \
    "*.c++=$n;$green" \
    "*.cgi=$n;$green" \
    "*.clj=$n;$green" \
    "*.com=$b;$green" \
    "*.cpp=$n;$green" \
    "*.css=$n;$green" \
    "*.csx=$n;$green" \
    "*.cxx=$n;$green" \
    "*.def=$n;$green" \
    "*.dll=$b;$green" \
    "*.dot=$n;$green" \
    "*.dpr=$n;$green" \
    "*.elc=$n;$green" \
    "*.elm=$n;$green" \
    "*.epp=$n;$green" \
    "*.erl=$n;$green" \
    "*.exe=$b;$green" \
    "*.exs=$n;$green" \
    "*.fsi=$n;$green" \
    "*.fsx=$n;$green" \
    "*.gvy=$n;$green" \
    "*.h++=$n;$green" \
    "*.hpp=$n;$green" \
    "*.htc=$n;$green" \
    "*.hxx=$n;$green" \
    "*.inc=$n;$green" \
    "*.inl=$n;$green" \
    "*.ino=$n;$green" \
    "*.ipp=$n;$green" \
    "*.jsx=$n;$green" \
    "*.kts=$n;$green" \
    "*.ltx=$n;$green" \
    "*.lua=$n;$green" \
    "*.mir=$n;$green" \
    "*.mli=$n;$green" \
    "*.nim=$n;$green" \
    "*.pas=$n;$green" \
    "*.php=$n;$green" \
    "*.pod=$n;$green" \
    "*.ps1=$n;$green" \
    "*.sbt=$n;$green" \
    "*.sql=$n;$green" \
    "*.tcl=$n;$green" \
    "*.tex=$n;$green" \
    "*.tsx=$n;$green" \
    "*.vim=$n;$green" \
    "*.vsh=$n;$green" \
    "*.zig=$n;$green" \
    "*.zsh=$n;$green" \
    "*.bash=$n;$green" \
    "*.dart=$n;$green" \
    "*.diff=$n;$green" \
    "*.fish=$n;$green" \
    "*.hack=$n;$green" \
    "*.java=$n;$green" \
    "*.less=$n;$green" \
    "*.lisp=$n;$green" \
    "*.mojo=$n;$green" \
    "*.nims=$n;$green" \
    "*.prql=$n;$green" \
    "*.psd1=$n;$green" \
    "*.psm1=$n;$green" \
    "*.purs=$n;$green" \
    "*.raku=$n;$green" \
    "*.sass=$n;$green" \
    "*.scad=$n;$green" \
    "*.scss=$n;$green" \
    "*.scala=$n;$green" \
    "*.swift=$n;$green" \
    "*.gcode=$n;$green" \
    "*.ipynb=$n;$green" \
    "*.patch=$n;$green" \
    "*.cabal=$n;$green" \
    "*.groovy=$n;$green" \
    "*.matlab=$n;$green" \
    "*.nimble=$n;$green" \
    "*.bashrc=$n;$green" \
    "*.gradle=$n;$green" \
    "*.dylib=$b;$green" \
    "*.applescript=$n;$green" \
    "*.bash_profile=$n;$green"

# --- Data / markup / config ---
set -a ls \
    "*.1=$n;$yellow" \
    "*.md=$n;$yellow" \
    "*.ui=$n;$yellow" \
    "*.bib=$n;$yellow" \
    "*.bst=$n;$yellow" \
    "*.cfg=$n;$yellow" \
    "*.csv=$n;$yellow" \
    "*.htm=$n;$yellow" \
    "*.ini=$n;$yellow" \
    "*.nix=$n;$yellow" \
    "*.org=$n;$yellow" \
    "*.rst=$n;$yellow" \
    "*.tml=$n;$yellow" \
    "*.typ=$n;$yellow" \
    "*.xml=$n;$yellow" \
    "*.xmp=$n;$yellow" \
    "*.yml=$n;$yellow" \
    "*.conf=$n;$yellow" \
    "*.html=$n;$yellow" \
    "*.info=$n;$yellow" \
    "*.json=$n;$yellow" \
    "*.toml=$n;$yellow" \
    "*.yaml=$n;$yellow" \
    "*.mdown=$n;$yellow" \
    "*.shtml=$n;$yellow" \
    "*.xhtml=$n;$yellow" \
    "*.config=$n;$yellow" \
    "*.desktop=$n;$yellow" \
    "*.markdown=$n;$yellow" \
    "*.webmanifest=$n;$yellow" \
    "*passwd=$n;$yellow" \
    "*shadow=$n;$yellow" \
    "*Dockerfile=$n;$yellow"

# --- Images / media (static) ---
set -a ls \
    "*.ai=$n;$cyan" \
    "*.ma=$n;$cyan" \
    "*.mb=$n;$cyan" \
    "*.wv=$n;$cyan" \
    "*.3ds=$n;$cyan" \
    "*.3fr=$n;$cyan" \
    "*.3mf=$n;$cyan" \
    "*.aif=$n;$cyan" \
    "*.amf=$n;$cyan" \
    "*.ape=$n;$cyan" \
    "*.ari=$n;$cyan" \
    "*.arw=$n;$cyan" \
    "*.bay=$n;$cyan" \
    "*.bmp=$n;$cyan" \
    "*.cap=$n;$cyan" \
    "*.cr2=$n;$cyan" \
    "*.cr3=$n;$cyan" \
    "*.crw=$n;$cyan" \
    "*.dae=$n;$cyan" \
    "*.dcr=$n;$cyan" \
    "*.dcs=$n;$cyan" \
    "*.dng=$n;$cyan" \
    "*.drf=$n;$cyan" \
    "*.dxf=$n;$cyan" \
    "*.eip=$n;$cyan" \
    "*.eps=$n;$cyan" \
    "*.erf=$n;$cyan" \
    "*.exr=$n;$cyan" \
    "*.fbx=$n;$cyan" \
    "*.fff=$n;$cyan" \
    "*.fnt=$n;$cyan" \
    "*.fon=$n;$cyan" \
    "*.gif=$n;$cyan" \
    "*.gpr=$n;$cyan" \
    "*.hda=$n;$cyan" \
    "*.hip=$n;$cyan" \
    "*.ico=$n;$cyan" \
    "*.igs=$n;$cyan" \
    "*.iiq=$n;$cyan" \
    "*.jpg=$n;$cyan" \
    "*.jxl=$n;$cyan" \
    "*.k25=$n;$cyan" \
    "*.kdc=$n;$cyan" \
    "*.kra=$n;$cyan" \
    "*.m3u=$n;$cyan" \
    "*.m4a=$n;$cyan" \
    "*.mdc=$n;$cyan" \
    "*.mef=$n;$cyan" \
    "*.mid=$n;$cyan" \
    "*.mos=$n;$cyan" \
    "*.mp3=$n;$cyan" \
    "*.mrw=$n;$cyan" \
    "*.mtl=$n;$cyan" \
    "*.nef=$n;$cyan" \
    "*.nrw=$n;$cyan" \
    "*.obj=$n;$cyan" \
    "*.obm=$n;$cyan" \
    "*.ogg=$n;$cyan" \
    "*.orf=$n;$cyan" \
    "*.otf=$n;$cyan" \
    "*.otl=$n;$cyan" \
    "*.pbm=$n;$cyan" \
    "*.pcx=$n;$cyan" \
    "*.pef=$n;$cyan" \
    "*.pgm=$n;$cyan" \
    "*.png=$n;$cyan" \
    "*.ppm=$n;$cyan" \
    "*.psd=$n;$cyan" \
    "*.ptx=$n;$cyan" \
    "*.pxn=$n;$cyan" \
    "*.qoi=$n;$cyan" \
    "*.r3d=$n;$cyan" \
    "*.raf=$n;$cyan" \
    "*.raw=$n;$cyan" \
    "*.rw2=$n;$cyan" \
    "*.rwl=$n;$cyan" \
    "*.rwz=$n;$cyan" \
    "*.sr2=$n;$cyan" \
    "*.srf=$n;$cyan" \
    "*.srw=$n;$cyan" \
    "*.stl=$n;$cyan" \
    "*.stp=$n;$cyan" \
    "*.svg=$n;$cyan" \
    "*.tga=$n;$cyan" \
    "*.tif=$n;$cyan" \
    "*.ttf=$n;$cyan" \
    "*.usd=$n;$cyan" \
    "*.wav=$n;$cyan" \
    "*.wma=$n;$cyan" \
    "*.wrl=$n;$cyan" \
    "*.x3d=$n;$cyan" \
    "*.x3f=$n;$cyan" \
    "*.xpm=$n;$cyan" \
    "*.xvf=$n;$cyan" \
    "*.avif=$n;$cyan" \
    "*.braw=$n;$cyan" \
    "*.data=$n;$cyan" \
    "*.flac=$n;$cyan" \
    "*.heif=$n;$cyan" \
    "*.iges=$n;$cyan" \
    "*.jpeg=$n;$cyan" \
    "*.opus=$n;$cyan" \
    "*.step=$n;$cyan" \
    "*.tiff=$n;$cyan" \
    "*.usda=$n;$cyan" \
    "*.usdc=$n;$cyan" \
    "*.usdz=$n;$cyan" \
    "*.webp=$n;$cyan" \
    "*.woff=$n;$cyan" \
    "*.woff2=$n;$cyan" \
    "*.blend=$n;$cyan" \
    "*.alembic=$n;$cyan"

# --- Video ---
set -a ls \
    "*.rm=$b;$cyan" \
    "*.avi=$b;$cyan" \
    "*.flv=$b;$cyan" \
    "*.m4v=$b;$cyan" \
    "*.mkv=$b;$cyan" \
    "*.mov=$b;$cyan" \
    "*.mp4=$b;$cyan" \
    "*.mpg=$b;$cyan" \
    "*.ogv=$b;$cyan" \
    "*.swf=$b;$cyan" \
    "*.vob=$b;$cyan" \
    "*.wmv=$b;$cyan" \
    "*.h264=$b;$cyan" \
    "*.mpeg=$b;$cyan" \
    "*.webm=$b;$cyan"

# --- Archives / packages ---
set -a ls \
    "*.z=$n;$yellow" \
    "*.7z=$n;$yellow" \
    "*.bz=$n;$yellow" \
    "*.db=$n;$yellow" \
    "*.gz=$n;$yellow" \
    "*.xz=$n;$yellow" \
    "*.apk=$n;$yellow" \
    "*.arj=$n;$yellow" \
    "*.bag=$n;$yellow" \
    "*.bz2=$n;$yellow" \
    "*.deb=$n;$yellow" \
    "*.jar=$n;$yellow" \
    "*.msi=$n;$yellow" \
    "*.pkg=$n;$yellow" \
    "*.rar=$n;$yellow" \
    "*.rpm=$n;$yellow" \
    "*.tar=$n;$yellow" \
    "*.tbz=$n;$yellow" \
    "*.tgz=$n;$yellow" \
    "*.xbps=$n;$yellow" \
    "*.zip=$n;$yellow" \
    "*.zst=$n;$yellow" \
    "*.tbz2=$n;$yellow"

# --- Disk images ---
set -a ls \
    "*.bin=$b;$yellow" \
    "*.dmg=$b;$yellow" \
    "*.img=$b;$yellow" \
    "*.iso=$b;$yellow" \
    "*.vcd=$b;$yellow" \
    "*.toast=$b;$yellow"

# --- Documents ---
set -a ls \
    "*.ps=$b;$blue" \
    "*.doc=$b;$blue" \
    "*.ics=$b;$blue" \
    "*.kex=$b;$blue" \
    "*.odp=$b;$blue" \
    "*.ods=$b;$blue" \
    "*.odt=$b;$blue" \
    "*.pdf=$b;$blue" \
    "*.pps=$b;$blue" \
    "*.ppt=$b;$blue" \
    "*.rtf=$b;$blue" \
    "*.sxi=$b;$blue" \
    "*.sxw=$b;$blue" \
    "*.xlr=$b;$blue" \
    "*.xls=$b;$blue" \
    "*.docx=$b;$blue" \
    "*.epub=$b;$blue" \
    "*.pptx=$b;$blue" \
    "*.xlsx=$b;$blue"

# --- CI/CD config ---
set -a ls \
    "*.cirrus.yml=$n;$blue" \
    "*.gitlab-ci.yml=$n;$blue" \
    "*.travis.yml=$n;$blue" \
    "*appveyor.yml=$n;$blue" \
    "*azure-pipelines.yml=$n;$blue"

# --- Build / config tooling ---
set -a ls \
    "*.mk=$it;$green" \
    "*.dox=$it;$green" \
    "*.pro=$it;$green" \
    "*.cmake=$it;$green" \
    "*.make=$it;$green" \
    "*.cmake.in=$it;$green" \
    "*.flake8=$it;$green" \
    "*.ignore=$it;$green" \
    "*.gemspec=$it;$green" \
    "*.mailmap=$it;$green" \
    "*.fdignore=$it;$green" \
    "*.kdevelop=$it;$green" \
    "*.rgignore=$it;$green" \
    "*.tfignore=$it;$green" \
    "*.gitconfig=$it;$green" \
    "*.gitignore=$it;$green" \
    "*.gitmodules=$it;$green" \
    "*.gitattributes=$it;$green" \
    "*.clang-format=$it;$green" \
    "*.editorconfig=$it;$green" \
    "*hgrc=$it;$green" \
    "*.hgrc=$it;$green" \
    "*go.mod=$it;$green" \
    "*v.mod=$it;$green" \
    "*Makefile=$it;$green" \
    "*Makefile.am=$it;$green" \
    "*Doxyfile=$it;$green" \
    "*SConscript=$it;$green" \
    "*SConstruct=$it;$green" \
    "*configure=$it;$green" \
    "*configure.ac=$it;$green" \
    "*setup.py=$it;$green" \
    "*MANIFEST.in=$it;$green" \
    "*CODEOWNERS=$it;$green" \
    "*CMakeLists.txt=$it;$green" \
    "*pyproject.toml=$it;$green" \
    "*requirements.txt=$it;$green"

# --- Notable docs ---
set -a ls \
    "*FAQ=$b;$yellow" \
    "*LEGACY=$b;$yellow" \
    "*NOTICE=$b;$yellow" \
    "*README=$b;$yellow" \
    "*VERSION=$b;$yellow" \
    "*INSTALL=$b;$yellow" \
    "*CHANGELOG=$b;$yellow" \
    "*CONTRIBUTING=$b;$yellow" \
    "*CONTRIBUTORS=$b;$yellow" \
    "*CODE_OF_CONDUCT=$b;$yellow" \
    "*README.md=$b;$yellow" \
    "*README.txt=$b;$yellow" \
    "*INSTALL.md=$b;$yellow" \
    "*INSTALL.txt=$b;$yellow" \
    "*CHANGELOG.md=$b;$yellow" \
    "*CHANGELOG.txt=$b;$yellow" \
    "*CONTRIBUTING.md=$b;$yellow" \
    "*CONTRIBUTING.txt=$b;$yellow" \
    "*CONTRIBUTORS.md=$b;$yellow" \
    "*CONTRIBUTORS.txt=$b;$yellow" \
    "*CODE_OF_CONDUCT.md=$b;$yellow" \
    "*CODE_OF_CONDUCT.txt=$b;$yellow"

# --- Licenses ---
set -a ls \
    "*COPYING=$it;$fg0" \
    "*COPYRIGHT=$it;$fg0" \
    "*LICENCE=$it;$fg0" \
    "*LICENSE=$it;$fg0" \
    "*LICENSE-MIT=$it;$fg0" \
    "*LICENSE-APACHE=$it;$fg0"

# --- TODO files ---
set -a ls \
    "*TODO=$n;$green" \
    "*TODO.md=$n;$green" \
    "*TODO.txt=$n;$green"

# --- Build artifacts / caches ---
set -a ls \
    "*~=$it;$dim" \
    "*.aux=$it;$dim" \
    "*.bak=$it;$dim" \
    "*.bbl=$it;$dim" \
    "*.bcf=$it;$dim" \
    "*.blg=$it;$dim" \
    "*.fls=$it;$dim" \
    "*.git=$it;$dim" \
    "*.idx=$it;$dim" \
    "*.ilg=$it;$dim" \
    "*.ind=$it;$dim" \
    "*.log=$it;$dim" \
    "*.out=$it;$dim" \
    "*.pid=$it;$dim" \
    "*.pyc=$it;$dim" \
    "*.pyd=$it;$dim" \
    "*.pyo=$it;$dim" \
    "*.sty=$it;$dim" \
    "*.swp=$it;$dim" \
    "*.tmp=$it;$dim" \
    "*.toc=$it;$dim" \
    "*.lock=$it;$dim" \
    "*.orig=$it;$dim" \
    "*.rlib=$it;$dim" \
    "*.cache=$it;$dim" \
    "*.class=$it;$dim" \
    "*.ctags=$it;$dim" \
    "*.dyn_o=$it;$dim" \
    "*.rmeta=$it;$dim" \
    "*.dyn_hi=$it;$dim" \
    "*.DS_Store=$it;$dim" \
    "*.localized=$it;$dim" \
    "*.scons_opt=$it;$dim" \
    "*.timestamp=$it;$dim" \
    "*.synctex.gz=$it;$dim" \
    "*.fdb_latexmk=$it;$dim" \
    "*.sconsign.dblite=$it;$dim" \
    "*.CFUserTextEncoding=$it;$dim" \
    "*go.sum=$it;$dim" \
    "*stdin=$it;$dim" \
    "*stdout=$it;$dim" \
    "*stderr=$it;$dim" \
    "*bun.lockb=$it;$dim" \
    "*Makefile.in=$it;$dim" \
    "*CMakeCache.txt=$it;$dim" \
    "*package-lock.json=$it;$dim" \
    "*Icon\r=$it;$dim"

set -x LS_COLORS (string join ":" $ls)
