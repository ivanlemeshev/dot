# Fish keeps these values after the theme file is removed.
set -l old_color_variables \
    fish_color_normal \
    fish_color_command \
    fish_color_keyword \
    fish_color_option \
    fish_color_param \
    fish_color_quote \
    fish_color_redirection \
    fish_color_end \
    fish_color_operator \
    fish_color_escape \
    fish_color_comment \
    fish_color_error \
    fish_color_autosuggestion \
    fish_color_valid_path \
    fish_color_cancel \
    fish_color_selection \
    fish_color_search_match \
    fish_color_cwd \
    fish_color_cwd_root \
    fish_color_user \
    fish_color_host \
    fish_color_host_remote \
    fish_color_status \
    fish_pager_color_progress \
    fish_pager_color_prefix \
    fish_pager_color_completion \
    fish_pager_color_description \
    fish_pager_color_selected_background \
    fish_pager_color_selected_completion \
    fish_pager_color_selected_description

for variable in $old_color_variables
    set --erase --universal $variable
end

set -g fish_color_normal normal
set -g fish_color_command green
set -g fish_color_keyword magenta
set -g fish_color_option yellow
set -g fish_color_param normal
set -g fish_color_quote yellow
set -g fish_color_redirection cyan
set -g fish_color_end cyan
set -g fish_color_operator cyan
set -g fish_color_escape brcyan
set -g fish_color_comment brblack
set -g fish_color_error brred
set -g fish_color_autosuggestion brblack
set -g fish_color_valid_path cyan --underline
set -g fish_color_cancel normal --reverse
set -g fish_color_selection --background=blue
set -g fish_color_search_match --background=blue
set -g fish_color_cwd green
set -g fish_color_cwd_root brred
set -g fish_color_user brgreen
set -g fish_color_host cyan
set -g fish_color_host_remote brcyan
set -g fish_color_status brred
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_pager_color_prefix brwhite --bold --underline
set -g fish_pager_color_completion normal
set -g fish_pager_color_description brblack
set -g fish_pager_color_selected_background --background=blue
set -g fish_pager_color_selected_completion brwhite --background=blue --bold
set -g fish_pager_color_selected_description brwhite --background=blue
