# Color theme for fish shell

# --- Semantic roles ---
set -l fish_background                 121110
set -l fish_foreground                 e8e3df
set -l fish_muted                      716b66
set -l fish_normal                     e8e3df
set -l fish_command                    87a8ba
set -l fish_keyword                    bd8f9f
set -l fish_option                     8fbab2
set -l fish_param                      8fbab2
set -l fish_quote                      e9ba77
set -l fish_redirection                8fbab2
set -l fish_end                        bd8f9f
set -l fish_operator                   8fbab2
set -l fish_escape                     d9a15f
set -l fish_comment                    716b66
set -l fish_error                      c8785b
set -l fish_autosuggestion             716b66
set -l fish_valid_path                 87a8ba
set -l fish_cancel                     c8785b
set -l fish_selection_background       30221d
set -l fish_selection_search_match     e9ba77
set -l fish_cwd                        aab28a
set -l fish_cwd_root                   c8785b
set -l fish_user                       aab28a
set -l fish_host                       87a8ba
set -l fish_host_remote                d9a15f
set -l fish_status                     c8785b
set -l fish_pager_progress             716b66
set -l fish_pager_prefix               e9ba77
set -l fish_pager_completion           e8e3df
set -l fish_pager_description          e8e3df
set -l fish_pager_selected_background  30221d
set -l fish_pager_selected_completion  e8e3df
set -l fish_pager_selected_description e8e3df

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
