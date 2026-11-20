set fish_greeting

set -g fish_vi_force_cursor 1
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_replace underscore
set -g fish_cursor_visual block
set -g fish_cursor_external block

if status is-interactive
    fish_vi_cursor
end

set -gx EDITOR nvim

set -x BAT_THEME custom
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config

set -x XDG_CONFIG_HOME $HOME/.config

set -gx fish_term24bit 1

# NOTE: External clear avoids display errors with iTerm2 and tmux.
function my_clear
    command clear
    commandline -f repaint
end

bind \cl my_clear

set extra_config ~/.config/fish/extra.fish

if test -f $extra_config
    source $extra_config
end

abbr --add unset 'set --erase'
abbr --add ls 'ls -al'

if test (uname -s) = Darwin
    for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew
        if test -x $brew_path
            $brew_path shellenv fish | source
            break
        end
    end
end

fish_add_path $HOME/.local/bin

fish_add_path $HOME/go/bin

# NOTE: Neovim release paths use different names for ARM.
if test (uname -s) = Linux
    set -l nvim_arch (uname -m)
    if test "$nvim_arch" = aarch64
        set nvim_arch arm64
    end
    fish_add_path --append "/opt/nvim-linux-$nvim_arch/bin"
end
fish_add_path $HOME/.julia/bin

if command -q mise
    mise activate fish | source
end

if command -q wt
    wt config shell init fish | source
end

if command -q oh-my-posh
    set -l theme_file "$HOME/.config/oh-my-posh/theme.omp.json"

    if test -f "$theme_file"
        oh-my-posh init fish --config "$theme_file" | source
    end
end

if command -v batcat >/dev/null
    alias bat="batcat"
end

if command -q direnv
    direnv hook fish | source
end

# Extract MP3 audio at the highest quality setting.
alias yd-mp3="yt-dlp --verbose --extract-audio --audio-format mp3 \
    --audio-quality 0 --output '%(title)s.%(ext)s'"

# Extract M4A audio at the highest quality setting.
alias yd-m4a="yt-dlp --verbose --extract-audio --audio-format m4a \
    --audio-quality 0 --add-metadata --embed-metadata \
    --output '%(title)s.%(ext)s'"

# Extract MP3 audio into one file per chapter.
alias yd-mp3c="yt-dlp --verbose --extract-audio --audio-format mp3 \
    --audio-quality 0 --output '%(title)s.%(ext)s' --split-chapters"

# Download video at up to 360p.
alias yd-video-lq="yt-dlp \
    -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / \
    bv[height<=360]*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download video at up to 720p.
alias yd-video-aq="yt-dlp \
    -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / \
    bv[height<=720]*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download video at up to 1080p.
alias yd-video-gq="yt-dlp \
    -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / \
    bv[height<=1080]*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download video at the highest available quality.
alias yd-video-bq="yt-dlp \
    -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download a playlist at up to 360p.
alias yd-playlist-lq="yt-dlp \
    -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / \
    bv*[height<=360]+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download a playlist at up to 720p.
alias yd-playlist-aq="yt-dlp \
    -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / \
    bv*[height<=720]+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download a playlist at up to 1080p.
alias yd-playlist-gq="yt-dlp \
    -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / \
    bv*[height<=1080]*+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download a playlist at the highest available quality.
alias yd-playlist-bq="yt-dlp \
    -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download playlist audio as MP3.
alias yd-playlist-mp3="yt-dlp --verbose --extract-audio --audio-format mp3 \
    --audio-quality 0 --output '%(playlist_index)s - %(title)s.%(ext)s'"

# Download video with Finnish and English subtitles.
alias yd-video-fi="yt-dlp \
    -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
    -o '%(title)s.%(ext)s' \
    --write-subs --sub-langs 'fi.*,en.*' --sub-format 'srt'"

# Download playlist audio as M4A.
alias yd-playlist-m4a="yt-dlp \
    --verbose \
    --extract-audio \
    --audio-format m4a \
    --audio-quality 0 \
    --add-metadata \
    --embed-metadata \
    --output '%(playlist_index)s - %(title)s.%(ext)s'"
