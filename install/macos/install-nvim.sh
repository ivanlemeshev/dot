print_header "Installing: neovim"
brew install nvim

ln -sf "${PWD}/nvim" "${HOME}/.config/nvim"
