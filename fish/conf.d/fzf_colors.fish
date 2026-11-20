set -l palette_state "$HOME/.local/state/dotfiles-palette"
if set -q DOTFILES_PALETTE_STATE
    set palette_state "$DOTFILES_PALETTE_STATE"
end
set -gx DOTFILES_COLOR_STYLE standard
if test -f "$palette_state/selection"; and string match -q 'min-*' (string trim < "$palette_state/selection")
    set -gx DOTFILES_COLOR_STYLE minimal
end
set -eg BAT_THEME
set -gx BAT_CONFIG_PATH "$palette_state/style/bat/config"
set -gx RIPGREP_CONFIG_PATH "$palette_state/style/ripgrep/config"

set -l ui \
    "--border 'sharp'" \
    "--border-label ''" \
    "--preview-window 'border-sharp'" \
    "--prompt '> '" \
    "--marker '>'" \
    "--pointer '◆'" \
    "--separator '─'" \
    "--scrollbar '█'" \
    "--layout 'reverse'" \
    "--info 'right'" \
    --multi \
    --highlight-line \
    --no-bold

set -l colors "16,fg:7,bg:0,hl:3,fg+:0:strip,bg+:4,hl+:0:strip:underline,selected-fg:0:strip,selected-bg:4,selected-hl:0:strip:underline,query:7,ghost:8,disabled:8,info:8,border:8,prompt:3,pointer:0,marker:0,spinner:3,header:8,label:8,gutter:0"

if test "$DOTFILES_COLOR_STYLE" = minimal
    set colors (string replace -a 'prompt:3' 'prompt:7' -- "$colors")
    set colors (string replace -a 'spinner:3' 'spinner:7' -- "$colors")
end

set -x FZF_DEFAULT_OPTS (string join -- " " "--color=$colors" $ui)
