# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Cole Custom palette (hex) ---
set -l fg0     "#F2E6CF"  # fg
set -l bg0     "#0C0C0C"  # bg
set -l bg1     "#A5A5A5"  # black
set -l bg2     "#7A7A7A"  # bright_black
set -l red     "#CC5D4B"  # red
set -l yellow  "#B38D59"  # yellow
set -l green   "#2E9969"  # green
set -l magenta "#AB78AB"  # magenta

# --- Colors ---
set -l colors \
    "--color fg:$fg0" \
    "--color fg+:$bg0" \
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
