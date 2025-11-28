print_header "Installing: WezTerm"
brew install --cask wezterm@nightly
ln -sf "${PWD}/.wezterm.lua" "${HOME}/.wezterm.lua"
