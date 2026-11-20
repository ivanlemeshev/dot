# Extract MP3 audio at the highest quality setting.
function yd-mp3 {
    yt-dlp --verbose `
        --extract-audio `
        --audio-format mp3 `
        --audio-quality 0 `
        --output '%(title)s.%(ext)s' `
        @args
}

# Extract M4A audio at the highest quality setting.
function yd-m4a {
    yt-dlp --verbose `
        --extract-audio `
        --audio-format m4a `
        --audio-quality 0 `
        --add-metadata `
        --embed-metadata `
        --output '%(title)s.%(ext)s' `
        @args
}

# Extract MP3 audio into one file per chapter.
function yd-mp3c {
    yt-dlp --verbose `
        --extract-audio `
        --audio-format mp3 `
        --audio-quality 0 `
        --output '%(title)s.%(ext)s' `
        --split-chapters `
        @args
}

# Download video at up to 360p.
function yd-video-lq {
    yt-dlp `
        -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4]/bv*[height<=360]+ba/b' `
        -o '%(title)s.%(ext)s' `
        @args
}

# Download video at up to 720p.
function yd-video-aq {
    yt-dlp `
        -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4]/bv*[height<=720]+ba/b' `
        -o '%(title)s.%(ext)s' `
        @args
}

# Download video at up to 1080p.
function yd-video-gq {
    yt-dlp `
        -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4]/bv*[height<=1080]+ba/b' `
        -o '%(title)s.%(ext)s' `
        @args
}

# Download video at the highest available quality.
function yd-video-bq {
    yt-dlp `
        -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/bv*+ba/b' `
        -o '%(title)s.%(ext)s' `
        @args
}

# Download a playlist at up to 360p.
function yd-playlist-lq {
    yt-dlp `
        -f 'bv*[ext=mp4][height<=360]+ba[ext=m4a]/b[ext=mp4]/bv*[height<=360]+ba/b' `
        -o '%(playlist_index)s - %(title)s.%(ext)s' `
        @args
}

# Download a playlist at up to 720p.
function yd-playlist-aq {
    yt-dlp `
        -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4]/bv*[height<=720]+ba/b' `
        -o '%(playlist_index)s - %(title)s.%(ext)s' `
        @args
}

# Download a playlist at up to 1080p.
function yd-playlist-gq {
    yt-dlp `
        -f 'bv*[ext=mp4][height<=1080]+ba[ext=m4a]/b[ext=mp4]/bv*[height<=1080]+ba/b' `
        -o '%(playlist_index)s - %(title)s.%(ext)s' `
        @args
}

# Download a playlist at the highest available quality.
function yd-playlist-bq {
    yt-dlp `
        -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/bv*+ba/b' `
        -o '%(playlist_index)s - %(title)s.%(ext)s' `
        @args
}

# Download playlist audio as MP3.
function yd-playlist-mp3 {
    yt-dlp --verbose `
        --extract-audio `
        --audio-format mp3 `
        --audio-quality 0 `
        --output '%(playlist_index)s - %(title)s.%(ext)s' `
        @args
}

# Download video with Finnish and English subtitles.
function yd-video-fi {
    yt-dlp `
        -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/bv*+ba/b' `
        -o '%(title)s.%(ext)s' `
        --write-subs `
        --sub-langs 'fi.*,en.*' `
        --sub-format 'srt' `
        @args
}

# Download playlist audio as M4A.
function yd-playlist-m4a {
    yt-dlp --verbose `
        --extract-audio `
        --audio-format m4a `
        --audio-quality 0 `
        --add-metadata `
        --embed-metadata `
        --output '%(playlist_index)s - %(title)s.%(ext)s' `
        @args
}
