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

set -l palette_state "$HOME/.local/state/dotfiles-palette"
if set -q DOTFILES_PALETTE_STATE[1]; and test -n "$DOTFILES_PALETTE_STATE"
    set palette_state "$DOTFILES_PALETTE_STATE"
end
set -gx DOTFILES_HIGHLIGHT_MODE full
set -l prompt_color 3
set -l spinner_color 3
if test -f "$palette_state/mode"; and string match -q min (string trim <"$palette_state/mode")
    set -gx DOTFILES_HIGHLIGHT_MODE min
    set prompt_color 7
    set spinner_color 8
end
set -l colors "16,fg:7,bg:0,hl:3,fg+:0:strip,bg+:4,hl+:0:strip:underline,selected-fg:0:strip,selected-bg:4,selected-hl:0:strip:underline,query:7,ghost:8,disabled:8,info:8,border:8,prompt:$prompt_color,pointer:0,marker:0,spinner:$spinner_color,header:8,label:8,gutter:0"

set -x FZF_DEFAULT_OPTS (string join -- " " "--color=$colors" $ui)
