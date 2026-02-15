# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Custom palette (hex, retro amber-tinted for vintage feel) ---
set -l fg0    "#d4b888"  # primary text
set -l bg0    "#262220"  # main background
set -l bg1    "#403530"  # lighter background
set -l red    "#c97060"
set -l orange "#cc8850"
set -l green  "#93ae64"
set -l purple "#b8868e"

# --- Colors ---
set -l colors \
    "--color fg:$fg0" \
    "--color fg+:$fg0" \
    "--color bg:$bg0" \
    "--color bg+:$bg1" \
    "--color hl:$red" \
    "--color hl+:$red" \
    "--color info:$purple" \
    "--color marker:$green" \
    "--color prompt:$purple" \
    "--color spinner:$orange" \
    "--color pointer:$orange" \
    "--color header:$red" \
    "--color border:$bg1" \
    "--color label:$fg0" \
    "--color query:$orange"

# --- Layout / UI ---
set -l ui \
    "--border 'rounded'" \
    "--border-label ''" \
    "--preview-window 'border-rounded'" \
    "--prompt '> '" \
    "--marker '>'" \
    "--pointer '◆'" \
    "--separator '─'" \
    "--scrollbar '█'" \
    "--layout 'reverse'" \
    "--info 'right'" \
    "--multi"

set -x FZF_DEFAULT_OPTS (string join -- " " $colors $ui)
