# Custom theme for fish shell

# --- Custom palette ---
set -l bg0     181616
set -l bg1     a6a69c
set -l fg0     c5c9c5
set -l fg1     c5c9c5
set -l red     c4746e
set -l yellow  c4b28a
set -l green   8a9a7b
set -l blue    8ba4b1
set -l magenta a292a3
set -l cyan    8ea4a2

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
