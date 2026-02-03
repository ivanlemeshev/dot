# Common fish configuration (platform-agnostic)
# This file contains settings that work across all operating systems

# Disable fish greeting
set fish_greeting

# Abbreviations
abbr --add unset 'set --erase'

# Interactive session commands
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set nvim as default editor
# https://fishshell.com/docs/current/faq.html#why-doesn-t-set-ux-exported-universal-variables-seem-to-work
set -gx EDITOR nvim

# Add local bin to PATH
set -x PATH "$PATH:$HOME/.local/bin"

# Add bat theme
set -x BAT_THEME CatppuccinMocha

# Set colors for ls, fd, etc (requires vivid)
if command -v vivid > /dev/null
    set -x LS_COLORS "$(vivid generate catppuccin-mocha)"
end

# Set colors for fzf (catppuccin-mocha)
set -x FZF_DEFAULT_OPTS "\
--color fg:#cdd6f4 \
--color fg+:#cdd6f4 \
--color bg:#1e1e2e \
--color bg+:#313244 \
--color hl:#f38ba8 \
--color hl+:#f38ba8 \
--color info:#cba6f7 \
--color marker:#b4befe \
--color prompt:#cba6f7 \
--color spinner:#f5e0dc \
--color pointer:#f5e0dc \
--color header:#f38ba8 \
--color border:#313244 \
--color label:#cdd6f4 \
--color query:#f5e0dc \
--border 'rounded' \
--border-label '' \
--preview-window 'border-rounded' \
--prompt '> ' \
--marker '>' \
--pointer '◆' \
--separator '─' \
--scrollbar '█' \
--layout 'reverse' \
--info 'right' \
--multi"

# Aliases

# Set vi to vim if installed
if command -v vim > /dev/null
    alias vi="vim"
end

# Set vi to nvim if installed and override vim alias
if command -v nvim > /dev/null
    alias vi="nvim"
end

# bat (if installed)
if command -v bat > /dev/null
    alias cat="bat"
end

# batcat (if installed, e.g., on Debian-based systems)
if command -v batcat > /dev/null
    alias bat="batcat"
    alias cat="batcat"
end

# kubectl (if installed)
if command -v kubectl > /dev/null
    alias k="kubectl"
    alias k-ctx="kubectl config current-context"
    alias k-ctx-list="kubectl config get-contexts -o name"
    alias k-ctx-use="kubectl config use-context"
end

# yt-dlp (if installed)
if command -v yt-dlp > /dev/null
    # Audio extraction

    # Single mp3 download
    alias yd-mp3="yt-dlp \
        --verbose \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --output '%(title)s.%(ext)s'"

    # Playlist mp3 download
    alias yd-mp3c="yt-dlp \
        --verbose \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --output '%(title)s.%(ext)s' \
        --split-chapters"

    # Single video downloads (quality levels)
    alias yd-video-lq="yt-dlp \
        -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / bv[height<=360]*+ba/b' \
        -o '%(title)s.%(ext)s'" # Low quality (360p)

    alias yd-video-aq="yt-dlp \
        -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / bv[height<=720]*+ba/b' \
        -o '%(title)s.%(ext)s'" # Average quality (720p)

    alias yd-video-gq="yt-dlp \
        -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / bv[height<=1080]*+ba/b' \
        -o '%(title)s.%(ext)s'" # Good quality (1080p)

    alias yd-video-bq="yt-dlp \
        -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
        -o '%(title)s.%(ext)s'" # Best quality (highest available)

    # Playlist downloads (quality levels)
    alias yd-playlist-lq="yt-dlp \
        -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / bv*[height<=360]+ba/b' \
        -o '%(playlist_index)s - %(title)s.%(ext)s'" # Low quality (360p)

    alias yd-playlist-aq="yt-dlp \
        -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / bv*[height<=720]*+ba/b' \
        -o '%(playlist_index)s - %(title)s.%(ext)s'" # Average quality (720p)

    alias yd-playlist-gq="yt-dlp \
        -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / bv*[height<=1080]*+ba/b' \
        -o '%(playlist_index)s - %(title)s.%(ext)s'" # Good quality (1080p)

    alias yd-playlist-bq="yt-dlp \
        -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
        -o '%(playlist_index)s - %(title)s.%(ext)s'" # Best quality (highest available)

    # Video with Finnish and English subtitles
    alias yd-video-fi="yt-dlp \
        -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
        -o '%(title)s.%(ext)s' \
        --write-subs \
        --sub-langs 'fi.*,en.*' \
        --sub-format 'srt'"
end

# Enable starship prompt (if installed)
if command -v starship > /dev/null
    starship init fish | source
end

# ASDF configuration (if installed)
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it potentially changes
# the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end

set --erase _asdf_shims
