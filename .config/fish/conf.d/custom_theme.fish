# Color theme for fish shell

# --- Semantic roles ---
set -l fish_background                 141413
set -l fish_foreground                 faf9f5
set -l fish_muted                      b0aea5
set -l fish_normal                     faf9f5
set -l fish_command                    5d9b75
set -l fish_keyword                    d97757
set -l fish_option                     5b8db8
set -l fish_param                      5b8db8
set -l fish_quote                      e9a17d
set -l fish_redirection                5b8db8
set -l fish_end                        b76b9d
set -l fish_operator                   58a6ad
set -l fish_escape                     d97757
set -l fish_comment                    b0aea5
set -l fish_error                      c94f4f
set -l fish_autosuggestion             b0aea5
set -l fish_valid_path                 5b8db8
set -l fish_cancel                     c94f4f
set -l fish_selection_background       d97757
set -l fish_selection_search_match     d97757
set -l fish_cwd                        5d9b75
set -l fish_cwd_root                   c94f4f
set -l fish_user                       5d9b75
set -l fish_host                       5b8db8
set -l fish_host_remote                e9a17d
set -l fish_status                     c94f4f
set -l fish_pager_progress             b0aea5
set -l fish_pager_prefix               d97757
set -l fish_pager_completion           faf9f5
set -l fish_pager_description          b0aea5
set -l fish_pager_selected_background  252522
set -l fish_pager_selected_completion  faf9f5
set -l fish_pager_selected_description b0aea5

# --- Syntax highlighting ---
set -Ux fish_color_normal         $fish_normal
set -Ux fish_color_command        $fish_command
set -Ux fish_color_keyword        $fish_keyword
set -Ux fish_color_option         $fish_option
set -Ux fish_color_param          $fish_param
set -Ux fish_color_quote          $fish_quote
set -Ux fish_color_redirection    $fish_redirection
set -Ux fish_color_end            $fish_end
set -Ux fish_color_operator       $fish_operator
set -Ux fish_color_escape         $fish_escape
set -Ux fish_color_comment        $fish_comment --italics
set -Ux fish_color_error          $fish_error
set -Ux fish_color_autosuggestion $fish_autosuggestion
set -Ux fish_color_valid_path     $fish_valid_path --underline
set -Ux fish_color_cancel         $fish_cancel

# --- Selection & search ---
set -Ux fish_color_selection    --background=$fish_selection_background
set -Ux fish_color_search_match --background=$fish_selection_search_match

# --- Prompt ---
set -Ux fish_color_cwd         $fish_cwd
set -Ux fish_color_cwd_root    $fish_cwd_root
set -Ux fish_color_user        $fish_user
set -Ux fish_color_host        $fish_host
set -Ux fish_color_host_remote $fish_host_remote
set -Ux fish_color_status      $fish_status

# --- Pager (completions) ---
set -Ux fish_pager_color_progress            $fish_pager_progress
set -Ux fish_pager_color_prefix              $fish_pager_prefix
set -Ux fish_pager_color_completion          $fish_pager_completion
set -Ux fish_pager_color_description         $fish_pager_description
set -Ux fish_pager_color_selected_background --background=$fish_pager_selected_background
set -Ux fish_pager_color_selected_completion $fish_pager_selected_completion
set -Ux fish_pager_color_selected_description $fish_pager_selected_description
