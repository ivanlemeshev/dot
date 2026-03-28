#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  TEST_ROOT="$(mktemp -d /tmp/dot-theme-test-XXXXXX)"

  mkdir -p "$TEST_ROOT/bin"
  mkdir -p "$TEST_ROOT/color"
  mkdir -p "$TEST_ROOT/.config/fish/conf.d"
  mkdir -p "$TEST_ROOT/.config/bat/themes"
  mkdir -p "$TEST_ROOT/.config/oh-my-posh"
  mkdir -p "$TEST_ROOT/.config/tmux"
  mkdir -p "$TEST_ROOT/.config/vim/colors"
  mkdir -p "$TEST_ROOT/.config/nvim/lua/lem"
  mkdir -p "$TEST_ROOT/windows/terminal"
  mkdir -p "$TEST_ROOT/macos/iterm2"

  cp -R "$PROJECT_ROOT/color/." "$TEST_ROOT/color/"
  cp "$PROJECT_ROOT/bin/apply-color-scheme" "$TEST_ROOT/bin/apply-color-scheme"
  cp "$PROJECT_ROOT/.config/fish/conf.d/custom_theme.fish" "$TEST_ROOT/.config/fish/conf.d/custom_theme.fish"
  cp "$PROJECT_ROOT/.config/fish/conf.d/fzf_colors.fish" "$TEST_ROOT/.config/fish/conf.d/fzf_colors.fish"
  cp "$PROJECT_ROOT/.config/fish/conf.d/ls_colors.fish" "$TEST_ROOT/.config/fish/conf.d/ls_colors.fish"
  cp "$PROJECT_ROOT/.config/bat/themes/custom.tmTheme" "$TEST_ROOT/.config/bat/themes/custom.tmTheme"
  cp "$PROJECT_ROOT/.config/oh-my-posh/theme.omp.json" "$TEST_ROOT/.config/oh-my-posh/theme.omp.json"
  cp "$PROJECT_ROOT/.config/tmux/.tmux.conf" "$TEST_ROOT/.config/tmux/.tmux.conf"
  cp "$PROJECT_ROOT/.config/vim/colors/custom.vim" "$TEST_ROOT/.config/vim/colors/custom.vim"
  cp "$PROJECT_ROOT/.config/nvim/lua/lem/colorscheme.lua" "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  cp "$PROJECT_ROOT/windows/terminal/settings.json" "$TEST_ROOT/windows/terminal/settings.json"
  cp "$PROJECT_ROOT/macos/iterm2/custom-dark.itermcolors" "$TEST_ROOT/macos/iterm2/custom-dark.itermcolors"
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "apply-color-scheme updates generated theme files" {
  run bash "$TEST_ROOT/bin/apply-color-scheme" "$TEST_ROOT/color/schemes/base16-default-dark.yaml"
  [ "$status" -eq 0 ]

  [ -s "$TEST_ROOT/.config/fish/conf.d/custom_theme.fish" ]
  [ -s "$TEST_ROOT/.config/fish/conf.d/fzf_colors.fish" ]
  [ -s "$TEST_ROOT/.config/fish/conf.d/ls_colors.fish" ]
  [ -s "$TEST_ROOT/.config/bat/themes/custom.tmTheme" ]
  [ -s "$TEST_ROOT/.config/oh-my-posh/theme.omp.json" ]
  [ -s "$TEST_ROOT/.config/tmux/.tmux.conf" ]
  [ -s "$TEST_ROOT/.config/vim/colors/custom.vim" ]
  [ -s "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua" ]
  [ -s "$TEST_ROOT/windows/terminal/settings.json" ]
  [ -s "$TEST_ROOT/macos/iterm2/custom-dark.itermcolors" ]
}

@test "template-driven generators can render missing target files from scratch" {
  rm -f "$TEST_ROOT/.config/oh-my-posh/theme.omp.json"
  rm -f "$TEST_ROOT/.config/bat/themes/custom.tmTheme"

  run python3 "$TEST_ROOT/color/generators/apply-omp-theme.py" \
    "$TEST_ROOT/color/schemes/base16-default-dark.yaml" \
    "$TEST_ROOT/.config/oh-my-posh/theme.omp.json"
  [ "$status" -eq 0 ]

  run python3 "$TEST_ROOT/color/generators/apply-tmtheme.py" \
    "$TEST_ROOT/color/schemes/base16-default-dark.yaml" \
    "$TEST_ROOT/.config/bat/themes/custom.tmTheme"
  [ "$status" -eq 0 ]

  [ -f "$TEST_ROOT/.config/oh-my-posh/theme.omp.json" ]
  [ -f "$TEST_ROOT/.config/bat/themes/custom.tmTheme" ]

  [ -s "$TEST_ROOT/.config/oh-my-posh/theme.omp.json" ]
  [ -s "$TEST_ROOT/.config/bat/themes/custom.tmTheme" ]
}
