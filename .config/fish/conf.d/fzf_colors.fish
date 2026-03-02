# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Custom palette (hex) ---
set -l fg0     "#ECE7D6"  # primary text
set -l bg0     "#232B30"  # main background
set -l bg1     "#333B40"  # selected background
set -l bg2     "#5A656F"  # lighter background
set -l red     "#E67E80"
set -l yellow  "#F8C46F"
set -l green   "#A7C080"
set -l magenta "#E19FB6"

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
