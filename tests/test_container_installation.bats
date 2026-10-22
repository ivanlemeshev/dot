#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "container verification checks the Racket runtime version" {
  grep -q 'mise exec -- racket --version' \
    "$PROJECT_ROOT/tests/container/verify-installation.sh"
  ! grep -q 'raco --version' \
    "$PROJECT_ROOT/tests/container/verify-installation.sh"
}

@test "mise pins Node.js without a separate npm tool" {
  grep -q 'node = "24.21.0"' "$PROJECT_ROOT/.config/mise/config.toml"
  ! grep -q '^npm = ' "$PROJECT_ROOT/.config/mise/config.toml"
}

@test "Linux setup verifies the configured Node.js installation" {
  for setup_script in \
    "$PROJECT_ROOT/install/ubuntu/mise.sh" \
    "$PROJECT_ROOT/install/fedora/mise.sh"; do
    grep -q 'install node' "$setup_script"
    grep -q 'where node' "$setup_script"
    grep -q 'exec -- node --version' "$setup_script"
  done
  grep -q 'mise where node' \
    "$PROJECT_ROOT/tests/container/verify-installation.sh"
}

@test "Linux installers allow the tree-sitter package install script" {
  for platform in ubuntu fedora; do
    grep -q -- '--allow-scripts=tree-sitter-cli' \
      "$PROJECT_ROOT/install/$platform/tree-sitter.sh"
  done
}

@test "AlmaLinux bootstrap uses its own GNOME installers" {
  bootstrap_script="$PROJECT_ROOT/bin/bootstrap-almalinux.sh"

  grep -q 'install/almalinux' "$bootstrap_script"
  grep -q 'install/almalinux/keyboard.sh' "$bootstrap_script"
  ! grep -q 'install/fedora' "$bootstrap_script"
  ! grep -q 'konsole.sh' "$bootstrap_script"
  grep -q 'gsettings set org.gnome.desktop.input-sources xkb-options' \
    "$PROJECT_ROOT/install/almalinux/keyboard.sh"
  grep -q 'sudo snap install ghostty --classic' \
    "$PROJECT_ROOT/install/almalinux/ghostty.sh"
  grep -q 'sudo systemctl enable --now snapd.socket' \
    "$PROJECT_ROOT/install/almalinux/ghostty.sh"
}

@test "AlmaLinux installers keep the Fedora scripts' executable modes" {
  for script in \
    bat.sh clean.sh emacs.sh essentials.sh fish.sh fzf.sh gh.sh ghostty.sh \
    git.sh grpcurl.sh keyboard.sh mise.sh nerd-fonts.sh nvim.sh oh-my-posh.sh \
    racket.sh tmux.sh tree-sitter.sh update.sh vim.sh worktrunk.sh yt-dlp.sh; do
    [[ "$(stat -c '%a' "$PROJECT_ROOT/install/almalinux/$script")" == \
      "$(stat -c '%a' "$PROJECT_ROOT/install/fedora/$script")" ]]
  done
  [[ "$(stat -c '%a' "$PROJECT_ROOT/bin/bootstrap-almalinux.sh")" == \
    "$(stat -c '%a' "$PROJECT_ROOT/bin/bootstrap-fedora.sh")" ]]
}

@test "AlmaLinux container test uses its current release image" {
  grep -q '^FROM almalinux:10$' \
    "$PROJECT_ROOT/tests/container/Dockerfile.almalinux"
  grep -q 'almalinux' "$PROJECT_ROOT/tests/container/run.sh"
}

@test "Fedora test sets machine and KDE font values" {
  grep -q -- '--env MACHINE_NAME=dotfiles-test' \
    "$PROJECT_ROOT/tests/container/run.sh"
  grep -q -- '--env KDE_TERMINAL_FONT=' \
    "$PROJECT_ROOT/tests/container/run.sh"
  grep -q 'Font=\$KDE_TERMINAL_FONT' \
    "$PROJECT_ROOT/tests/container/verify-installation.sh"
}

@test "container images use a fixed non-conflicting test user ID" {
  for platform in ubuntu fedora-kde almalinux; do
    dockerfile="$PROJECT_ROOT/tests/container/Dockerfile.$platform"
    grep -q -- '--uid 10001 tester' "$dockerfile"
    grep -q '^USER 10001$' "$dockerfile"
  done
}

@test "container test caches mise data by platform" {
  grep -q 'dotfiles-mise-installs-\$platform' \
    "$PROJECT_ROOT/tests/container/run.sh"
  grep -q 'dotfiles-mise-downloads-\$platform' \
    "$PROJECT_ROOT/tests/container/run.sh"
  grep -q 'volume inspect' "$PROJECT_ROOT/tests/container/run.sh"
  grep -q 'CONTAINER_INSTALL_CACHE' "$PROJECT_ROOT/tests/container/run.sh"
}

@test "container test stops a named container on interrupt" {
  run_script="$PROJECT_ROOT/tests/container/run.sh"

  grep -q 'trap stop_test_container INT TERM' "$run_script"
  grep -q -- '--name "$container_name"' "$run_script"
  grep -q '"\$engine" kill "$container_name"' "$run_script"
}
