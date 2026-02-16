# FZF_DEFAULT_OPTS (Custom Dark)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Custom Dark palette (hex) ---
set -l fg0    "#d4b98d"  # primary text
set -l bg0    "#302824"  # main background
set -l bg1    "#3A322D"  # lighter background
set -l red    "#E67E80"
set -l orange "#E69875"
set -l green  "#A7C080"
set -l purple "#D699B6"

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
