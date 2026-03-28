# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Cole Custom palette (hex) ---
set -l fg0     "#f2e6cf"  # fg
set -l bg0     "#0c0c0c"  # bg
set -l bg1     "#202020"  # black
set -l bg2     "#7a7a7a"  # bright_black
set -l red     "#cc5d4b"  # red
set -l yellow  "#b38d59"  # yellow
set -l green   "#2e9969"  # green
set -l magenta "#ab78ab"  # magenta

# --- Colors ---
set -l colors \
    "--color fg:$fg0" \
    "--color fg+:$fg0" \
    "--color bg:$bg0" \
    "--color bg+:$bg1" \
    "--color hl:$red" \
    "--color hl+:$red" \
    "--color info:$magenta" \
    "--color marker:$green" \
    "--color prompt:$magenta" \
    "--color spinner:$yellow" \
    "--color pointer:$yellow" \
    "--color header:$red" \
    "--color border:$bg2" \
    "--color label:$fg0" \
    "--color query:$yellow"

# --- Layout / UI ---
set -l ui \
    "--border 'sharp'" \
    "--border-label ''" \
    "--preview-window 'border-sharp'" \
    "--prompt '> '" \
    "--marker '>'" \
    "--pointer '◆'" \
    "--separator '─'" \
    "--scrollbar '█'" \
    "--layout 'reverse'" \
    "--info 'right'" \
    "--multi"

set -x FZF_DEFAULT_OPTS (string join -- " " $colors $ui)
