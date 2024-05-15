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
