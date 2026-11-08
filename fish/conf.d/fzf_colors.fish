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
    "--multi" \
    "--highlight-line" \
    "--no-bold"

set -l colors "16,fg:7,bg:0,hl:3,fg+:0:strip,bg+:4,hl+:0:strip:underline,selected-fg:0:strip,selected-bg:4,selected-hl:0:strip:underline,query:7,ghost:8,disabled:8,info:8,border:8,prompt:3,pointer:0,marker:0,spinner:3,header:8,label:8,gutter:0"

set -x FZF_DEFAULT_OPTS (string join -- " " "--color=$colors" $ui)
