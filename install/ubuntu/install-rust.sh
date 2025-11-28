source "scripts/functions/execute_remote_script.sh"

print_header "Rust: installing"
execute_remote_script "https://sh.rustup.rs" -s -- --default-toolchain none -y
. "${HOME}/.cargo/env"

print_header "Rust: setting default toolchain"
rustup default stable

print_header "Rust: adding completions"
[[ -d "${HOME}/.config/fish/completions/" ]] || mkdir -p "${HOME}/.config/fish/completions/"
rustup completions fish >"${HOME}/.config/fish/completions/rustup.fish"
