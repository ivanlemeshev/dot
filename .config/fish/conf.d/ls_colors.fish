# LS_COLORS for ls, fd, etc. (Custom)
#
# Each color is defined once as a variable so you can change a color in one
# place instead of hunting through hundreds of entries.

# --- Custom palette (RGB values) ---
set -l fg0    "187;187;187"  # #bbbbbb
set -l bg0    "25;25;25"     # #191919
set -l red    "222;110;124"  # #de6e7c
set -l orange "214;140;103"  # #b77e64
set -l yellow "183;126;100"  # #b3a06a
set -l green  "129;155;105"  # #819b69
set -l aqua   "102;165;173"  # #66a5ad
set -l purple "178;121;167"  # #b279a7
set -l dim    "142;142;142"  # #8e8e8e
set -l green2 "101;184;193"  # #65b8c1

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
    "di=$n;$aqua" \
    "ln=$it;$aqua" \
    "or=$it;$red" \
    "mi=$n;$fg0;48;2;$red" \
    "ex=$b;$green" \
    "pi=$n;$purple" \
    "so=$b;$purple" \
    "do=$b;$purple" \
    "bd=$b;$yellow" \
    "cd=$it;$yellow" \
    "su=$n;$fg0;48;2;$red" \
    "sg=$n;$bg0;48;2;$orange" \
    "ca=$n;$bg0;48;2;$red" \
    "st=$n;$fg0;48;2;$aqua" \
    "ow=$b;$green" \
    "tw=$it;$fg0;48;2;$aqua"

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
    "*.ai=$n;$green2" \
    "*.ma=$n;$green2" \
    "*.mb=$n;$green2" \
    "*.wv=$n;$green2" \
    "*.3ds=$n;$green2" \
    "*.3fr=$n;$green2" \
    "*.3mf=$n;$green2" \
    "*.aif=$n;$green2" \
    "*.amf=$n;$green2" \
    "*.ape=$n;$green2" \
    "*.ari=$n;$green2" \
    "*.arw=$n;$green2" \
    "*.bay=$n;$green2" \
    "*.bmp=$n;$green2" \
    "*.cap=$n;$green2" \
    "*.cr2=$n;$green2" \
    "*.cr3=$n;$green2" \
    "*.crw=$n;$green2" \
    "*.dae=$n;$green2" \
    "*.dcr=$n;$green2" \
    "*.dcs=$n;$green2" \
    "*.dng=$n;$green2" \
    "*.drf=$n;$green2" \
    "*.dxf=$n;$green2" \
    "*.eip=$n;$green2" \
    "*.eps=$n;$green2" \
    "*.erf=$n;$green2" \
    "*.exr=$n;$green2" \
    "*.fbx=$n;$green2" \
    "*.fff=$n;$green2" \
    "*.fnt=$n;$green2" \
    "*.fon=$n;$green2" \
    "*.gif=$n;$green2" \
    "*.gpr=$n;$green2" \
    "*.hda=$n;$green2" \
    "*.hip=$n;$green2" \
    "*.ico=$n;$green2" \
    "*.igs=$n;$green2" \
    "*.iiq=$n;$green2" \
    "*.jpg=$n;$green2" \
    "*.jxl=$n;$green2" \
    "*.k25=$n;$green2" \
    "*.kdc=$n;$green2" \
    "*.kra=$n;$green2" \
    "*.m3u=$n;$green2" \
    "*.m4a=$n;$green2" \
    "*.mdc=$n;$green2" \
    "*.mef=$n;$green2" \
    "*.mid=$n;$green2" \
    "*.mos=$n;$green2" \
    "*.mp3=$n;$green2" \
    "*.mrw=$n;$green2" \
    "*.mtl=$n;$green2" \
    "*.nef=$n;$green2" \
    "*.nrw=$n;$green2" \
    "*.obj=$n;$green2" \
    "*.obm=$n;$green2" \
    "*.ogg=$n;$green2" \
    "*.orf=$n;$green2" \
    "*.otf=$n;$green2" \
    "*.otl=$n;$green2" \
    "*.pbm=$n;$green2" \
    "*.pcx=$n;$green2" \
    "*.pef=$n;$green2" \
    "*.pgm=$n;$green2" \
    "*.png=$n;$green2" \
    "*.ppm=$n;$green2" \
    "*.psd=$n;$green2" \
    "*.ptx=$n;$green2" \
    "*.pxn=$n;$green2" \
    "*.qoi=$n;$green2" \
    "*.r3d=$n;$green2" \
    "*.raf=$n;$green2" \
    "*.raw=$n;$green2" \
    "*.rw2=$n;$green2" \
    "*.rwl=$n;$green2" \
    "*.rwz=$n;$green2" \
    "*.sr2=$n;$green2" \
    "*.srf=$n;$green2" \
    "*.srw=$n;$green2" \
    "*.stl=$n;$green2" \
    "*.stp=$n;$green2" \
    "*.svg=$n;$green2" \
    "*.tga=$n;$green2" \
    "*.tif=$n;$green2" \
    "*.ttf=$n;$green2" \
    "*.usd=$n;$green2" \
    "*.wav=$n;$green2" \
    "*.wma=$n;$green2" \
    "*.wrl=$n;$green2" \
    "*.x3d=$n;$green2" \
    "*.x3f=$n;$green2" \
    "*.xpm=$n;$green2" \
    "*.xvf=$n;$green2" \
    "*.avif=$n;$green2" \
    "*.braw=$n;$green2" \
    "*.data=$n;$green2" \
    "*.flac=$n;$green2" \
    "*.heif=$n;$green2" \
    "*.iges=$n;$green2" \
    "*.jpeg=$n;$green2" \
    "*.opus=$n;$green2" \
    "*.step=$n;$green2" \
    "*.tiff=$n;$green2" \
    "*.usda=$n;$green2" \
    "*.usdc=$n;$green2" \
    "*.usdz=$n;$green2" \
    "*.webp=$n;$green2" \
    "*.woff=$n;$green2" \
    "*.woff2=$n;$green2" \
    "*.blend=$n;$green2" \
    "*.alembic=$n;$green2"

# --- Video ---
set -a ls \
    "*.rm=$b;$green2" \
    "*.avi=$b;$green2" \
    "*.flv=$b;$green2" \
    "*.m4v=$b;$green2" \
    "*.mkv=$b;$green2" \
    "*.mov=$b;$green2" \
    "*.mp4=$b;$green2" \
    "*.mpg=$b;$green2" \
    "*.ogv=$b;$green2" \
    "*.swf=$b;$green2" \
    "*.vob=$b;$green2" \
    "*.wmv=$b;$green2" \
    "*.h264=$b;$green2" \
    "*.mpeg=$b;$green2" \
    "*.webm=$b;$green2"

# --- Archives / packages ---
set -a ls \
    "*.z=$n;$orange" \
    "*.7z=$n;$orange" \
    "*.bz=$n;$orange" \
    "*.db=$n;$orange" \
    "*.gz=$n;$orange" \
    "*.xz=$n;$orange" \
    "*.apk=$n;$orange" \
    "*.arj=$n;$orange" \
    "*.bag=$n;$orange" \
    "*.bz2=$n;$orange" \
    "*.deb=$n;$orange" \
    "*.jar=$n;$orange" \
    "*.msi=$n;$orange" \
    "*.pkg=$n;$orange" \
    "*.rar=$n;$orange" \
    "*.rpm=$n;$orange" \
    "*.tar=$n;$orange" \
    "*.tbz=$n;$orange" \
    "*.tgz=$n;$orange" \
    "*.xbps=$n;$orange" \
    "*.zip=$n;$orange" \
    "*.zst=$n;$orange" \
    "*.tbz2=$n;$orange"

# --- Disk images ---
set -a ls \
    "*.bin=$b;$orange" \
    "*.dmg=$b;$orange" \
    "*.img=$b;$orange" \
    "*.iso=$b;$orange" \
    "*.vcd=$b;$orange" \
    "*.toast=$b;$orange"

# --- Documents ---
set -a ls \
    "*.ps=$b;$aqua" \
    "*.doc=$b;$aqua" \
    "*.ics=$b;$aqua" \
    "*.kex=$b;$aqua" \
    "*.odp=$b;$aqua" \
    "*.ods=$b;$aqua" \
    "*.odt=$b;$aqua" \
    "*.pdf=$b;$aqua" \
    "*.pps=$b;$aqua" \
    "*.ppt=$b;$aqua" \
    "*.rtf=$b;$aqua" \
    "*.sxi=$b;$aqua" \
    "*.sxw=$b;$aqua" \
    "*.xlr=$b;$aqua" \
    "*.xls=$b;$aqua" \
    "*.docx=$b;$aqua" \
    "*.epub=$b;$aqua" \
    "*.pptx=$b;$aqua" \
    "*.xlsx=$b;$aqua"

# --- CI/CD config ---
set -a ls \
    "*.cirrus.yml=$n;$aqua" \
    "*.gitlab-ci.yml=$n;$aqua" \
    "*.travis.yml=$n;$aqua" \
    "*appveyor.yml=$n;$aqua" \
    "*azure-pipelines.yml=$n;$aqua"

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
