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
set -l selection_fg 0
set -l selection_bg 8
set -l colors_file (path dirname (path dirname (path dirname (path resolve (status filename)))))/palettes/selection-colors.txt
if test -r "$palette_state/selection"; and test -r "$colors_file"
    set -l palette (string trim <"$palette_state/selection")
    while read -l name fg bg
        if test "$name" = "$palette"
            set selection_fg $fg
            set selection_bg $bg
            break
        end
    end <"$colors_file"
end
set -l colors "16,fg:-1,bg:-1,hl:3,fg+:$selection_fg:strip,bg+:$selection_bg,hl+:$selection_fg:strip:underline,selected-fg:$selection_fg:strip,selected-bg:$selection_bg,selected-hl:$selection_fg:strip:underline,query:-1,ghost:8,disabled:8,info:8,border:8,prompt:$prompt_color,pointer:4,marker:4,spinner:$spinner_color,header:8,label:8,gutter:-1"

set -x FZF_DEFAULT_OPTS (string join -- " " "--color=$colors" $ui)
