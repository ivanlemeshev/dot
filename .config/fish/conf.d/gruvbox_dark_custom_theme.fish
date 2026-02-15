# Gruvbox Dark Custom theme for fish shell
# Based on: https://github.com/sainnhe/gruvbox-material

# --- Gruvbox Dark Custom palette (tuned for eye comfort) ---
set -l bg0    292524
set -l bg1    373230
set -l bg5    6b6258
set -l fg0    d4be98
set -l fg1    ddc7a1
set -l grey0  7c6f64
set -l grey1  9d8e7e
set -l red    db6b65
set -l orange d48b58
set -l yellow cfa45e
set -l green  9fb26a
set -l aqua   89b482
set -l blue   7daea3
set -l purple c78a96

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
