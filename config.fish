# Disable fish greeting
set fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Enable starship prompt
starship init fish | source

# Add gcloud to PATH
if test -f /usr/local/google-cloud-sdk/path.fish.inc
    source /usr/local/google-cloud-sdk/path.fish.inc
end

# Golang
set -x GOROOT "/usr/local/go"
set -x GOPATH "$HOME/go"
set -x PATH "$PATH:$GOPATH/bin:$GOROOT/bin"

# Nvim
set -x PATH "$PATH:/opt/nvim-linux64/bin"
