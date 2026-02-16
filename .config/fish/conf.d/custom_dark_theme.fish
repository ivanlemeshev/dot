# Custom Dark theme for fish shell

# --- Custom Dark palette ---
set -l bg0    302824
set -l bg1    3A322D
set -l bg5    655D57
set -l fg0    d4b98d
set -l fg1    ddc296
set -l grey0  806E5A
set -l grey1  968169
set -l red    E67E80
set -l orange E69875
set -l yellow DBBC7F
set -l green  A7C080
set -l aqua   83C092
set -l blue   7FBBB3
set -l purple D699B6

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
