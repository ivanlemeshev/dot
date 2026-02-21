# Custom theme for fish shell

# --- Custom palette ---
set -l bg0     151515
set -l bg1     505050
set -l fg0     d0d0d0
set -l fg1     f5f5f5
set -l red     ac4142
set -l yellow  f4bf75
set -l green   90a959
set -l blue    6a9fb5
set -l magenta aa759f
set -l cyan    75b5aa

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
