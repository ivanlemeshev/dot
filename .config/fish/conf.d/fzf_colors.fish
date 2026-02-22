# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Custom palette (hex) ---
set -l fg0     "#D0D0D0"  # primary text
set -l bg0     "#151515"  # main background
set -l bg1     "#252525"  # selected background
set -l bg2     "#505050"  # lighter background
set -l red     "#AC4142"
set -l yellow  "#F4BF75"
set -l green   "#90A959"
set -l magenta "#AA759F"

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
