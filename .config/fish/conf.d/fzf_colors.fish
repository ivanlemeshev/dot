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

set -l colors "16,fg:15,bg:0,hl:11,fg+:0:strip,bg+:12,hl+:0:strip:underline,selected-fg:0:strip,selected-bg:12,selected-hl:0:strip:underline,query:15,ghost:7,disabled:7,info:7,border:7,prompt:3,pointer:0,marker:0,spinner:3,header:7,label:7,gutter:0"

set -x FZF_DEFAULT_OPTS (string join -- " " "--color=$colors" $ui)
