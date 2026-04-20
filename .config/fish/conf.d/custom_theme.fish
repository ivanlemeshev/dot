# Color theme for fish shell

# --- Semantic roles ---
set -l fish_background         1e1e2e
set -l fish_background_alt     181825
set -l fish_foreground         cdd6f4
set -l fish_foreground_alt     bac2de
set -l fish_muted              6c7086
set -l fish_normal             cdd6f4
set -l fish_command            89b4fa
set -l fish_keyword            f38ba8
set -l fish_option             f9e2af
set -l fish_param              74c7ec
set -l fish_quote              a6e3a1
set -l fish_redirection        fab387
set -l fish_end                fab387
set -l fish_operator           74c7ec
set -l fish_escape             fab387
set -l fish_comment            6c7086
set -l fish_error              f38ba8
set -l fish_autosuggestion     bac2de
set -l fish_valid_path          89b4fa
set -l fish_cancel             f38ba8
set -l fish_selection_background  45475a
set -l fish_selection_search_match 45475a
set -l fish_cwd                   89b4fa
set -l fish_cwd_root              f38ba8
set -l fish_user                  cdd6f4
set -l fish_host                  89b4fa
set -l fish_host_remote           fab387
set -l fish_status                f38ba8
set -l fish_pager_progress        6c7086
set -l fish_pager_prefix          fab387
set -l fish_pager_completion      cdd6f4
set -l fish_pager_description     6c7086
set -l fish_pager_selected_background 45475a
set -l fish_pager_selected_completion cdd6f4
set -l fish_pager_selected_description 6c7086

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
set -Ux fish_pager_color_description         $fish_pager_description --dim
set -Ux fish_pager_color_selected_background --background=$fish_pager_selected_background
set -Ux fish_pager_color_selected_completion $fish_pager_selected_completion
set -Ux fish_pager_color_selected_description $fish_pager_selected_description
