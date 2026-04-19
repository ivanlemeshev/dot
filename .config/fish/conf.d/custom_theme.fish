# Custom theme for fish shell

# --- Semantic roles ---
set -l ui_background       282828
set -l ui_background_alt   32302f
set -l ui_selection        45403d
set -l ui_foreground       d4be98
set -l ui_foreground_alt   ddc7a1
set -l ui_muted            928374
set -l syntax_function     a9b665
set -l syntax_keyword      ea6962
set -l syntax_type         d8a657
set -l syntax_variable     7daea3
set -l syntax_string       a9b665
set -l syntax_operator     e78a4e
set -l syntax_escape       d8a657
set -l diagnostic_error    ea6962
set -l tool_path           7daea3
set -l tool_root           ea6962
set -l tool_remote         d8a657

# --- Syntax highlighting ---
set -Ux fish_color_normal         $ui_foreground
set -Ux fish_color_command        $syntax_function
set -Ux fish_color_keyword        $syntax_keyword
set -Ux fish_color_option         $syntax_type
set -Ux fish_color_param          $syntax_variable
set -Ux fish_color_quote          $syntax_string
set -Ux fish_color_redirection    $syntax_operator
set -Ux fish_color_end            $syntax_operator
set -Ux fish_color_operator       $syntax_operator
set -Ux fish_color_escape         $syntax_escape
set -Ux fish_color_comment        $ui_muted --italics
set -Ux fish_color_error          $diagnostic_error
set -Ux fish_color_autosuggestion $ui_foreground_alt
set -Ux fish_color_valid_path     $tool_path --underline
set -Ux fish_color_cancel         $diagnostic_error

# --- Selection & search ---
set -Ux fish_color_selection    --background=$ui_selection
set -Ux fish_color_search_match --background=$ui_selection

# --- Prompt ---
set -Ux fish_color_cwd         $tool_path
set -Ux fish_color_cwd_root    $tool_root
set -Ux fish_color_user        $ui_foreground
set -Ux fish_color_host        $tool_path
set -Ux fish_color_host_remote $tool_remote
set -Ux fish_color_status      $diagnostic_error

# --- Pager (completions) ---
set -Ux fish_pager_color_progress            $ui_muted
set -Ux fish_pager_color_prefix              $syntax_type
set -Ux fish_pager_color_completion          $ui_foreground
set -Ux fish_pager_color_description         $ui_muted --dim
set -Ux fish_pager_color_selected_background --background=$ui_selection
set -Ux fish_pager_color_selected_completion $ui_foreground
set -Ux fish_pager_color_selected_description $ui_muted
