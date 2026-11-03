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
