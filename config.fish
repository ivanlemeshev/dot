# Disable fish greeting
set fish_greeting

set -l os (uname)

abbr --add unset 'set --erase'

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Add gcloud to PATH
if test -f /usr/local/google-cloud-sdk/path.fish.inc
    source /usr/local/google-cloud-sdk/path.fish.inc
end

# Set vim as default editor
# https://fishshell.com/docs/current/faq.html#why-doesn-t-set-ux-exported-universal-variables-seem-to-work
set -gx EDITOR vim

if test "$os" = Linux
    # Golang
    set -x GOROOT /usr/local/go
    set -x GOPATH "$HOME/go"
    set -x PATH "$PATH:$GOPATH/bin:$GOROOT/bin"
end

# Add local bin to PATH
set -x PATH "$PATH:$HOME/.local/bin"

# Nvim
set -x PATH "$PATH:/opt/nvim-linux64/bin"

# Add bat theme
set -x BAT_THEME CatppuccinMacchiato

# Set colors for ls, fd, etc
set -x LS_COLORS "$(vivid generate catppuccin-macchiato)"

# Set colors for fzf
set -x FZF_DEFAULT_OPTS "\
--color=fg:#cad3f5,fg+:#cad3f5 \
--color=bg:#24273a,bg+:#363a4f \
--color=hl:#ed8796,hl+:#ed8796 \
--color=info:#c6a0f6,marker:#b7bdf8 \
--color=prompt:#c6a0f6,spinner:#f4dbd6 \
--color=pointer:#f4dbd6,header:#ed8796 \
--color=border:#363a4f,label:#cad3f5,query:#f4dbd6 \
--border='rounded' --border-label='' --preview-window='border-rounded' \
--prompt='> ' --marker='>' --pointer='◆' --separator='─' --scrollbar='│' \
--layout='reverse' --info='right' --multi"

# Enable starship prompt
starship init fish | source

# enable mise
mise activate fish | source

# Aliases

# kubectl
alias k="kubectl"
alias k-ctx="kubectl config current-context"
alias k-ctx-list="kubectl config get-contexts -o name"
alias k-ctx-use="kubectl config use-context"

# yt dlp
alias yd-mp3="yt-dlp --verbose --extract-audio --audio-format mp3 --audio-quality 0 --output '%(title)s.%(ext)s'"

# Download the best mp4 video available, or the best video if no mp4 available
alias yd-video-lq="yt-dlp -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / bv[height<=360]*+ba/b' -o '%(title)s.%(ext)s'"
alias yd-video-aq="yt-dlp -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / bv[height<=720]*+ba/b' -o '%(title)s.%(ext)s'"
alias yd-video-gq="yt-dlp -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / bv[height<=1080]*+ba/b' -o '%(title)s.%(ext)s'"
alias yd-video-bq="yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' -o '%(title)s.%(ext)s'"

alias yd-playlist-lq="yt-dlp -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / bv*[height<=360]+ba/b' -o '%(playlist_index)s - %(title)s.%(ext)s'"
alias yd-playlist-aq="yt-dlp -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / bv*[height<=720]+ba/b' -o '%(playlist_index)s - %(title)s.%(ext)s'"
alias yd-playlist-gq="yt-dlp -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / bv*[height<=1080]+ba/b' -o '%(playlist_index)s - %(title)s.%(ext)s'"
alias yd-playlist-bq="yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' -o '%(playlist_index)s - %(title)s.%(ext)s'"

# bat
if test "$os" = Linux
    alias bat="batcat"
end
