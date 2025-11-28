source "scripts/functions/prompt_yes_no.sh"

print_header "Congiguring: shell"

print_header "Installing: fish"
brew install fish
sudo chsh -s "$(which fish)" "$(whoami)"

print_header "Checking version: fish"
fish -v

print_header "Linking configs: fish"
[[ -d "${HOME}/.config/fish" ]] || mkdir -p "${HOME}/.config/fish"
ln -sf "${PWD}/config.fish" "${HOME}/.config/fish/config.fish"

# https://github.com/jorgebucaran/fisher
print_header "Installing: fisher"
fisher_install_script_path="${HOME}/.config/fish/fisher_install.fish"
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o "${fisher_install_script_path}"
print_header "Fisher installer downloaded to ${fisher_install_script_path}"
if prompt_yes_no "Inspect the script and then press y to continue"; then
    fish -C "source ${fisher_install_script_path} && fisher install jorgebucaran/fisher && exit"
fi


# https://github.com/PatrickF1/fzf.fish
print_header "Installing: PatrickF1/fzf.fish"
fish -C "fisher install PatrickF1/fzf.fish && exit"
