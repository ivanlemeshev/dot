# Disable fish greeting
set fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Add gcloud to PATH
if test -f /usr/local/google-cloud-sdk/path.fish.inc
    source /usr/local/google-cloud-sdk/path.fish.inc
end

# Set nvim as default editor
# https://fishshell.com/docs/current/faq.html#why-doesn-t-set-ux-exported-universal-variables-seem-to-work
set -gx EDITOR nvim

# Golang
set -x GOROOT "/usr/local/go"
set -x GOPATH "$HOME/go"
set -x PATH "$PATH:$GOPATH/bin:$GOROOT/bin"

# Add local bin to PATH
set -x PATH "$PATH:$HOME/.local/bin"

# Nvim
set -x PATH "$PATH:/opt/nvim-linux64/bin"

# Add bat theme
set -x BAT_THEME "CatppuccinMacchiato"

# Enable starship prompt
starship init fish | source

# enable mise
mise activate fish | source

# Aliases
alias yd-mp3="yt-dlp --verbose --extract-audio --audio-format mp3 --audio-quality 0 --output '%(title)s.%(ext)s'"

# Download the best mp4 video available, or the best video if no mp4 available
alias yd-video="yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' -o '%(title)s.%(ext)s'"
alias yd-video-lq="yt-dlp -f 'best[ext=mp4][height<=360]' -o '%(title)s.%(ext)s'"

alias yd-playlist="yt-dlp -f 'b[ext=mp4][height<=1080]' -o '%(playlist_index)s - %(title)s.%(ext)s'"
alias yd-playlist-lq="yt-dlp -f 'b[ext=mp4][height<=360]' -o '%(playlist_index)s - %(title)s.%(ext)s'"

set -l os (uname)
if test "$os" = Linux
    alias bat="batcat"
end
