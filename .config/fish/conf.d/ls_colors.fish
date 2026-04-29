# LS_COLORS for ls, fd, etc.
#
# Colors are defined as file roles so each theme can choose its own values
# semantics without changing the file-type mapping.

# --- Semantic roles (RGB values) ---
set -l ls_foreground "212;190;152"  # #d4be98
set -l ls_background "40;40;40"     # #282828
set -l ls_error      "234;105;98"   # #ea6962
set -l ls_executable "169;182;101"  # #a9b665
set -l ls_document   "216;166;87"   # #d8a657
set -l ls_directory  "125;174;163"  # #7daea3
set -l ls_special    "211;134;155"  # #d3869b
set -l ls_media      "137;180;130"  # #89b482
set -l ls_backup     "124;111;100"  # #7c6f64

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
    "no=$n;$ls_foreground;48;2;$ls_background" \
    "fi=$n;$ls_foreground;48;2;$ls_background" \
    "di=$n;$ls_directory" \
    "ln=$it;$ls_media" \
    "or=$it;$ls_error" \
    "mi=$n;$ls_foreground;48;2;$ls_error" \
    "ex=$b;$ls_executable" \
    "pi=$n;$ls_special" \
    "so=$b;$ls_special" \
    "do=$b;$ls_special" \
    "bd=$b;$ls_document" \
    "cd=$it;$ls_document" \
    "su=$n;$ls_foreground;48;2;$ls_error" \
    "sg=$n;$ls_background;48;2;$ls_document" \
    "ca=$n;$ls_background;48;2;$ls_error" \
    "st=$n;$ls_foreground;48;2;$ls_directory" \
    "ow=$b;$ls_executable" \
    "tw=$it;$ls_foreground;48;2;$ls_directory"

# --- Plain text ---
set -a ls \
    "*.txt=$n;$ls_foreground"

# --- Source code ---
set -a ls \
    "*.a=$b;$ls_executable" \
    "*.c=$n;$ls_executable" \
    "*.d=$n;$ls_executable" \
    "*.h=$n;$ls_executable" \
    "*.m=$n;$ls_executable" \
    "*.o=$it;$ls_backup" \
    "*.p=$n;$ls_executable" \
    "*.r=$n;$ls_executable" \
    "*.t=$n;$ls_executable" \
    "*.v=$n;$ls_executable" \
    "*.as=$n;$ls_executable" \
    "*.bc=$it;$ls_backup" \
    "*.cc=$n;$ls_executable" \
    "*.cp=$n;$ls_executable" \
    "*.cr=$n;$ls_executable" \
    "*.cs=$n;$ls_executable" \
    "*.di=$n;$ls_executable" \
    "*.el=$n;$ls_executable" \
    "*.ex=$n;$ls_executable" \
    "*.fs=$n;$ls_executable" \
    "*.go=$n;$ls_executable" \
    "*.gv=$n;$ls_executable" \
    "*.ha=$n;$ls_executable" \
    "*.hh=$n;$ls_executable" \
    "*.hi=$it;$ls_backup" \
    "*.hs=$n;$ls_executable" \
    "*.jl=$n;$ls_executable" \
    "*.js=$n;$ls_executable" \
    "*.ko=$b;$ls_executable" \
    "*.kt=$n;$ls_executable" \
    "*.la=$it;$ls_backup" \
    "*.ll=$n;$ls_executable" \
    "*.lo=$it;$ls_backup" \
    "*.ml=$n;$ls_executable" \
    "*.mn=$n;$ls_executable" \
    "*.nb=$n;$ls_executable" \
    "*.nu=$n;$ls_executable" \
    "*.pl=$n;$ls_executable" \
    "*.pm=$n;$ls_executable" \
    "*.pp=$n;$ls_executable" \
    "*.py=$n;$ls_executable" \
    "*.rb=$n;$ls_executable" \
    "*.rs=$n;$ls_executable" \
    "*.sh=$n;$ls_executable" \
    "*.so=$b;$ls_executable" \
    "*.td=$n;$ls_executable" \
    "*.ts=$n;$ls_executable" \
    "*.vb=$n;$ls_executable" \
    "*.adb=$n;$ls_executable" \
    "*.ads=$n;$ls_executable" \
    "*.asa=$n;$ls_executable" \
    "*.asm=$n;$ls_executable" \
    "*.awk=$n;$ls_executable" \
    "*.bat=$b;$ls_executable" \
    "*.bsh=$n;$ls_executable" \
    "*.c++=$n;$ls_executable" \
    "*.cgi=$n;$ls_executable" \
    "*.clj=$n;$ls_executable" \
    "*.com=$b;$ls_executable" \
    "*.cpp=$n;$ls_executable" \
    "*.css=$n;$ls_executable" \
    "*.csx=$n;$ls_executable" \
    "*.cxx=$n;$ls_executable" \
    "*.def=$n;$ls_executable" \
    "*.dll=$b;$ls_executable" \
    "*.dot=$n;$ls_executable" \
    "*.dpr=$n;$ls_executable" \
    "*.elc=$n;$ls_executable" \
    "*.elm=$n;$ls_executable" \
    "*.epp=$n;$ls_executable" \
    "*.erl=$n;$ls_executable" \
    "*.exe=$b;$ls_executable" \
    "*.exs=$n;$ls_executable" \
    "*.fsi=$n;$ls_executable" \
    "*.fsx=$n;$ls_executable" \
    "*.gvy=$n;$ls_executable" \
    "*.h++=$n;$ls_executable" \
    "*.hpp=$n;$ls_executable" \
    "*.htc=$n;$ls_executable" \
    "*.hxx=$n;$ls_executable" \
    "*.inc=$n;$ls_executable" \
    "*.inl=$n;$ls_executable" \
    "*.ino=$n;$ls_executable" \
    "*.ipp=$n;$ls_executable" \
    "*.jsx=$n;$ls_executable" \
    "*.kts=$n;$ls_executable" \
    "*.ltx=$n;$ls_executable" \
    "*.lua=$n;$ls_executable" \
    "*.mir=$n;$ls_executable" \
    "*.mli=$n;$ls_executable" \
    "*.nim=$n;$ls_executable" \
    "*.pas=$n;$ls_executable" \
    "*.php=$n;$ls_executable" \
    "*.pod=$n;$ls_executable" \
    "*.ps1=$n;$ls_executable" \
    "*.sbt=$n;$ls_executable" \
    "*.sql=$n;$ls_executable" \
    "*.tcl=$n;$ls_executable" \
    "*.tex=$n;$ls_executable" \
    "*.tsx=$n;$ls_executable" \
    "*.vim=$n;$ls_executable" \
    "*.vsh=$n;$ls_executable" \
    "*.zig=$n;$ls_executable" \
    "*.zsh=$n;$ls_executable" \
    "*.bash=$n;$ls_executable" \
    "*.dart=$n;$ls_executable" \
    "*.diff=$n;$ls_executable" \
    "*.fish=$n;$ls_executable" \
    "*.hack=$n;$ls_executable" \
    "*.java=$n;$ls_executable" \
    "*.less=$n;$ls_executable" \
    "*.lisp=$n;$ls_executable" \
    "*.mojo=$n;$ls_executable" \
    "*.nims=$n;$ls_executable" \
    "*.prql=$n;$ls_executable" \
    "*.psd1=$n;$ls_executable" \
    "*.psm1=$n;$ls_executable" \
    "*.purs=$n;$ls_executable" \
    "*.raku=$n;$ls_executable" \
    "*.sass=$n;$ls_executable" \
    "*.scad=$n;$ls_executable" \
    "*.scss=$n;$ls_executable" \
    "*.scala=$n;$ls_executable" \
    "*.swift=$n;$ls_executable" \
    "*.gcode=$n;$ls_executable" \
    "*.ipynb=$n;$ls_executable" \
    "*.patch=$n;$ls_executable" \
    "*.cabal=$n;$ls_executable" \
    "*.groovy=$n;$ls_executable" \
    "*.matlab=$n;$ls_executable" \
    "*.nimble=$n;$ls_executable" \
    "*.bashrc=$n;$ls_executable" \
    "*.gradle=$n;$ls_executable" \
    "*.dylib=$b;$ls_executable" \
    "*.applescript=$n;$ls_executable" \
    "*.bash_profile=$n;$ls_executable"

# --- Data / markup / config ---
set -a ls \
    "*.1=$n;$ls_document" \
    "*.md=$n;$ls_document" \
    "*.ui=$n;$ls_document" \
    "*.bib=$n;$ls_document" \
    "*.bst=$n;$ls_document" \
    "*.cfg=$n;$ls_document" \
    "*.csv=$n;$ls_document" \
    "*.htm=$n;$ls_document" \
    "*.ini=$n;$ls_document" \
    "*.nix=$n;$ls_document" \
    "*.org=$n;$ls_document" \
    "*.rst=$n;$ls_document" \
    "*.tml=$n;$ls_document" \
    "*.typ=$n;$ls_document" \
    "*.xml=$n;$ls_document" \
    "*.xmp=$n;$ls_document" \
    "*.yml=$n;$ls_document" \
    "*.conf=$n;$ls_document" \
    "*.html=$n;$ls_document" \
    "*.info=$n;$ls_document" \
    "*.json=$n;$ls_document" \
    "*.toml=$n;$ls_document" \
    "*.yaml=$n;$ls_document" \
    "*.mdown=$n;$ls_document" \
    "*.shtml=$n;$ls_document" \
    "*.xhtml=$n;$ls_document" \
    "*.config=$n;$ls_document" \
    "*.desktop=$n;$ls_document" \
    "*.markdown=$n;$ls_document" \
    "*.webmanifest=$n;$ls_document" \
    "*passwd=$n;$ls_document" \
    "*shadow=$n;$ls_document" \
    "*Dockerfile=$n;$ls_document"

# --- Images / media (static) ---
set -a ls \
    "*.ai=$n;$ls_media" \
    "*.ma=$n;$ls_media" \
    "*.mb=$n;$ls_media" \
    "*.wv=$n;$ls_media" \
    "*.3ds=$n;$ls_media" \
    "*.3fr=$n;$ls_media" \
    "*.3mf=$n;$ls_media" \
    "*.aif=$n;$ls_media" \
    "*.amf=$n;$ls_media" \
    "*.ape=$n;$ls_media" \
    "*.ari=$n;$ls_media" \
    "*.arw=$n;$ls_media" \
    "*.bay=$n;$ls_media" \
    "*.bmp=$n;$ls_media" \
    "*.cap=$n;$ls_media" \
    "*.cr2=$n;$ls_media" \
    "*.cr3=$n;$ls_media" \
    "*.crw=$n;$ls_media" \
    "*.dae=$n;$ls_media" \
    "*.dcr=$n;$ls_media" \
    "*.dcs=$n;$ls_media" \
    "*.dng=$n;$ls_media" \
    "*.drf=$n;$ls_media" \
    "*.dxf=$n;$ls_media" \
    "*.eip=$n;$ls_media" \
    "*.eps=$n;$ls_media" \
    "*.erf=$n;$ls_media" \
    "*.exr=$n;$ls_media" \
    "*.fbx=$n;$ls_media" \
    "*.fff=$n;$ls_media" \
    "*.fnt=$n;$ls_media" \
    "*.fon=$n;$ls_media" \
    "*.gif=$n;$ls_media" \
    "*.gpr=$n;$ls_media" \
    "*.hda=$n;$ls_media" \
    "*.hip=$n;$ls_media" \
    "*.ico=$n;$ls_media" \
    "*.igs=$n;$ls_media" \
    "*.iiq=$n;$ls_media" \
    "*.jpg=$n;$ls_media" \
    "*.jxl=$n;$ls_media" \
    "*.k25=$n;$ls_media" \
    "*.kdc=$n;$ls_media" \
    "*.kra=$n;$ls_media" \
    "*.m3u=$n;$ls_media" \
    "*.m4a=$n;$ls_media" \
    "*.mdc=$n;$ls_media" \
    "*.mef=$n;$ls_media" \
    "*.mid=$n;$ls_media" \
    "*.mos=$n;$ls_media" \
    "*.mp3=$n;$ls_media" \
    "*.mrw=$n;$ls_media" \
    "*.mtl=$n;$ls_media" \
    "*.nef=$n;$ls_media" \
    "*.nrw=$n;$ls_media" \
    "*.obj=$n;$ls_media" \
    "*.obm=$n;$ls_media" \
    "*.ogg=$n;$ls_media" \
    "*.orf=$n;$ls_media" \
    "*.otf=$n;$ls_media" \
    "*.otl=$n;$ls_media" \
    "*.pbm=$n;$ls_media" \
    "*.pcx=$n;$ls_media" \
    "*.pef=$n;$ls_media" \
    "*.pgm=$n;$ls_media" \
    "*.png=$n;$ls_media" \
    "*.ppm=$n;$ls_media" \
    "*.psd=$n;$ls_media" \
    "*.ptx=$n;$ls_media" \
    "*.pxn=$n;$ls_media" \
    "*.qoi=$n;$ls_media" \
    "*.r3d=$n;$ls_media" \
    "*.raf=$n;$ls_media" \
    "*.raw=$n;$ls_media" \
    "*.rw2=$n;$ls_media" \
    "*.rwl=$n;$ls_media" \
    "*.rwz=$n;$ls_media" \
    "*.sr2=$n;$ls_media" \
    "*.srf=$n;$ls_media" \
    "*.srw=$n;$ls_media" \
    "*.stl=$n;$ls_media" \
    "*.stp=$n;$ls_media" \
    "*.svg=$n;$ls_media" \
    "*.tga=$n;$ls_media" \
    "*.tif=$n;$ls_media" \
    "*.ttf=$n;$ls_media" \
    "*.usd=$n;$ls_media" \
    "*.wav=$n;$ls_media" \
    "*.wma=$n;$ls_media" \
    "*.wrl=$n;$ls_media" \
    "*.x3d=$n;$ls_media" \
    "*.x3f=$n;$ls_media" \
    "*.xpm=$n;$ls_media" \
    "*.xvf=$n;$ls_media" \
    "*.avif=$n;$ls_media" \
    "*.braw=$n;$ls_media" \
    "*.data=$n;$ls_media" \
    "*.flac=$n;$ls_media" \
    "*.heif=$n;$ls_media" \
    "*.iges=$n;$ls_media" \
    "*.jpeg=$n;$ls_media" \
    "*.opus=$n;$ls_media" \
    "*.step=$n;$ls_media" \
    "*.tiff=$n;$ls_media" \
    "*.usda=$n;$ls_media" \
    "*.usdc=$n;$ls_media" \
    "*.usdz=$n;$ls_media" \
    "*.webp=$n;$ls_media" \
    "*.woff=$n;$ls_media" \
    "*.woff2=$n;$ls_media" \
    "*.blend=$n;$ls_media" \
    "*.alembic=$n;$ls_media"

# --- Video ---
set -a ls \
    "*.rm=$b;$ls_media" \
    "*.avi=$b;$ls_media" \
    "*.flv=$b;$ls_media" \
    "*.m4v=$b;$ls_media" \
    "*.mkv=$b;$ls_media" \
    "*.mov=$b;$ls_media" \
    "*.mp4=$b;$ls_media" \
    "*.mpg=$b;$ls_media" \
    "*.ogv=$b;$ls_media" \
    "*.swf=$b;$ls_media" \
    "*.vob=$b;$ls_media" \
    "*.wmv=$b;$ls_media" \
    "*.h264=$b;$ls_media" \
    "*.mpeg=$b;$ls_media" \
    "*.webm=$b;$ls_media"

# --- Archives / packages ---
set -a ls \
    "*.z=$n;$ls_document" \
    "*.7z=$n;$ls_document" \
    "*.bz=$n;$ls_document" \
    "*.db=$n;$ls_document" \
    "*.gz=$n;$ls_document" \
    "*.xz=$n;$ls_document" \
    "*.apk=$n;$ls_document" \
    "*.arj=$n;$ls_document" \
    "*.bag=$n;$ls_document" \
    "*.bz2=$n;$ls_document" \
    "*.deb=$n;$ls_document" \
    "*.jar=$n;$ls_document" \
    "*.msi=$n;$ls_document" \
    "*.pkg=$n;$ls_document" \
    "*.rar=$n;$ls_document" \
    "*.rpm=$n;$ls_document" \
    "*.tar=$n;$ls_document" \
    "*.tbz=$n;$ls_document" \
    "*.tgz=$n;$ls_document" \
    "*.xbps=$n;$ls_document" \
    "*.zip=$n;$ls_document" \
    "*.zst=$n;$ls_document" \
    "*.tbz2=$n;$ls_document"

# --- Disk images ---
set -a ls \
    "*.bin=$b;$ls_document" \
    "*.dmg=$b;$ls_document" \
    "*.img=$b;$ls_document" \
    "*.iso=$b;$ls_document" \
    "*.vcd=$b;$ls_document" \
    "*.toast=$b;$ls_document"

# --- Documents ---
set -a ls \
    "*.ps=$b;$ls_directory" \
    "*.doc=$b;$ls_directory" \
    "*.ics=$b;$ls_directory" \
    "*.kex=$b;$ls_directory" \
    "*.odp=$b;$ls_directory" \
    "*.ods=$b;$ls_directory" \
    "*.odt=$b;$ls_directory" \
    "*.pdf=$b;$ls_directory" \
    "*.pps=$b;$ls_directory" \
    "*.ppt=$b;$ls_directory" \
    "*.rtf=$b;$ls_directory" \
    "*.sxi=$b;$ls_directory" \
    "*.sxw=$b;$ls_directory" \
    "*.xlr=$b;$ls_directory" \
    "*.xls=$b;$ls_directory" \
    "*.docx=$b;$ls_directory" \
    "*.epub=$b;$ls_directory" \
    "*.pptx=$b;$ls_directory" \
    "*.xlsx=$b;$ls_directory"

# --- CI/CD config ---
set -a ls \
    "*.cirrus.yml=$n;$ls_directory" \
    "*.gitlab-ci.yml=$n;$ls_directory" \
    "*.travis.yml=$n;$ls_directory" \
    "*appveyor.yml=$n;$ls_directory" \
    "*azure-pipelines.yml=$n;$ls_directory"

# --- Build / config tooling ---
set -a ls \
    "*.mk=$it;$ls_executable" \
    "*.dox=$it;$ls_executable" \
    "*.pro=$it;$ls_executable" \
    "*.cmake=$it;$ls_executable" \
    "*.make=$it;$ls_executable" \
    "*.cmake.in=$it;$ls_executable" \
    "*.flake8=$it;$ls_executable" \
    "*.ignore=$it;$ls_executable" \
    "*.gemspec=$it;$ls_executable" \
    "*.mailmap=$it;$ls_executable" \
    "*.fdignore=$it;$ls_executable" \
    "*.kdevelop=$it;$ls_executable" \
    "*.rgignore=$it;$ls_executable" \
    "*.tfignore=$it;$ls_executable" \
    "*.gitconfig=$it;$ls_executable" \
    "*.gitignore=$it;$ls_executable" \
    "*.gitmodules=$it;$ls_executable" \
    "*.gitattributes=$it;$ls_executable" \
    "*.clang-format=$it;$ls_executable" \
    "*.editorconfig=$it;$ls_executable" \
    "*hgrc=$it;$ls_executable" \
    "*.hgrc=$it;$ls_executable" \
    "*go.mod=$it;$ls_executable" \
    "*v.mod=$it;$ls_executable" \
    "*Makefile=$it;$ls_executable" \
    "*Makefile.am=$it;$ls_executable" \
    "*Doxyfile=$it;$ls_executable" \
    "*SConscript=$it;$ls_executable" \
    "*SConstruct=$it;$ls_executable" \
    "*configure=$it;$ls_executable" \
    "*configure.ac=$it;$ls_executable" \
    "*setup.py=$it;$ls_executable" \
    "*MANIFEST.in=$it;$ls_executable" \
    "*CODEOWNERS=$it;$ls_executable" \
    "*CMakeLists.txt=$it;$ls_executable" \
    "*pyproject.toml=$it;$ls_executable" \
    "*requirements.txt=$it;$ls_executable"

# --- Notable docs ---
set -a ls \
    "*FAQ=$b;$ls_document" \
    "*LEGACY=$b;$ls_document" \
    "*NOTICE=$b;$ls_document" \
    "*README=$b;$ls_document" \
    "*VERSION=$b;$ls_document" \
    "*INSTALL=$b;$ls_document" \
    "*CHANGELOG=$b;$ls_document" \
    "*CONTRIBUTING=$b;$ls_document" \
    "*CONTRIBUTORS=$b;$ls_document" \
    "*CODE_OF_CONDUCT=$b;$ls_document" \
    "*README.md=$b;$ls_document" \
    "*README.txt=$b;$ls_document" \
    "*INSTALL.md=$b;$ls_document" \
    "*INSTALL.txt=$b;$ls_document" \
    "*CHANGELOG.md=$b;$ls_document" \
    "*CHANGELOG.txt=$b;$ls_document" \
    "*CONTRIBUTING.md=$b;$ls_document" \
    "*CONTRIBUTING.txt=$b;$ls_document" \
    "*CONTRIBUTORS.md=$b;$ls_document" \
    "*CONTRIBUTORS.txt=$b;$ls_document" \
    "*CODE_OF_CONDUCT.md=$b;$ls_document" \
    "*CODE_OF_CONDUCT.txt=$b;$ls_document"

# --- Licenses ---
set -a ls \
    "*COPYING=$it;$ls_foreground" \
    "*COPYRIGHT=$it;$ls_foreground" \
    "*LICENCE=$it;$ls_foreground" \
    "*LICENSE=$it;$ls_foreground" \
    "*LICENSE-MIT=$it;$ls_foreground" \
    "*LICENSE-APACHE=$it;$ls_foreground"

# --- TODO files ---
set -a ls \
    "*TODO=$n;$ls_executable" \
    "*TODO.md=$n;$ls_executable" \
    "*TODO.txt=$n;$ls_executable"

# --- Build artifacts / caches ---
set -a ls \
    "*~=$it;$ls_backup" \
    "*.aux=$it;$ls_backup" \
    "*.bak=$it;$ls_backup" \
    "*.bbl=$it;$ls_backup" \
    "*.bcf=$it;$ls_backup" \
    "*.blg=$it;$ls_backup" \
    "*.fls=$it;$ls_backup" \
    "*.git=$it;$ls_backup" \
    "*.idx=$it;$ls_backup" \
    "*.ilg=$it;$ls_backup" \
    "*.ind=$it;$ls_backup" \
    "*.log=$it;$ls_backup" \
    "*.out=$it;$ls_backup" \
    "*.pid=$it;$ls_backup" \
    "*.pyc=$it;$ls_backup" \
    "*.pyd=$it;$ls_backup" \
    "*.pyo=$it;$ls_backup" \
    "*.sty=$it;$ls_backup" \
    "*.swp=$it;$ls_backup" \
    "*.tmp=$it;$ls_backup" \
    "*.toc=$it;$ls_backup" \
    "*.lock=$it;$ls_backup" \
    "*.orig=$it;$ls_backup" \
    "*.rlib=$it;$ls_backup" \
    "*.cache=$it;$ls_backup" \
    "*.class=$it;$ls_backup" \
    "*.ctags=$it;$ls_backup" \
    "*.dyn_o=$it;$ls_backup" \
    "*.rmeta=$it;$ls_backup" \
    "*.dyn_hi=$it;$ls_backup" \
    "*.DS_Store=$it;$ls_backup" \
    "*.localized=$it;$ls_backup" \
    "*.scons_opt=$it;$ls_backup" \
    "*.timestamp=$it;$ls_backup" \
    "*.synctex.gz=$it;$ls_backup" \
    "*.fdb_latexmk=$it;$ls_backup" \
    "*.sconsign.dblite=$it;$ls_backup" \
    "*.CFUserTextEncoding=$it;$ls_backup" \
    "*go.sum=$it;$ls_backup" \
    "*stdin=$it;$ls_backup" \
    "*stdout=$it;$ls_backup" \
    "*stderr=$it;$ls_backup" \
    "*bun.lockb=$it;$ls_backup" \
    "*Makefile.in=$it;$ls_backup" \
    "*CMakeCache.txt=$it;$ls_backup" \
    "*package-lock.json=$it;$ls_backup" \
    "*Icon\r=$it;$ls_backup"

set -x LS_COLORS (string join ":" $ls)
