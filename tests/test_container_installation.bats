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

@test "Fedora test sets machine and KDE font values" {
  grep -q -- '--env MACHINE_NAME=dotfiles-test' \
    "$PROJECT_ROOT/tests/container/run.sh"
  grep -q -- '--env KDE_TERMINAL_FONT=' \
    "$PROJECT_ROOT/tests/container/run.sh"
  grep -q 'Font=\$KDE_TERMINAL_FONT' \
    "$PROJECT_ROOT/tests/container/verify-installation.sh"
}

@test "container images use a fixed non-conflicting test user ID" {
  for platform in ubuntu fedora-kde; do
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
