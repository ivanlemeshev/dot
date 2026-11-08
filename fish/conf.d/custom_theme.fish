# --- Syntax highlighting ---
set -gx fish_color_normal         normal
set -gx fish_color_command        green
set -gx fish_color_keyword        yellow
set -gx fish_color_option         brblue
set -gx fish_color_param          brblue
set -gx fish_color_quote          bryellow
set -gx fish_color_redirection    brblue
set -gx fish_color_end            brmagenta
set -gx fish_color_operator       cyan
set -gx fish_color_escape         yellow
set -gx fish_color_comment        brblack --italics
set -gx fish_color_error          brred
set -gx fish_color_autosuggestion brblack
set -gx fish_color_valid_path     brblue --underline
set -gx fish_color_cancel         brred

# --- Selection & search ---
set -gx fish_color_selection    black --background=brblue
set -gx fish_color_search_match black --background=brblue

# --- Prompt ---
set -gx fish_color_cwd         green
set -gx fish_color_cwd_root    brred
set -gx fish_color_user        green
set -gx fish_color_host        brblue
set -gx fish_color_host_remote bryellow
set -gx fish_color_status      brred

# --- Pager (completions) ---
set -gx fish_pager_color_progress            white
set -gx fish_pager_color_prefix              yellow
set -gx fish_pager_color_completion          normal
set -gx fish_pager_color_description         white
set -gx fish_pager_color_selected_background --background=brblue
set -gx fish_pager_color_selected_completion black
set -gx fish_pager_color_selected_description black
set -gx fish_pager_color_selected_prefix black
