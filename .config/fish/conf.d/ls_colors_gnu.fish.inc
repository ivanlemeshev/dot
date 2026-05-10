# Select the platform-specific ls color payload.
#
set -l ls_colors_dir (status dirname)

if command -sq gls
    source "$ls_colors_dir/ls_colors_gnu.fish.inc"
else
    switch (uname)
        case Darwin '*BSD'
            source "$ls_colors_dir/ls_colors_bsd.fish.inc"
        case Linux
            source "$ls_colors_dir/ls_colors_gnu.fish.inc"
    end
end

set -gx __fish_ls_command ls
set -gx __fish_ls_color_opt --color=always
