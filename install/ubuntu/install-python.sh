source "scripts/functions/execute_remote_script.sh"

print_header "UV: installing"
execute_remote_script "https://astral.sh/uv/install.sh"

print_header "Python: installing"
fish -C "uv python install && exit"
