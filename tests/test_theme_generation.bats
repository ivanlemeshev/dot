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
  cp "$PROJECT_ROOT/macos/iterm2/custom-color-theme.itermcolors" "$TEST_ROOT/macos/iterm2/custom-color-theme.itermcolors"
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "apply-color-scheme updates generated theme files" {
  run bash "$TEST_ROOT/bin/apply-color-scheme" "$TEST_ROOT/color/themes/gruvbox-dark-material.yaml"
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
  [ -s "$TEST_ROOT/macos/iterm2/custom-color-theme.itermcolors" ]

  grep -q 'M.syntax = {' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'hl("Comment", { fg = s.comment, italic = true })' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'hl("DiagnosticError", { fg = d.error })' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'hl("StatusLine", { fg = sem.status_fg, bg = sem.status_bg })' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'hl("TabLineSel", { fg = ui.bg, bg = ui.fg })' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'M.tool = {' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'prompt = "#d8a657"' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'M.semantic = {' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'M.fzf = {' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'prompt = "#e78a4e"' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'a = { bg = M.statusline.normal_bg, fg = M.statusline.normal_fg }' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'a = { bg = M.statusline.insert_bg, fg = M.statusline.insert_fg }' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'TabLineSel", { fg = ui.bg, bg = ui.fg }' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'WinBar", { fg = ui.bg, bg = ui.fg }' "$TEST_ROOT/.config/nvim/lua/lem/colorscheme.lua"
  grep -q 'let s:ui_bg = "282828"' "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q 'let s:statusline_normal_bg = "d4be98"' "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('StatusLine',       s:semantic_status_fg, s:semantic_status_bg)" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('StatusLineNC',     s:semantic_status_inactive_fg, s:semantic_status_bg)" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('TabLineSel',       s:ui_bg, s:ui_fg)" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('Conditional',  s:syntax_keyword, '',      'italic')" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('Typedef',      s:syntax_type, '',      'italic')" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('Special',      s:syntax_special, '')" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('SpecialChar',  s:syntax_escape, '')" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('Question',     s:diagnostic_info, '')" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('Directory',    s:semantic_directory, '')" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -q "call s:hl('SpellLocal',   '',      '',      'undercurl', s:diagnostic_ok)" "$TEST_ROOT/.config/vim/colors/custom.vim"
  grep -Fq 'set -g status-style "bg=#{@tmux_bar_bg},fg=#{@tmux_bar_fg}"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g window-status-current-style "bg=#{@tmux_block_bg},fg=#{@tmux_block_fg},bold"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g window-status-current-format "#{?window_bell_flag,#{#[bg=#{@tmux_bell_bg},fg=#{@tmux_bell_fg},bold] #I:#W:#{window_flags} },#{#[bg=#{@tmux_block_bg},fg=#{@tmux_block_fg},bold] #I:#W:#{window_flags} }}"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g window-status-bell-style "bg=#{@tmux_bell_bg},fg=#{@tmux_bell_fg},bold"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g @tmux_bell_bg "#d8a657"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g @tmux_bell_fg "#282828"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g pane-active-border-style "fg=#{@tmux_border_active_fg}"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g status-left "#{?client_prefix,#{#[bg=#{@tmux_alert_bg},fg=#{@tmux_alert_fg},bold] #S },#{#[bg=#{@tmux_block_bg},fg=#{@tmux_block_fg}] #S }}"' "$TEST_ROOT/.config/tmux/.tmux.conf"
  grep -Fq 'set -g status-right " #{?client_prefix,#{#[bg=#{@tmux_alert_bg},fg=#{@tmux_alert_fg}] %Y-%m-%d %H:%M },#{#[bg=#{@tmux_block_bg},fg=#{@tmux_block_fg}] %Y-%m-%d %H:%M }}"' "$TEST_ROOT/.config/tmux/.tmux.conf"
}

@test "template-driven generators can render missing target files from scratch" {
  rm -f "$TEST_ROOT/.config/oh-my-posh/theme.omp.json"
  rm -f "$TEST_ROOT/.config/bat/themes/custom.tmTheme"

  run python3 "$TEST_ROOT/color/generators/apply-omp-theme.py" \
    "$TEST_ROOT/color/themes/gruvbox-dark-material.yaml" \
    "$TEST_ROOT/.config/oh-my-posh/theme.omp.json"
  [ "$status" -eq 0 ]

  run python3 "$TEST_ROOT/color/generators/apply-tmtheme.py" \
    "$TEST_ROOT/color/themes/gruvbox-dark-material.yaml" \
    "$TEST_ROOT/.config/bat/themes/custom.tmTheme"
  [ "$status" -eq 0 ]

  [ -f "$TEST_ROOT/.config/oh-my-posh/theme.omp.json" ]
  [ -f "$TEST_ROOT/.config/bat/themes/custom.tmTheme" ]

  [ -s "$TEST_ROOT/.config/oh-my-posh/theme.omp.json" ]
  [ -s "$TEST_ROOT/.config/bat/themes/custom.tmTheme" ]
}
