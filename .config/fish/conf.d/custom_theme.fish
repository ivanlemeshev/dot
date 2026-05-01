# Color theme for fish shell

# --- Semantic roles ---
set -l fish_background                 1d1f21
set -l fish_foreground                 c5c8c6
set -l fish_muted                      969896
set -l fish_normal                     c5c8c6
set -l fish_command                    81a2be
set -l fish_keyword                    cc6666
set -l fish_option                     8abeb7
set -l fish_param                      8abeb7
set -l fish_quote                      f0c674
set -l fish_redirection                8abeb7
set -l fish_end                        b5bd68
set -l fish_operator                   8abeb7
set -l fish_escape                     de935f
set -l fish_comment                    969896
set -l fish_error                      cc6666
set -l fish_autosuggestion             969896
set -l fish_valid_path                 81a2be
set -l fish_cancel                     cc6666
set -l fish_selection_background       373b41
set -l fish_selection_search_match     f0c674
set -l fish_cwd                        b5bd68
set -l fish_cwd_root                   cc6666
set -l fish_user                       b5bd68
set -l fish_host                       81a2be
set -l fish_host_remote                de935f
set -l fish_status                     cc6666
set -l fish_pager_progress             969896
set -l fish_pager_prefix               f0c674
set -l fish_pager_completion           c5c8c6
set -l fish_pager_description          c5c8c6
set -l fish_pager_selected_background  373b41
set -l fish_pager_selected_completion  c5c8c6
set -l fish_pager_selected_description ffffff

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
