# FZF_DEFAULT_OPTS
#
# Colors are defined as fzf roles so each theme can choose its own values
# semantics without changing fzf's UI mapping.

# --- Semantic roles (hex) ---
set -l fzf_foreground          "#D4BE98"
set -l fzf_background          "#1D2021"
set -l fzf_selected_foreground  "#D4BE98"
set -l fzf_selected_background  "#282828"
set -l fzf_muted               "#7C6F64"
set -l fzf_match               "#D8A657"
set -l fzf_selected_match      "#D8A657"
set -l fzf_info                "#7DAEA3"
set -l fzf_marker              "#7DAEA3"
set -l fzf_prompt              "#EA6962"
set -l fzf_spinner             "#E78A4E"
set -l fzf_pointer             "#A9B665"
set -l fzf_border              "#7C6F64"
set -l fzf_header              "#7C6F64"
set -l fzf_label               "#D4BE98"
set -l fzf_query               "#D4BE98"
set -l fzf_gutter              "#1D2021"

# --- Colors ---
set -l colors \
    "--color fg:$fzf_foreground" \
    "--color fg+:$fzf_selected_foreground" \
    "--color bg:$fzf_background" \
    "--color bg+:$fzf_selected_background" \
    "--color hl:$fzf_match" \
    "--color hl+:$fzf_selected_match" \
    "--color info:$fzf_info" \
    "--color marker:$fzf_marker" \
    "--color prompt:$fzf_prompt" \
    "--color spinner:$fzf_spinner" \
    "--color pointer:$fzf_pointer" \
    "--color header:$fzf_header" \
    "--color border:$fzf_border" \
    "--color label:$fzf_label" \
    "--color query:$fzf_query" \
    "--color gutter:$fzf_gutter"

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
