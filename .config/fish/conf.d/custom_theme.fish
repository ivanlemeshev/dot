# Custom theme for fish shell

# --- Custom palette ---
set -l bg0     232b30
set -l bg1     5a656f
set -l fg0     ece7d6
set -l fg1     f8f4e3
set -l red     e67e80
set -l yellow  f8c46f
set -l green   a7c080
set -l blue    7fbbb3
set -l magenta e19fb6
set -l cyan    96d0b3

# --- Syntax highlighting ---
set -Ux fish_color_normal         $fg0
set -Ux fish_color_command        $green
set -Ux fish_color_keyword        $magenta
set -Ux fish_color_option         $green
set -Ux fish_color_param          $fg1
set -Ux fish_color_quote          $yellow
set -Ux fish_color_redirection    $blue
set -Ux fish_color_end            $green
set -Ux fish_color_operator       $blue
set -Ux fish_color_escape         $cyan
set -Ux fish_color_comment        $bg1 --italics
set -Ux fish_color_error          $red
set -Ux fish_color_autosuggestion $bg1
set -Ux fish_color_valid_path     --underline
set -Ux fish_color_cancel         $red

# --- Selection & search ---
set -Ux fish_color_selection    --background=$bg1
set -Ux fish_color_search_match --background=$bg1

# --- Prompt ---
set -Ux fish_color_cwd         $blue
set -Ux fish_color_cwd_root    $red
set -Ux fish_color_user        $fg1
set -Ux fish_color_host        $blue
set -Ux fish_color_host_remote $yellow
set -Ux fish_color_status      $red

# --- Pager (completions) ---
set -Ux fish_pager_color_progress            $bg1
set -Ux fish_pager_color_prefix              $yellow
set -Ux fish_pager_color_completion          $fg0
set -Ux fish_pager_color_description         $bg1
set -Ux fish_pager_color_selected_background --background=$bg1
