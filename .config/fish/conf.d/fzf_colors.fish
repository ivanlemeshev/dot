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

set -l colors "16,fg:7,bg:0,hl:11,fg+:0:strip,bg+:4,hl+:0:strip:underline,info:4,border:8,prompt:3,pointer:11,marker:13,spinner:3,header:8,label:7,gutter:0"

set -x FZF_DEFAULT_OPTS (string join -- " " "--color=$colors" $ui)
