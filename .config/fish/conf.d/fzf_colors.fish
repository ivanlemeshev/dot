# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Custom palette (hex) ---
set -l fg0     "#D4BE98"  # fg
set -l bg0     "#282828"  # bg
set -l bg1     "#32302F"  # black
set -l bg2     "#7C6F64"  # bright_black
set -l red     "#EA6962"  # red
set -l orange  "#E78A4E"  # orange
set -l yellow  "#D8A657"  # yellow
set -l green   "#A9B665"  # green
set -l magenta "#D3869B"  # magenta

# --- Colors ---
set -l colors \
    "--color fg:$fg0" \
    "--color fg+:$fg0" \
    "--color bg:$bg0" \
    "--color bg+:$bg1" \
    "--color hl:$green" \
    "--color hl+:$green" \
    "--color info:$bg2" \
    "--color marker:$yellow" \
    "--color prompt:$yellow" \
    "--color spinner:$yellow" \
    "--color pointer:$yellow" \
    "--color header:$orange" \
    "--color border:$bg2" \
    "--color label:$fg0" \
    "--color query:$fg0"

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
