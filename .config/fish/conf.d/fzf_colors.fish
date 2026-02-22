# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Custom palette (hex) ---
set -l fg0     "#C5C9C5"  # primary text
set -l bg0     "#181616"  # main background
set -l bg1     "#A6A69C"  # lighter background
set -l red     "#C4746E"
set -l yellow  "#C4B28A"
set -l green   "#8A9A7B"
set -l magenta "#A292A3"

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
    "--color border:$bg1" \
    "--color label:$fg0" \
    "--color query:$yellow"

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
