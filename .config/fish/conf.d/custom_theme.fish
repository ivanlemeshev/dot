# Custom theme for fish shell

# --- Custom palette ---
set -l bg0     282828
set -l bg1     32302f
set -l bg2     45403d
set -l fg0     d4be98
set -l fg1     ddc7a1
set -l gray    7c6f64
set -l red     ea6962
set -l yellow  d8a657
set -l green   a9b665
set -l blue    7daea3
set -l magenta d3869b
set -l cyan    89b482

# --- Syntax highlighting ---
set -Ux fish_color_normal         $fg0
set -Ux fish_color_command        $blue
set -Ux fish_color_keyword        $magenta
set -Ux fish_color_option         $yellow
set -Ux fish_color_param          $red
set -Ux fish_color_quote          $green
set -Ux fish_color_redirection    $cyan
set -Ux fish_color_end            $magenta
set -Ux fish_color_operator       $yellow
set -Ux fish_color_escape         $cyan
set -Ux fish_color_comment        $gray --italics
set -Ux fish_color_error          $red
set -Ux fish_color_autosuggestion $fg1
set -Ux fish_color_valid_path     $blue --underline
set -Ux fish_color_cancel         $red

# --- Selection & search ---
set -Ux fish_color_selection    --background=$bg2
set -Ux fish_color_search_match --background=$bg2

# --- Prompt ---
set -Ux fish_color_cwd         $blue
set -Ux fish_color_cwd_root    $red
set -Ux fish_color_user        $fg0
set -Ux fish_color_host        $blue
set -Ux fish_color_host_remote $yellow
set -Ux fish_color_status      $red

# --- Pager (completions) ---
set -Ux fish_pager_color_progress            $gray
set -Ux fish_pager_color_prefix              $yellow
set -Ux fish_pager_color_completion          $fg0
set -Ux fish_pager_color_description         $gray --dim
set -Ux fish_pager_color_selected_background --background=$bg2
set -Ux fish_pager_color_selected_completion $fg0
set -Ux fish_pager_color_selected_description $gray
