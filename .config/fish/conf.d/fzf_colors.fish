# FZF_DEFAULT_OPTS
#
# Colors are defined as fzf roles so each theme can choose its own values
# semantics without changing fzf's UI mapping.

# --- Semantic roles (hex) ---
set -l fzf_foreground          "#E8E3DF"
set -l fzf_background          "#121110"
set -l fzf_selected_foreground  "#E8E3DF"
set -l fzf_selected_background  "#292624"
set -l fzf_muted               "#716B66"
set -l fzf_match               "#E9BA77"
set -l fzf_selected_match      "#E9BA77"
set -l fzf_info                "#87A8BA"
set -l fzf_marker              "#87A8BA"
set -l fzf_prompt              "#C8785B"
set -l fzf_spinner             "#D9A15F"
set -l fzf_pointer             "#AAB28A"
set -l fzf_border              "#716B66"
set -l fzf_header              "#716B66"
set -l fzf_label               "#E8E3DF"
set -l fzf_query               "#E8E3DF"
set -l fzf_gutter              "#121110"

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
