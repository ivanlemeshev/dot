print_header "Lazygit: installing version"
go install github.com/jesseduffield/lazygit@latest
[[ ! -d "${HOME}/.config/lazygit" ]] && mkdir -p "${HOME}/.config/lazygit"
ln -sf "${PWD}/lazygit/config.yml" "${HOME}/.config/lazygit/config.yml"
