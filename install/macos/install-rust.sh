source "scripts/functions/execute_remote_script.sh"

print_header "Installing: Rust"
execute_remote_script "https://sh.rustup.rs"
source "$HOME/.cargo/env.fish"
rustup completions fish >~/.config/fish/completions/rustup.fish
