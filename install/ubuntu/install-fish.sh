source "scripts/functions/prompt_yes_no.sh"

# https://fishshell.com
print_header "Fish: installing"

sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install -y fish

print_header "Fish: changing the default shell"
sudo chsh -s "$(which fish)" "$(whoami)"

print_header "Fish: creating a symbolic link for the fish configuration file"
[[ -d "${HOME}/.config/fish" ]] || mkdir -p "${HOME}/.config/fish"
ln -sf "${PWD}/config.fish" "${HOME}/.config/fish/config.fish"

# https://github.com/PatrickF1/fzf.fish
fzf_fish_version="10.3"
fzf_fish_url="https://github.com/PatrickF1/fzf.fish/archive/refs/tags/v${fzf_fish_version}.tar.gz"
fzf_fish_archive="fzf.fish.tar.gz"

print_header "Fish: installing plugin manager Fisher"
fisher_install_script_path="${HOME}/.config/fish/fisher_install.fish"
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o "${fisher_install_script_path}"
print_header "Fisher installer downloaded to ${fisher_install_script_path}"
if prompt_yes_no "Inspect the script and then press y to continue"; then
    fish -C "source ${fisher_install_script_path} && fisher install jorgebucaran/fisher && exit"
fi

# https://github.com/PatrickF1/fzf.fish
print_header "Fish: fzf.fish"
fish -C "fisher install PatrickF1/fzf.fish && exit"
