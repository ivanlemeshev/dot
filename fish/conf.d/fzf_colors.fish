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
    set prompt_color -1
    set spinner_color 8
end
set -l colors "16,fg:-1,bg:-1,hl:3,fg+:-1:strip:reverse,bg+:-1,hl+:-1:strip:reverse:underline,selected-fg:-1:strip:reverse,selected-bg:-1,selected-hl:-1:strip:reverse:underline,query:-1,ghost:8,disabled:8,info:8,border:8,prompt:$prompt_color,pointer:4,marker:4,spinner:$spinner_color,header:8,label:8,gutter:-1"

set -x FZF_DEFAULT_OPTS (string join -- " " "--color=$colors" $ui)
