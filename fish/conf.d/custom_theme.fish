# --- Syntax highlighting ---
set -gx fish_color_normal         white
set -gx fish_color_command        yellow
set -gx fish_color_keyword        red
set -gx fish_color_option         blue
set -gx fish_color_param          white
set -gx fish_color_quote          green
set -gx fish_color_redirection    cyan
set -gx fish_color_end            red
set -gx fish_color_operator       cyan
set -gx fish_color_escape         yellow
set -gx fish_color_comment        brblack --italics
set -gx fish_color_error          brred
set -gx fish_color_autosuggestion brblack
set -gx fish_color_valid_path     blue --underline
set -gx fish_color_cancel         brred

# --- Selection & search ---
set -gx fish_color_selection    black --background=blue
set -gx fish_color_search_match black --background=blue

# --- Prompt ---
set -gx fish_color_cwd         blue
set -gx fish_color_cwd_root    brred
set -gx fish_color_user        green
set -gx fish_color_host        cyan
set -gx fish_color_host_remote yellow
set -gx fish_color_status      brred

# --- Pager (completions) ---
set -gx fish_pager_color_progress            brblack
set -gx fish_pager_color_prefix              yellow
set -gx fish_pager_color_completion          normal
set -gx fish_pager_color_description         brblack
set -gx fish_pager_color_selected_background --background=blue
set -gx fish_pager_color_selected_completion black
set -gx fish_pager_color_selected_description black
set -gx fish_pager_color_selected_prefix black
