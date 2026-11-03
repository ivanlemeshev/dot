set -gx LS_COLORS "di=34:ln=36:or=31:mi=31:ex=32:pi=33:so=35:bd=33;1:cd=33;1"

if test (uname) = Darwin; and command -sq gls
    set -gx __fish_ls_command gls
    set -gx __fish_ls_color_opt --color=auto
end
