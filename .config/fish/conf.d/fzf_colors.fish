# FZF_DEFAULT_OPTS
#
# Colors are defined as fzf roles so each theme can choose its own values
# semantics without changing fzf's UI mapping.

# --- Semantic roles (hex) ---
set -l fzf_foreground          "#CDD6F4"
set -l fzf_background          "#1E1E2E"
set -l fzf_selected_background "#313244"
set -l fzf_muted               "#585B70"
set -l fzf_match               "#CBA6F7"
set -l fzf_selected_match      "#89B4FA"
set -l fzf_info                "#89B4FA"
set -l fzf_marker              "#A6E3A1"
set -l fzf_prompt              "#FAB387"
set -l fzf_spinner             "#F9E2AF"
set -l fzf_pointer             "#74C7EC"
set -l fzf_border              "#585B70"
set -l fzf_header              "#6C7086"
set -l fzf_label               "#CDD6F4"
set -l fzf_query               "#CDD6F4"
set -l fzf_gutter              "#1E1E2E"

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
