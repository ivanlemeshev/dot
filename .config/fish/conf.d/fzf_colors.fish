# FZF_DEFAULT_OPTS
#
# Colors are defined as fzf roles so each theme can choose its own values
# semantics without changing fzf's UI mapping.

# --- Semantic roles (hex) ---
set -l fzf_foreground          "#FAF9F5"
set -l fzf_background          "#141413"
set -l fzf_selected_foreground  "#FAF9F5"
set -l fzf_selected_background  "#252522"
set -l fzf_muted               "#B0AEA5"
set -l fzf_match               "#E9A17D"
set -l fzf_selected_match      "#E9A17D"
set -l fzf_info                "#5B8DB8"
set -l fzf_marker              "#5B8DB8"
set -l fzf_prompt              "#D97757"
set -l fzf_spinner             "#D97757"
set -l fzf_pointer             "#5D9B75"
set -l fzf_border              "#B0AEA5"
set -l fzf_header              "#B0AEA5"
set -l fzf_label               "#FAF9F5"
set -l fzf_query               "#FAF9F5"
set -l fzf_gutter              "#141413"

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
