# Custom theme for fish shell

# --- Custom palette ---
set -l bg0    191919
set -l bg1    404040
set -l bg5    3d3839
set -l fg0    bbbbbb
set -l fg1    c9c9c9
set -l grey0  8e8e8e
set -l grey1  8e8e8e
set -l red    de6e7c
set -l yellow b77e64
set -l green  819b69
set -l aqua   66a5ad
set -l blue   6099c0
set -l purple b279a7

# --- Syntax highlighting ---
set -g fish_color_normal         $fg0
set -g fish_color_command        $green --bold
set -g fish_color_keyword        $purple
set -g fish_color_option         $green
set -g fish_color_param          $fg1
set -g fish_color_quote          $yellow
set -g fish_color_redirection    $blue
set -g fish_color_end            $green
set -g fish_color_operator       $blue
set -g fish_color_escape         $aqua
set -g fish_color_comment        $grey0 --italics
set -g fish_color_error          $red
set -g fish_color_autosuggestion $grey0
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
set -g fish_pager_color_progress            $grey1
set -g fish_pager_color_prefix              $yellow --bold
set -g fish_pager_color_completion          $fg0
set -g fish_pager_color_description         $grey0
set -g fish_pager_color_selected_background --background=$bg1
