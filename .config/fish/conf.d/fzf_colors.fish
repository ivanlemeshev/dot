# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined once as variables so changing the palette is a
# single-place edit.

# --- Custom palette (hex) ---
set -l fg0     "#C5C8C6"  # fg
set -l bg0     "#1D1F21"  # bg
set -l bg1     "#282A2E"  # black
set -l bg2     "#969896"  # bright_black
set -l red     "#CC6666"  # red
set -l yellow  "#F0C674"  # yellow
set -l green   "#B5BD68"  # green
set -l magenta "#B294BB"  # magenta

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
