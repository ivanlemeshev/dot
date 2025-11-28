print_header "Congiguring: shell prompt"

print_header "Installing: starship"
brew install starship

print_header "Linking configs: starship"
[[ -d "${HOME}/.config" ]] || mkdir -p "${HOME}/.config"
ln -sf "${PWD}/starship.toml" "${HOME}/.config/starship.toml"
