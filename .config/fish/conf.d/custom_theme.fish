# --- Syntax highlighting ---
set -Ux fish_color_normal         normal
set -Ux fish_color_command        green
set -Ux fish_color_keyword        yellow
set -Ux fish_color_option         blue
set -Ux fish_color_param          blue
set -Ux fish_color_quote          bryellow
set -Ux fish_color_redirection    blue
set -Ux fish_color_end            magenta
set -Ux fish_color_operator       cyan
set -Ux fish_color_escape         yellow
set -Ux fish_color_comment        white --italics
set -Ux fish_color_error          red
set -Ux fish_color_autosuggestion white
set -Ux fish_color_valid_path     blue --underline
set -Ux fish_color_cancel         red

# --- Selection & search ---
set -Ux fish_color_selection    black --background=yellow
set -Ux fish_color_search_match black --background=yellow

# --- Prompt ---
set -Ux fish_color_cwd         green
set -Ux fish_color_cwd_root    red
set -Ux fish_color_user        green
set -Ux fish_color_host        blue
set -Ux fish_color_host_remote bryellow
set -Ux fish_color_status      red

# --- Pager (completions) ---
set -Ux fish_pager_color_progress            white
set -Ux fish_pager_color_prefix              yellow
set -Ux fish_pager_color_completion          normal
set -Ux fish_pager_color_description         white
set -Ux fish_pager_color_selected_background --background=yellow
set -Ux fish_pager_color_selected_completion black
set -Ux fish_pager_color_selected_description black
set -Ux fish_pager_color_selected_prefix black
