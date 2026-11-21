# Syntax highlighting
set -gx fish_color_normal white
set -gx fish_color_command yellow
set -gx fish_color_keyword red
set -gx fish_color_option blue
set -gx fish_color_param white
set -gx fish_color_quote green
set -gx fish_color_redirection cyan
set -gx fish_color_end red
set -gx fish_color_operator cyan
set -gx fish_color_escape yellow
set -gx fish_color_comment brblack --italics
set -gx fish_color_error brred
set -gx fish_color_autosuggestion brblack
set -gx fish_color_valid_path blue --underline
set -gx fish_color_cancel brred

# Selection and search
set -gx fish_color_selection normal --reverse
set -gx fish_color_search_match normal --reverse

# Prompt
set -gx fish_color_cwd blue
set -gx fish_color_cwd_root brred
set -gx fish_color_user green
set -gx fish_color_host cyan
set -gx fish_color_host_remote yellow
set -gx fish_color_status brred

# Pager (completions)
set -gx fish_pager_color_progress brblack
set -gx fish_pager_color_prefix yellow
set -gx fish_pager_color_completion normal
set -gx fish_pager_color_description brblack
set -gx fish_pager_color_selected_background --background=normal
set -gx fish_pager_color_selected_completion normal --reverse
set -gx fish_pager_color_selected_description normal --reverse
set -gx fish_pager_color_selected_prefix normal --reverse

if test "$DOTFILES_HIGHLIGHT_MODE" = min
    for role in keyword option redirection end operator escape user host
        set -gx "fish_color_$role" white
    end
    set -gx fish_pager_color_prefix white
end
