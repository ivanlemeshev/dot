# LS_COLORS for ls, fd, etc. (Custom)
#
# Each color is defined once as a variable so you can change a color in one
# place instead of hunting through hundreds of entries.

# --- Custom palette (RGB values, tuned for eye comfort) ---
set -l fg0    "212;190;152"  # #d4be98
set -l bg0    "40;40;40"     # #282828
set -l red    "219;107;101"  # #db6b65
set -l orange "212;139;88"   # #d48b58
set -l yellow "207;164;94"   # #cfa45e
set -l green  "159;178;106"  # #9fb26a
set -l aqua   "137;180;130"  # #89b482
set -l blue   "125;174;163"  # #7daea3
set -l purple "199;138;150"  # #c78a96
set -l dim    "124;111;100"  # #7c6f64

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
    "pi=$n;$purple" \
    "so=$b;$purple" \
    "do=$b;$purple" \
    "bd=$b;$yellow" \
    "cd=$it;$yellow" \
    "su=$n;$fg0;48;2;$red" \
    "sg=$n;$bg0;48;2;$orange" \
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
    "*.ai=$n;$aqua" \
    "*.ma=$n;$aqua" \
    "*.mb=$n;$aqua" \
    "*.wv=$n;$aqua" \
    "*.3ds=$n;$aqua" \
    "*.3fr=$n;$aqua" \
    "*.3mf=$n;$aqua" \
    "*.aif=$n;$aqua" \
    "*.amf=$n;$aqua" \
    "*.ape=$n;$aqua" \
    "*.ari=$n;$aqua" \
    "*.arw=$n;$aqua" \
    "*.bay=$n;$aqua" \
    "*.bmp=$n;$aqua" \
    "*.cap=$n;$aqua" \
    "*.cr2=$n;$aqua" \
    "*.cr3=$n;$aqua" \
    "*.crw=$n;$aqua" \
    "*.dae=$n;$aqua" \
    "*.dcr=$n;$aqua" \
    "*.dcs=$n;$aqua" \
    "*.dng=$n;$aqua" \
    "*.drf=$n;$aqua" \
    "*.dxf=$n;$aqua" \
    "*.eip=$n;$aqua" \
    "*.eps=$n;$aqua" \
    "*.erf=$n;$aqua" \
    "*.exr=$n;$aqua" \
    "*.fbx=$n;$aqua" \
    "*.fff=$n;$aqua" \
    "*.fnt=$n;$aqua" \
    "*.fon=$n;$aqua" \
    "*.gif=$n;$aqua" \
    "*.gpr=$n;$aqua" \
    "*.hda=$n;$aqua" \
    "*.hip=$n;$aqua" \
    "*.ico=$n;$aqua" \
    "*.igs=$n;$aqua" \
    "*.iiq=$n;$aqua" \
    "*.jpg=$n;$aqua" \
    "*.jxl=$n;$aqua" \
    "*.k25=$n;$aqua" \
    "*.kdc=$n;$aqua" \
    "*.kra=$n;$aqua" \
    "*.m3u=$n;$aqua" \
    "*.m4a=$n;$aqua" \
    "*.mdc=$n;$aqua" \
    "*.mef=$n;$aqua" \
    "*.mid=$n;$aqua" \
    "*.mos=$n;$aqua" \
    "*.mp3=$n;$aqua" \
    "*.mrw=$n;$aqua" \
    "*.mtl=$n;$aqua" \
    "*.nef=$n;$aqua" \
    "*.nrw=$n;$aqua" \
    "*.obj=$n;$aqua" \
    "*.obm=$n;$aqua" \
    "*.ogg=$n;$aqua" \
    "*.orf=$n;$aqua" \
    "*.otf=$n;$aqua" \
    "*.otl=$n;$aqua" \
    "*.pbm=$n;$aqua" \
    "*.pcx=$n;$aqua" \
    "*.pef=$n;$aqua" \
    "*.pgm=$n;$aqua" \
    "*.png=$n;$aqua" \
    "*.ppm=$n;$aqua" \
    "*.psd=$n;$aqua" \
    "*.ptx=$n;$aqua" \
    "*.pxn=$n;$aqua" \
    "*.qoi=$n;$aqua" \
    "*.r3d=$n;$aqua" \
    "*.raf=$n;$aqua" \
    "*.raw=$n;$aqua" \
    "*.rw2=$n;$aqua" \
    "*.rwl=$n;$aqua" \
    "*.rwz=$n;$aqua" \
    "*.sr2=$n;$aqua" \
    "*.srf=$n;$aqua" \
    "*.srw=$n;$aqua" \
    "*.stl=$n;$aqua" \
    "*.stp=$n;$aqua" \
    "*.svg=$n;$aqua" \
    "*.tga=$n;$aqua" \
    "*.tif=$n;$aqua" \
    "*.ttf=$n;$aqua" \
    "*.usd=$n;$aqua" \
    "*.wav=$n;$aqua" \
    "*.wma=$n;$aqua" \
    "*.wrl=$n;$aqua" \
    "*.x3d=$n;$aqua" \
    "*.x3f=$n;$aqua" \
    "*.xpm=$n;$aqua" \
    "*.xvf=$n;$aqua" \
    "*.avif=$n;$aqua" \
    "*.braw=$n;$aqua" \
    "*.data=$n;$aqua" \
    "*.flac=$n;$aqua" \
    "*.heif=$n;$aqua" \
    "*.iges=$n;$aqua" \
    "*.jpeg=$n;$aqua" \
    "*.opus=$n;$aqua" \
    "*.step=$n;$aqua" \
    "*.tiff=$n;$aqua" \
    "*.usda=$n;$aqua" \
    "*.usdc=$n;$aqua" \
    "*.usdz=$n;$aqua" \
    "*.webp=$n;$aqua" \
    "*.woff=$n;$aqua" \
    "*.woff2=$n;$aqua" \
    "*.blend=$n;$aqua" \
    "*.alembic=$n;$aqua"

# --- Video ---
set -a ls \
    "*.rm=$b;$aqua" \
    "*.avi=$b;$aqua" \
    "*.flv=$b;$aqua" \
    "*.m4v=$b;$aqua" \
    "*.mkv=$b;$aqua" \
    "*.mov=$b;$aqua" \
    "*.mp4=$b;$aqua" \
    "*.mpg=$b;$aqua" \
    "*.ogv=$b;$aqua" \
    "*.swf=$b;$aqua" \
    "*.vob=$b;$aqua" \
    "*.wmv=$b;$aqua" \
    "*.h264=$b;$aqua" \
    "*.mpeg=$b;$aqua" \
    "*.webm=$b;$aqua"

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
