# FZF_DEFAULT_OPTS (Custom)
#
# Colors are defined as fzf roles so each theme can choose its own values
# semantics without changing fzf's UI mapping.

# --- Semantic roles (hex) ---
set -l fzf_foreground          "#D4BE98"
set -l fzf_background          "#282828"
set -l fzf_selected_background "#32302F"
set -l fzf_muted               "#928374"
set -l fzf_match               "#A9B665"
set -l fzf_selected_match      "#89B482"
set -l fzf_info                "#89B482"
set -l fzf_marker              "#D8A657"
set -l fzf_prompt              "#E78A4E"
set -l fzf_spinner             "#D8A657"
set -l fzf_pointer             "#7DAEA3"
set -l fzf_border              "#928374"
set -l fzf_header              "#928374"
set -l fzf_label               "#D4BE98"
set -l fzf_query               "#D4BE98"
set -l fzf_gutter              "#282828"

# --- Colors ---
set -l colors \
    "--color fg:$fzf_foreground" \
    "--color fg+:$fzf_foreground" \
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
