# Custom theme for fish shell

# --- Semantic roles ---
set -l fish_ui_background         282828
set -l fish_ui_background_alt     32302f
set -l fish_ui_foreground         d4be98
set -l fish_ui_foreground_alt     ddc7a1
set -l fish_ui_muted              928374
set -l fish_syntax_normal         d4be98
set -l fish_syntax_command        a9b665
set -l fish_syntax_keyword        ea6962
set -l fish_syntax_option         d8a657
set -l fish_syntax_param          7daea3
set -l fish_syntax_quote          89b482
set -l fish_syntax_redirection    e78a4e
set -l fish_syntax_end            e78a4e
set -l fish_syntax_operator       e78a4e
set -l fish_syntax_escape         d8a657
set -l fish_syntax_comment        928374
set -l fish_syntax_error          ea6962
set -l fish_syntax_autosuggestion ddc7a1
set -l fish_syntax_valid_path     7daea3
set -l fish_syntax_cancel         ea6962
set -l fish_selection_background  45403d
set -l fish_selection_search_match 45403d
set -l fish_prompt_cwd            7daea3
set -l fish_prompt_cwd_root       ea6962
set -l fish_prompt_user           d4be98
set -l fish_prompt_host           7daea3
set -l fish_prompt_host_remote    d8a657
set -l fish_prompt_status         ea6962
set -l fish_pager_progress        928374
set -l fish_pager_prefix          d8a657
set -l fish_pager_completion      d4be98
set -l fish_pager_description     928374
set -l fish_pager_selected_background 45403d
set -l fish_pager_selected_completion d4be98
set -l fish_pager_selected_description 928374

# --- Syntax highlighting ---
set -Ux fish_color_normal         $fish_syntax_normal
set -Ux fish_color_command        $fish_syntax_command
set -Ux fish_color_keyword        $fish_syntax_keyword
set -Ux fish_color_option         $fish_syntax_option
set -Ux fish_color_param          $fish_syntax_param
set -Ux fish_color_quote          $fish_syntax_quote
set -Ux fish_color_redirection    $fish_syntax_redirection
set -Ux fish_color_end            $fish_syntax_end
set -Ux fish_color_operator       $fish_syntax_operator
set -Ux fish_color_escape         $fish_syntax_escape
set -Ux fish_color_comment        $fish_syntax_comment --italics
set -Ux fish_color_error          $fish_syntax_error
set -Ux fish_color_autosuggestion $fish_syntax_autosuggestion
set -Ux fish_color_valid_path     $fish_syntax_valid_path --underline
set -Ux fish_color_cancel         $fish_syntax_cancel

# --- Selection & search ---
set -Ux fish_color_selection    --background=$fish_selection_background
set -Ux fish_color_search_match --background=$fish_selection_search_match

# --- Prompt ---
set -Ux fish_color_cwd         $fish_prompt_cwd
set -Ux fish_color_cwd_root    $fish_prompt_cwd_root
set -Ux fish_color_user        $fish_prompt_user
set -Ux fish_color_host        $fish_prompt_host
set -Ux fish_color_host_remote $fish_prompt_host_remote
set -Ux fish_color_status      $fish_prompt_status

# --- Pager (completions) ---
set -Ux fish_pager_color_progress            $fish_pager_progress
set -Ux fish_pager_color_prefix              $fish_pager_prefix
set -Ux fish_pager_color_completion          $fish_pager_completion
set -Ux fish_pager_color_description         $fish_pager_description --dim
set -Ux fish_pager_color_selected_background --background=$fish_pager_selected_background
set -Ux fish_pager_color_selected_completion $fish_pager_selected_completion
set -Ux fish_pager_color_selected_description $fish_pager_selected_description
