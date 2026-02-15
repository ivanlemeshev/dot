# Custom theme for fish shell
# Based on: https://github.com/sainnhe/gruvbox-material

# --- Custom palette (retro amber-tinted for vintage feel) ---
set -l bg0    262220
set -l bg1    352e2a
set -l bg5    685d52
set -l fg0    d4b888
set -l fg1    dcc092
set -l grey0  7c6f64
set -l grey1  9a8a74
set -l red    c97060
set -l orange cc8850
set -l yellow c7a268
set -l green  a2ab70
set -l aqua   8ead89
set -l blue   84a79f
set -l purple c990a0

# --- Syntax highlighting ---
set -g fish_color_normal        $fg0
set -g fish_color_command       $green --bold
set -g fish_color_keyword       $purple
set -g fish_color_option        $green
set -g fish_color_param         $fg1
set -g fish_color_quote         $yellow
set -g fish_color_redirection   $blue
set -g fish_color_end           $green
set -g fish_color_operator      $blue
set -g fish_color_escape        $aqua
set -g fish_color_comment       $grey0 --italics
set -g fish_color_error         $red
set -g fish_color_autosuggestion $bg5
set -g fish_color_valid_path    --underline
set -g fish_color_cancel        $red

# --- Selection & search ---
set -g fish_color_selection     --background=$bg1
set -g fish_color_search_match  --background=$bg1

# --- Prompt ---
set -g fish_color_cwd           $blue
set -g fish_color_cwd_root      $red
set -g fish_color_user          $fg1
set -g fish_color_host          $blue
set -g fish_color_host_remote   $orange
set -g fish_color_status        $red

# --- Pager (completions) ---
set -g fish_pager_color_progress    $grey1
set -g fish_pager_color_prefix      $yellow --bold
set -g fish_pager_color_completion  $fg0
set -g fish_pager_color_description $grey0
set -g fish_pager_color_selected_background --background=$bg1
