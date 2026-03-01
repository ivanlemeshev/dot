# Custom theme for fish shell

# --- Custom palette ---
set -l bg0     292522
set -l bg1     867462
set -l fg0     ece1d7
set -l fg1     ece1d7
set -l red     bd8183
set -l yellow  ebc06d
set -l green   78997a
set -l blue    7f91a3
set -l magenta b380b0
set -l cyan    7b9695

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
