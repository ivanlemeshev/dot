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
set -g fish_color_normal         $fg0
set -g fish_color_command        $green
set -g fish_color_keyword        $magenta
set -g fish_color_option         $green
set -g fish_color_param          $fg1
set -g fish_color_quote          $yellow
set -g fish_color_redirection    $blue
set -g fish_color_end            $green
set -g fish_color_operator       $blue
set -g fish_color_escape         $cyan
set -g fish_color_comment        $bg1 --italics
set -g fish_color_error          $red
set -g fish_color_autosuggestion $bg1
set -g fish_color_valid_path     --underline
set -g fish_color_cancel         $red

# --- Selection & search ---
set -g fish_color_selection    --background=$bg1
set -g fish_color_search_match --background=$bg1

# --- Prompt ---
set -g fish_color_cwd         $blue
set -g fish_color_cwd_root    $red
set -g fish_color_user        $fg1
set -g fish_color_host        $blue
set -g fish_color_host_remote $yellow
set -g fish_color_status      $red

# --- Pager (completions) ---
set -g fish_pager_color_progress            $bg1
set -g fish_pager_color_prefix              $yellow
set -g fish_pager_color_completion          $fg0
set -g fish_pager_color_description         $bg1
set -g fish_pager_color_selected_background --background=$bg1
