# FZF_DEFAULT_OPTS
#
# Colors are defined as fzf roles so each theme can choose its own values
# semantics without changing fzf's UI mapping.

# --- Semantic roles (hex) ---
set -l fzf_foreground          "#C5C8C6"
set -l fzf_background          "#1D1F21"
set -l fzf_selected_background "#1D1F21"
set -l fzf_muted               "#969896"
set -l fzf_match               "#F0C674"
set -l fzf_selected_match      "#F0C674"
set -l fzf_info                "#81A2BE"
set -l fzf_marker              "#81A2BE"
set -l fzf_prompt              "#DE935F"
set -l fzf_spinner             "#DE935F"
set -l fzf_pointer             "#DE935F"
set -l fzf_border              "#969896"
set -l fzf_header              "#969896"
set -l fzf_label               "#C5C8C6"
set -l fzf_query               "#C5C8C6"
set -l fzf_gutter              "#1D1F21"

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
