# Disable fish greeting
set fish_greeting

# Store OS type in a variable for later use
set -l os (uname)

# Set nvim as default editor
# https://fishshell.com/docs/current/faq.html#why-doesn-t-set-ux-exported-universal-variables-seem-to-work
set -gx EDITOR nvim

# Add bat theme
set -x BAT_THEME gruvbox-dark
# set -x BAT_THEME CatppuccinMocha  # Uncomment to use Catppuccin

# Set colors for ls, fd, etc
set -x LS_COLORS "$(vivid generate gruvbox-dark)"
# set -x LS_COLORS "$(vivid generate catppuccin-mocha)"  # Uncomment to use Catppuccin

# Set colors for fzf (gruvbox-dark)
# Catppuccin colors commented out below
set -x FZF_DEFAULT_OPTS "\
--color fg:#ebdbb2 \
--color fg+:#fbf1c7 \
--color bg:#282828 \
--color bg+:#3c3836 \
--color hl:#fe8019 \
--color hl+:#fe8019 \
--color info:#d79921 \
--color marker:#b8bb26 \
--color prompt:#d79921 \
--color spinner:#8ec07c \
--color pointer:#8ec07c \
--color header:#fe8019 \
--color border:#3c3836 \
--color label:#ebdbb2 \
--color query:#fbf1c7 \
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

# Catppuccin FZF colors (commented out)
# set -x FZF_DEFAULT_OPTS "\
# --color fg:#cdd6f4 \
# --color fg+:#cdd6f4 \
# --color bg:#1e1e2e \
# --color bg+:#313244 \
# --color hl:#f38ba8 \
# --color hl+:#f38ba8 \
# --color info:#cba6f7 \
# --color marker:#b4befe \
# --color prompt:#cba6f7 \
# --color spinner:#f5e0dc \
# --color pointer:#f5e0dc \
# --color header:#f38ba8 \
# --color border:#313244 \
# --color label:#cdd6f4 \
# --color query:#f5e0dc \
# --border 'rounded' \
# --border-label '' \
# --preview-window 'border-rounded' \
# --prompt '> ' \
# --marker '>' \
# --pointer '◆' \
# --separator '─' \
# --scrollbar '█' \
# --layout 'reverse' \
# --info 'right' \
# --multi"

# Path to the additional config file
set extra_config ~/.config/fish/extra.fish

# Check if the file exists, then source it
if test -f $extra_config
    source $extra_config
end

# Set the theme for fish (using fisher and gruvbox)
# fish_config theme choose "Gruvbox"  # Commented out - colors handled by oh-my-posh
# fish_config theme choose "Catppuccin Mocha"  # Uncomment to use Catppuccin

# Set up abbreviations
abbr --add unset 'set --erase'

# Add local bin to PATH
fish_add_path $HOME/.local/bin

# Nvim (Linux-specific installation path)
if test "$os" = Linux
    set -x PATH "$PATH:/opt/nvim-linux-x86_64/bin"
end

# Homebrew (Apple Silicon)
if test "$os" = Darwin
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Activate mise if it's installed
if command -q mise
    mise activate fish | source
end

# ASDF configuration code
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

# Activate oh-my-posh if it's installed
if command -q oh-my-posh
    # Determine theme location based on OS
    set -l theme_file ""

    # Check cache directory (Linux install script location)
    if test -f "$HOME/.cache/oh-my-posh/themes/gruvbox.omp.json"
        set theme_file "$HOME/.cache/oh-my-posh/themes/gruvbox.omp.json"
    # Check Homebrew location (Apple Silicon)
    else if test -f "/opt/homebrew/opt/oh-my-posh/themes/gruvbox.omp.json"
        set theme_file "/opt/homebrew/opt/oh-my-posh/themes/gruvbox.omp.json"
    # Check Homebrew location (Intel)
    else if test -f "/usr/local/opt/oh-my-posh/themes/gruvbox.omp.json"
        set theme_file "/usr/local/opt/oh-my-posh/themes/gruvbox.omp.json"
    end

    # Catppuccin theme paths (commented out)
    # if test -f "$HOME/.cache/oh-my-posh/themes/catppuccin_mocha.omp.json"
    #     set theme_file "$HOME/.cache/oh-my-posh/themes/catppuccin_mocha.omp.json"
    # else if test -f "/opt/homebrew/opt/oh-my-posh/themes/catppuccin_mocha.omp.json"
    #     set theme_file "/opt/homebrew/opt/oh-my-posh/themes/catppuccin_mocha.omp.json"
    # else if test -f "/usr/local/opt/oh-my-posh/themes/catppuccin_mocha.omp.json"
    #     set theme_file "/usr/local/opt/oh-my-posh/themes/catppuccin_mocha.omp.json"
    # end

    if test -n "$theme_file"
        oh-my-posh init fish --config "$theme_file" | source
    end
end

# Aliases

# Use bat alias for batcat if it exists (e.g., on Debian-based systems)
if command -v batcat > /dev/null
    alias bat="batcat"
end

# direnv integration
if command -q direnv
    direnv hook fish | source
end

# yt-dlp aliases for downloading media

# Extract audio as MP3 (best quality)
alias yd-mp3="yt-dlp --verbose --extract-audio --audio-format mp3 \
    --audio-quality 0 --output '%(title)s.%(ext)s'"

# Extract audio as MP3 with chapter splitting
alias yd-mp3c="yt-dlp --verbose --extract-audio --audio-format mp3 \
    --audio-quality 0 --output '%(title)s.%(ext)s' --split-chapters"

# Download video - Low Quality (360p)
alias yd-video-lq="yt-dlp \
    -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / \
    bv[height<=360]*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download video - Average Quality (720p)
alias yd-video-aq="yt-dlp \
    -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / \
    bv[height<=720]*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download video - Good Quality (1080p)
alias yd-video-gq="yt-dlp \
    -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / \
    bv[height<=1080]*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download video - Best Quality (highest available)
alias yd-video-bq="yt-dlp \
    -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
    -o '%(title)s.%(ext)s'"

# Download playlist - Low Quality (360p)
alias yd-playlist-lq="yt-dlp \
    -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4] / \
    bv*[height<=360]+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download playlist - Average Quality (720p)
alias yd-playlist-aq="yt-dlp \
    -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4] / \
    bv*[height<=720]+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download playlist - Good Quality (1080p)
alias yd-playlist-gq="yt-dlp \
    -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4] / \
    bv*[height<=1080]*+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download playlist - Best Quality (highest available)
alias yd-playlist-bq="yt-dlp \
    -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
    -o '%(playlist_index)s - %(title)s.%(ext)s'"

# Download video with Finnish and English subtitles
alias yd-video-fi="yt-dlp \
    -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' \
    -o '%(title)s.%(ext)s' \
    --write-subs --sub-langs 'fi.*,en.*' --sub-format 'srt'"

