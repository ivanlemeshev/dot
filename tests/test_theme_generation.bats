#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  TEST_ROOT="$(mktemp -d /tmp/dot-theme-test-XXXXXX)"

  mkdir -p "$TEST_ROOT/color"
  mkdir -p "$TEST_ROOT/.config/fish/conf.d"
  mkdir -p "$TEST_ROOT/.config/oh-my-posh"
  mkdir -p "$TEST_ROOT/.config/nvim/lua/lem"
  mkdir -p "$TEST_ROOT/macos/iterm2"
  mkdir -p "$TEST_ROOT/.config/tmux"
  mkdir -p "$TEST_ROOT/windows/terminal"

  cp -R "$PROJECT_ROOT/color/." "$TEST_ROOT/color/"
  cp "$PROJECT_ROOT/.config/fish/conf.d/custom_theme.fish" "$TEST_ROOT/.config/fish/conf.d/custom_theme.fish"
  cp "$PROJECT_ROOT/.config/fish/conf.d/fzf_colors.fish" "$TEST_ROOT/.config/fish/conf.d/fzf_colors.fish"
  cp "$PROJECT_ROOT/.config/fish/conf.d/ls_colors.fish" "$TEST_ROOT/.config/fish/conf.d/ls_colors.fish"
  cp "$PROJECT_ROOT/.config/oh-my-posh/theme.omp.json" "$TEST_ROOT/.config/oh-my-posh/theme.omp.json"
  cp "$PROJECT_ROOT/.config/nvim/lua/lem/theme.lua" "$TEST_ROOT/.config/nvim/lua/lem/theme.lua"
  cp "$PROJECT_ROOT/.config/tmux/.tmux.conf" "$TEST_ROOT/.config/tmux/.tmux.conf"
  cp "$PROJECT_ROOT/macos/iterm2/custom-color-theme.itermcolors" "$TEST_ROOT/macos/iterm2/custom-color-theme.itermcolors"
  cp "$PROJECT_ROOT/windows/terminal/settings.json" "$TEST_ROOT/windows/terminal/settings.json"
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "windows terminal generator uses tomorrow night base palette" {
  run python3 "$TEST_ROOT/color/generators/apply-windows-terminal.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/windows/terminal/settings.json"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import json
from pathlib import Path

settings = json.loads(Path("${TEST_ROOT}/windows/terminal/settings.json").read_text(encoding="utf-8"))
scheme = settings["schemes"][0]
theme = settings["themes"][0]
print(scheme["background"])
print(scheme["foreground"])
print(scheme["black"])
print(scheme["brightBlack"])
print(scheme["brightWhite"])
print(scheme["cursorColor"])
print(theme["tab"]["background"])
print(theme["tabRow"]["unfocusedBackground"])
PY
  [ "$status" -eq 0 ]
  [ "$output" = $'#1D1F21\n#C5C8C6\n#1D1F21\n#969896\n#FFFFFF\n#C5C8C6\n#1D1F21FF\n#282A2EFF' ]
}

@test "iterm2 generator uses tomorrow night base palette" {
  run python3 "$TEST_ROOT/color/generators/apply-iterm2.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/macos/iterm2/custom-color-theme.itermcolors"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import json
import plistlib
from pathlib import Path

theme = plistlib.loads(Path("${TEST_ROOT}/macos/iterm2/custom-color-theme.itermcolors").read_bytes())

def hex_color(entry):
    return "#{:02x}{:02x}{:02x}".format(
        round(entry["Red Component"] * 255),
        round(entry["Green Component"] * 255),
        round(entry["Blue Component"] * 255),
    )

print(json.dumps([hex_color(theme[f"Ansi {i} Color"]) for i in range(16)]))
print(hex_color(theme["Background Color"]))
print(hex_color(theme["Foreground Color"]))
print(hex_color(theme["Selection Color"]))
print(hex_color(theme["Selected Text Color"]))
print(hex_color(theme["Cursor Color"]))
print(hex_color(theme["Cursor Text Color"]))
PY
  [ "$status" -eq 0 ]
  [ "$output" = $'["#1d1f21", "#cc6666", "#b5bd68", "#de935f", "#81a2be", "#b294bb", "#8abeb7", "#c5c8c6", "#969896", "#cc6666", "#b5bd68", "#f0c674", "#81a2be", "#b294bb", "#8abeb7", "#ffffff"]\n#1d1f21\n#c5c8c6\n#373b41\n#c5c8c6\n#c5c8c6\n#1d1f21' ]
}

@test "tmux generator uses tomorrow night tmux section" {
  run python3 "$TEST_ROOT/color/generators/apply-tmux.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/tmux/.tmux.conf"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import re
from pathlib import Path

text = Path("${TEST_ROOT}/.config/tmux/.tmux.conf").read_text(encoding="utf-8")
for line in [
    'set -g @tmux_bar_bg           "#282a2e"',
    'set -g @tmux_bar_fg           "#c5c8c6"',
    'set -g @tmux_block_bg         "#c5c8c6"',
    'set -g @tmux_block_fg         "#1d1f21"',
    'set -g @tmux_alert_bg         "#cc6666"',
    'set -g @tmux_alert_fg         "#1d1f21"',
    'set -g @tmux_bell_bg          "#de935f"',
    'set -g @tmux_bell_fg          "#1d1f21"',
    'set -g @tmux_border_fg        "#969896"',
    'set -g @tmux_border_active_fg "#c5c8c6"',
    'set -g @tmux_message_bg       "#282a2e"',
    'set -g @tmux_message_fg       "#c5c8c6"',
    'set -g @tmux_mode_bg          "#282a2e"',
    'set -g @tmux_mode_fg          "#c5c8c6"',
]:
    if line not in text:
        raise SystemExit(f"missing: {line}")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "fzf-lua setup maps picker highlights to fzf groups" {
  run python3 - <<PY
import re
from pathlib import Path

text = Path("${PROJECT_ROOT}/.config/nvim/lua/plugins/search.lua").read_text(encoding="utf-8")
squashed = re.sub(r'\s+', '', text)
for line in [
    'hls = {',
    'normal = "FzfLuaNormal"',
    'border = "FzfLuaBorder"',
    'title = "FzfLuaTitle"',
    'title_flags = "FzfLuaTitleFlags"',
    'backdrop = "FzfLuaBackdrop"',
    'preview_normal = "FzfLuaPreviewNormal"',
    'preview_border = "FzfLuaPreviewBorder"',
    'preview_title = "FzfLuaPreviewTitle"',
    'cursor = "FzfLuaCursor"',
    'cursorline = "FzfLuaCursorLine"',
    'cursorlinenr = "FzfLuaCursorLineNr"',
    'search = "FzfLuaSearch"',
    'scrollborder_e = "FzfLuaScrollBorderEmpty"',
    'scrollborder_f = "FzfLuaScrollBorderFull"',
    'help_normal = "FzfLuaHelpNormal"',
    'help_border = "FzfLuaHelpBorder"',
    'header_bind = "FzfLuaHeaderBind"',
    'header_text = "FzfLuaHeaderText"',
    'buf_name = "FzfLuaBufName"',
    'buf_id = "FzfLuaBufId"',
    'tab_title = "FzfLuaTabTitle"',
    'dir_icon = "FzfLuaDirIcon"',
    'live_prompt = "FzfLuaLivePrompt"',
    'cmd_ex = "FzfLuaCmdEx"',
    'fzf_normal = "FzfLuaFzfNormal"',
    'fzf_match = "FzfLuaFzfMatch"',
    'fzf_border = "FzfLuaFzfBorder"',
    'fzf_pointer = "FzfLuaFzfPointer"',
    'fzf_spinner = "FzfLuaFzfSpinner"',
]:
    if re.sub(r'\s+', '', line) not in squashed:
        raise SystemExit(f"missing block: {line}")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "fish generator uses tomorrow night fish section" {
  run python3 "$TEST_ROOT/color/generators/apply-fish.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/fish/conf.d/custom_theme.fish"
  [ "$status" -eq 0 ]

  run python3 - <<PY
from pathlib import Path

text = Path("${TEST_ROOT}/.config/fish/conf.d/custom_theme.fish").read_text(encoding="utf-8")
for line in [
    'set -l fish_background                 1d1f21',
    'set -l fish_foreground                 c5c8c6',
    'set -l fish_command                    81a2be',
    'set -l fish_keyword                    cc6666',
    'set -l fish_escape                     de935f',
    'set -l fish_autosuggestion             969896',
    'set -l fish_pager_progress             969896',
    'set -l fish_pager_prefix               f0c674',
    'set -l fish_pager_completion           c5c8c6',
    'set -l fish_pager_description          c5c8c6',
    'set -l fish_pager_selected_background  373b41',
    'set -l fish_pager_selected_completion  c5c8c6',
    'set -l fish_pager_selected_description ffffff',
]:
    if line not in text:
        raise SystemExit(f"missing: {line}")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "fish fzf colors generator uses tomorrow night fzf section" {
  run python3 "$TEST_ROOT/color/generators/apply-fish-fzf.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/fish/conf.d/fzf_colors.fish"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import re
from pathlib import Path

text = Path("${TEST_ROOT}/.config/fish/conf.d/fzf_colors.fish").read_text(encoding="utf-8")
checks = {
    r'^set -l fzf_foreground\s+"#C5C8C6"$': 'fzf_foreground',
    r'^set -l fzf_selected_foreground\s+"#FFFFFF"$': 'fzf_selected_foreground',
    r'^set -l fzf_background\s+"#1D1F21"$': 'fzf_background',
    r'^set -l fzf_selected_background\s+"#282A2E"$': 'fzf_selected_background',
    r'^set -l fzf_muted\s+"#969896"$': 'fzf_muted',
    r'^set -l fzf_match\s+"#F0C674"$': 'fzf_match',
    r'^set -l fzf_selected_match\s+"#F0C674"$': 'fzf_selected_match',
    r'^set -l fzf_info\s+"#81A2BE"$': 'fzf_info',
    r'^set -l fzf_border\s+"#969896"$': 'fzf_border',
    r'^set -l fzf_gutter\s+"#1D1F21"$': 'fzf_gutter',
    r'^set -l fzf_query\s+"#C5C8C6"$': 'fzf_query',
    r'^set -l fzf_prompt\s+"#DE935F"$': 'fzf_prompt',
    r'^set -l fzf_pointer\s+"#DE935F"$': 'fzf_pointer',
    r'^set -l fzf_marker\s+"#81A2BE"$': 'fzf_marker',
    r'^set -l fzf_header\s+"#969896"$': 'fzf_header',
    r'^set -l fzf_label\s+"#C5C8C6"$': 'fzf_label',
    r'^set -l fzf_spinner\s+"#DE935F"$': 'fzf_spinner',
}
for pattern, label in checks.items():
    if not re.search(pattern, text, re.MULTILINE):
        raise SystemExit(f"missing: {label}")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "fish ls colors generator uses tomorrow night ls_colors section" {
  run python3 "$TEST_ROOT/color/generators/apply-fish-ls-colors.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/fish/conf.d/ls_colors.fish"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import re
from pathlib import Path

text = Path("${TEST_ROOT}/.config/fish/conf.d/ls_colors.fish").read_text(encoding="utf-8")
checks = {
    r'^set -l ls_foreground\s+"197;200;198"\s+# #c5c8c6$': 'ls_foreground',
    r'^set -l ls_background\s+"29;31;33"\s+# #1d1f21$': 'ls_background',
    r'^set -l ls_error\s+"204;102;102"\s+# #cc6666$': 'ls_error',
    r'^set -l ls_executable\s+"181;189;104"\s+# #b5bd68$': 'ls_executable',
    r'^set -l ls_document\s+"222;147;95"\s+# #de935f$': 'ls_document',
    r'^set -l ls_directory\s+"129;162;190"\s+# #81a2be$': 'ls_directory',
    r'^set -l ls_special\s+"178;148;187"\s+# #b294bb$': 'ls_special',
    r'^set -l ls_media\s+"138;190;183"\s+# #8abeb7$': 'ls_media',
    r'^set -l ls_backup\s+"150;152;150"\s+# #969896$': 'ls_backup',
}
for pattern, label in checks.items():
    if not re.search(pattern, text, re.MULTILINE):
        raise SystemExit(f"missing: {label}")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "fish ls colors config prefers gls on macos" {
  run python3 - <<PY
from pathlib import Path

text = Path("${PROJECT_ROOT}/.config/fish/conf.d/ls_colors.fish").read_text(encoding="utf-8")
if 'set -gx __fish_ls_command gls' not in text:
    raise SystemExit("missing macos gls override")
if 'set -gx __fish_ls_color_opt --color=auto' not in text:
    raise SystemExit("missing macos ls color option")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}

@test "oh-my-posh generator uses tomorrow night omp section" {
  run python3 "$TEST_ROOT/color/generators/apply-omp.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/oh-my-posh/theme.omp.json"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import json
from pathlib import Path

theme = json.loads(Path("${TEST_ROOT}/.config/oh-my-posh/theme.omp.json").read_text(encoding="utf-8"))
prompt = theme["blocks"][0]["segments"]
print(prompt[0]["foreground"])
print(prompt[1]["foreground"])
print(prompt[1]["template"])
print(prompt[2]["foreground"])
print(prompt[3]["foreground"])
print(prompt[4]["foreground"])
print(prompt[4]["foreground_templates"][0])
print(prompt[4]["foreground_templates"][1])
print(prompt[4]["foreground_templates"][2])
print(prompt[5]["foreground"])
print(prompt[6]["foreground"])
print(prompt[6]["foreground_templates"][0])
print(theme["blocks"][1]["segments"][0]["foreground"])
print(theme["blocks"][1]["segments"][0]["template"])
PY
  [ "$status" -eq 0 ]
  [ "$output" = $'#de935f\n#c5c8c6\n{{ if ne .Env.POSH_SESSION_DEFAULT_USER .UserName }}<#b5bd68>{{ .UserName }}</><#c5c8c6>@</></>{{ end }}<#81a2be>{{ .HostName }}</>  \n#cc6666\n#c5c8c6\n#b5bd68\n{{ if or (.Working.Changed) (.Staging.Changed) }}#cc6666{{ end }}\n{{ if gt .Ahead 0 }}#81a2be{{ end }}\n{{ if gt .Behind 0 }}#cc6666{{ end }}\n#f0c674\n#b5bd68\n{{ if gt .Code 0 }}#cc6666{{ end }}\n#c5c8c6\n<#b5bd68>$</>' ]
}

@test "nvim generator updates ui, fzf, and statusline sections" {
  run python3 "$TEST_ROOT/color/generators/apply-nvim.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/nvim/lua/lem/theme.lua"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import re
from pathlib import Path

text = Path("${TEST_ROOT}/.config/nvim/lua/lem/theme.lua").read_text(encoding="utf-8")
squashed = re.sub(r'\s+', '', text)
checks = {
    r'^M\.ui = \{$': 'M.ui = {',
    r'^\s+bg = "#1d1f21",$': 'ui bg',
    r'^\s+color_column = "#282a2e",$': 'ui color_column',
    r'^\s+cursor = "#c5c8c6",$': 'ui cursor',
    r'^\s+cursor_column = "#282a2e",$': 'ui cursor_column',
    r'^\s+cursor_line = "#282a2e",$': 'ui cursor_line',
    r'^\s+cursor_line_nr = "#282a2e",$': 'ui cursor_line_nr',
    r'^\s+cur_search_bg = "#de935f",$': 'ui cur_search_bg',
    r'^\s+cur_search_fg = "#1d1f21",$': 'ui cur_search_fg',
    r'^\s+directory_fg = "#81a2be",$': 'ui directory_fg',
    r'^\s+end_of_buffer_fg = "#969896",$': 'ui end_of_buffer_fg',
    r'^\s+error_fg = "#cc6666",$': 'ui error_fg',
    r'^\s+float_bg = "#1d1f21",$': 'ui float_bg',
    r'^\s+float_border_fg = "#969896",$': 'ui float_border_fg',
    r'^\s+float_fg = "#c5c8c6",$': 'ui float_fg',
    r'^\s+float_title_fg = "#c5c8c6",$': 'ui float_title_fg',
    r'^\s+folded_bg = "#282a2e",$': 'ui folded_bg',
    r'^\s+folded_fg = "#969896",$': 'ui folded_fg',
    r'^\s+fg = "#c5c8c6",$': 'ui fg',
    r'^\s+inc_search_bg = "#de935f",$': 'ui inc_search_bg',
    r'^\s+inc_search_fg = "#1d1f21",$': 'ui inc_search_fg',
    r'^\s+line_nr = "#c5c8c6",$': 'ui line_nr',
    r'^\s+matchparen_bg = "#373b41",$': 'ui matchparen_bg',
    r'^\s+mode_fg = "#c5c8c6",$': 'ui mode_fg',
    r'^\s+non_text = "#969896",$': 'ui non_text',
    r'^\s+more_fg = "#de935f",$': 'ui more_fg',
    r'^\s+msg_area_fg = "#c5c8c6",$': 'ui msg_area_fg',
    r'^\s+msg_separator_fg = "#969896",$': 'ui msg_separator_fg',
    r'^\s+pmenu_bg = "#1d1f21",$': 'ui pmenu_bg',
    r'^\s+pmenu_fg = "#c5c8c6",$': 'ui pmenu_fg',
    r'^\s+pmenu_sel_bg = "#282a2e",$': 'ui pmenu_sel_bg',
    r'^\s+pmenu_sel_fg = "#c5c8c6",$': 'ui pmenu_sel_fg',
    r'^\s+pmenu_sbar_bg = "#282a2e",$': 'ui pmenu_sbar_bg',
    r'^\s+pmenu_thumb_bg = "#969896",$': 'ui pmenu_thumb_bg',
    r'^\s+question_fg = "#81a2be",$': 'ui question_fg',
    r'^\s+quickfix_line_bg = "#373b41",$': 'ui quickfix_line_bg',
    r'^\s+search_bg = "#f0c674",$': 'ui search_bg',
    r'^\s+search_fg = "#1d1f21",$': 'ui search_fg',
    r'^\s+selection_bg = "#373b41",$': 'ui selection_bg',
    r'^\s+selection_fg = "#c5c8c6",$': 'ui selection_fg',
    r'^\s+split_fg = "#969896",$': 'ui split_fg',
    r'^\s+statusline_bg = "#c5c8c6",$': 'ui statusline_bg',
    r'^\s+statusline_fg = "#1d1f21",$': 'ui statusline_fg',
    r'^\s+statusline_nc_bg = "#282a2e",$': 'ui statusline_nc_bg',
    r'^\s+statusline_nc_fg = "#c5c8c6",$': 'ui statusline_nc_fg',
    r'^\s+special_key = "#282a2e",$': 'ui special_key',
    r'^\s+tabline_bg = "#282a2e",$': 'ui tabline_bg',
    r'^\s+tabline_fill_bg = "#282a2e",$': 'ui tabline_fill_bg',
    r'^\s+tabline_fg = "#c5c8c6",$': 'ui tabline_fg',
    r'^\s+tabline_sel_bg = "#1d1f21",$': 'ui tabline_sel_bg',
    r'^\s+tabline_sel_fg = "#c5c8c6",$': 'ui tabline_sel_fg',
    r'^\s+title_fg = "#f0c674",$': 'ui title_fg',
    r'^\s+warning_fg = "#de935f",$': 'ui warning_fg',
    r'^\s+winbar_bg = "#282a2e",$': 'ui winbar_bg',
    r'^\s+winbar_fg = "#c5c8c6",$': 'ui winbar_fg',
    r'^\s+winbar_nc_bg = "#282a2e",$': 'ui winbar_nc_bg',
    r'^\s+winbar_nc_fg = "#969896",$': 'ui winbar_nc_fg',
    r'^\s+whitespace = "#282a2e",$': 'ui whitespace',
    r'^M\.syntax = \{$': 'M.syntax = {',
    r'^\s+builtin = "#de935f",$': 'syntax builtin',
    r'^\s+comment = "#969896",$': 'syntax comment',
    r'^\s+constant = "#de935f",$': 'syntax constant',
    r'^\s+delimiter = "#c5c8c6",$': 'syntax delimiter',
    r'^\s+character = "#b5bd68",$': 'syntax character',
    r'^\s+\["function"\] = "#81a2be",$': 'syntax function',
    r'^\s+keyword = "#b294bb",$': 'syntax keyword',
    r'^\s+number = "#de935f",$': 'syntax number',
    r'^\s+operator = "#8abeb7",$': 'syntax operator',
    r'^\s+preproc = "#de935f",$': 'syntax preproc',
    r'^\s+property = "#81a2be",$': 'syntax property',
    r'^\s+special = "#8abeb7",$': 'syntax special',
    r'^\s+special_char = "#8abeb7",$': 'syntax special_char',
    r'^\s+string = "#b5bd68",$': 'syntax string',
    r'^\s+type = "#f0c674",$': 'syntax type',
    r'^\s+variable = "#cc6666",$': 'syntax variable',
    r'^M\.fzf = \{$': 'M.fzf = {',
    r'^\s+fg = "#c5c8c6",$': 'fg',
    r'^\s+bg = "#1d1f21",$': 'bg',
    r'^\s+hl = "#f0c674",$': 'hl',
    r'^\s+\["fg\+"\] = "#ffffff",$': 'fg+',
    r'^\s+\["bg\+"\] = "#282a2e",$': 'bg+',
    r'^\s+\["hl\+"\] = "#f0c674",$': 'hl+',
    r'^\s+info = "#81a2be",$': 'info',
    r'^\s+border = "#969896",$': 'border',
    r'^\s+query = "#c5c8c6",$': 'query',
    r'^\s+prompt = "#de935f",$': 'prompt',
    r'^\s+pointer = "#de935f",$': 'pointer',
    r'^\s+marker = "#81a2be",$': 'marker',
    r'^\s+spinner = "#de935f",$': 'spinner',
    r'^\s+header = "#969896",$': 'header',
    r'^\s+label = "#c5c8c6",$': 'label',
    r'^\s+gutter = "#1d1f21",$': 'gutter',
    r'^M\.statusline = \{$': 'M.statusline = {',
    r'^\s+normal_bg = "#c5c8c6",$': 'normal_bg',
    r'^\s+normal_fg = "#1d1f21",$': 'normal_fg',
    r'^\s+insert_bg = "#b5bd68",$': 'insert_bg',
    r'^\s+insert_fg = "#1d1f21",$': 'insert_fg',
    r'^\s+visual_bg = "#b294bb",$': 'visual_bg',
    r'^\s+visual_fg = "#1d1f21",$': 'visual_fg',
    r'^\s+replace_bg = "#cc6666",$': 'replace_bg',
    r'^\s+replace_fg = "#1d1f21",$': 'replace_fg',
    r'^\s+command_bg = "#de935f",$': 'command_bg',
    r'^\s+command_fg = "#1d1f21",$': 'command_fg',
    r'^\s+terminal_bg = "#81a2be",$': 'terminal_bg',
    r'^\s+terminal_fg = "#1d1f21",$': 'terminal_fg',
    r'^\s+section_bg = "#282a2e",$': 'section_bg',
    r'^\s+section_fg = "#c5c8c6",$': 'section_fg',
    r'^\s+inactive_bg = "#282a2e",$': 'inactive_bg',
    r'^\s+inactive_fg = "#c5c8c6",$': 'inactive_fg',
    r'^M\.git = \{$': 'M.git = {',
    r'^\s+add = "#b5bd68",$': 'git add',
    r'^\s+change = "#de935f",$': 'git change',
    r'^\s+delete = "#cc6666",$': 'git delete',
    r'^\s+rename = "#81a2be",$': 'git rename',
    r'^\s+ignored = "#969896",$': 'git ignored',
    r'^\s+blame = "#969896",$': 'git blame',
    r'^M\.diagnostic = \{$': 'M.diagnostic = {',
    r'^\s+error = "#cc6666",$': 'diagnostic error',
    r'^\s+warn = "#de935f",$': 'diagnostic warn',
    r'^\s+info = "#81a2be",$': 'diagnostic info',
    r'^\s+hint = "#8abeb7",$': 'diagnostic hint',
    r'^\s+ok = "#b5bd68",$': 'diagnostic ok',
    r'^\s+hl\("CmpItemAbbr", \{ fg = M\.ui\.fg \}\)$': 'CmpItemAbbr',
    r'^\s+hl\("CmpItemAbbrDeprecated", \{ fg = M\.ui\.non_text, strikethrough = true \}\)$': 'CmpItemAbbrDeprecated',
    r'^\s+hl\("CmpItemAbbrMatch", \{ fg = M\.ui\.title_fg, bold = true \}\)$': 'CmpItemAbbrMatch',
    r'^\s+hl\("CmpItemKind", \{ fg = M\.syntax\.special \}\)$': 'CmpItemKind',
    r'^\s+\{ "Function", M\.syntax\["function"\] \},$': 'CmpItemKind Function table entry',
    r'^\s+\{ "Folder", M\.ui\.directory_fg \},$': 'CmpItemKind Folder table entry',
    r'^\s+hl\("CmpItemMenu", \{ fg = M\.ui\.non_text \}\)$': 'CmpItemMenu',
    r'^\s+hl\("CopilotSuggestion", \{ fg = M\.ui\.non_text, italic = true \}\)$': 'CopilotSuggestion',
    r'^\s+hl\("CopilotAnnotation", \{ fg = M\.ui\.non_text \}\)$': 'CopilotAnnotation',
}
for pattern, label in checks.items():
    if not re.search(pattern, text, re.MULTILINE):
        raise SystemExit(f"missing: {label}")
for line in [
    'M.ui = {',
    'M.syntax = {',
    'M.fzf = {',
    'M.statusline = {',
    'hl("Normal", { fg = M.ui.fg, bg = M.ui.bg })',
    'hl("NormalNC", { fg = M.ui.fg, bg = M.ui.bg })',
    'hl("Cursor", { fg = M.ui.bg, bg = M.ui.cursor })',
    'hl("CursorLine", { bg = M.ui.cursor_line })',
    'hl("CursorColumn", { bg = M.ui.cursor_column })',
    'hl("CursorLineNr", { bg = M.ui.cursor_line_nr, bold = true })',
    'hl("ColorColumn", { bg = M.ui.color_column })',
    'hl("LineNr", { fg = M.ui.line_nr })',
    'hl("Folded", { fg = M.ui.folded_fg, bg = M.ui.folded_bg })',
    'hl("Search", { fg = M.ui.search_fg, bg = M.ui.search_bg, bold = true })',
    'hl("CurSearch", { fg = M.ui.cur_search_fg, bg = M.ui.cur_search_bg, bold = true })',
    'hl("IncSearch", { fg = M.ui.cur_search_fg, bg = M.ui.inc_search_bg, bold = true })',
    'hl("Visual", { fg = M.ui.selection_fg, bg = M.ui.selection_bg })',
    'hl("VisualNOS", { fg = M.ui.selection_fg, bg = M.ui.selection_bg })',
    'hl("Pmenu", { fg = M.ui.pmenu_fg, bg = M.ui.pmenu_bg })',
    'hl("PmenuSel", { fg = M.ui.pmenu_sel_fg, bg = M.ui.pmenu_sel_bg })',
    'hl("PmenuSbar", { bg = M.ui.pmenu_sbar_bg })',
    'hl("PmenuThumb", { bg = M.ui.pmenu_thumb_bg })',
    'hl("NormalFloat", { fg = M.ui.float_fg, bg = M.ui.float_bg })',
    'hl("FloatBorder", { fg = M.ui.float_border_fg, bg = M.ui.float_bg })',
    'hl("FloatTitle", { fg = M.ui.float_title_fg, bg = M.ui.float_bg, bold = true })',
    'hl("StatusLine", { fg = M.ui.statusline_fg, bg = M.ui.statusline_bg })',
    'hl("StatusLineNC", { fg = M.ui.statusline_nc_fg, bg = M.ui.statusline_nc_bg })',
    'hl("TabLine", { fg = M.ui.tabline_fg, bg = M.ui.tabline_bg })',
    'hl("TabLineSel", { fg = M.ui.tabline_sel_fg, bg = M.ui.tabline_sel_bg, bold = true })',
    'hl("TabLineFill", { bg = M.ui.tabline_fill_bg })',
    'hl("VertSplit", { fg = M.ui.split_fg, bg = M.ui.bg })',
    'hl("WinSeparator", { fg = M.ui.split_fg, bg = M.ui.bg })',
    'hl("WinBar", { fg = M.ui.winbar_fg, bg = M.ui.winbar_bg })',
    'hl("WinBarNC", { fg = M.ui.winbar_nc_fg, bg = M.ui.winbar_nc_bg })',
    'hl("Directory", { fg = M.ui.directory_fg })',
    'hl("Title", { fg = M.ui.title_fg, bold = true })',
    'hl("Question", { fg = M.ui.question_fg, bold = true })',
    'hl("WarningMsg", { fg = M.ui.warning_fg, bold = true })',
    'hl("ErrorMsg", { fg = M.ui.error_fg, bold = true })',
    'hl("ModeMsg", { fg = M.ui.mode_fg })',
    'hl("MoreMsg", { fg = M.ui.more_fg, bold = true })',
    'hl("MsgArea", { fg = M.ui.msg_area_fg, bg = M.ui.bg })',
    'hl("MsgSeparator", { fg = M.ui.msg_separator_fg, bg = M.ui.bg })',
    'hl("MatchParen", { bg = M.ui.matchparen_bg, bold = true })',
    'hl("QuickFixLine", { bg = M.ui.quickfix_line_bg })',
    'hl("EndOfBuffer", { fg = M.ui.end_of_buffer_fg })',
    'hl("NonText", { fg = M.ui.non_text })',
    'hl("SpecialKey", { fg = M.ui.special_key })',
    'hl("MasonBackdrop", { bg = M.ui.bg })',
    'hl("MasonNormal", { fg = M.ui.float_fg, bg = M.ui.float_bg })',
    'hl("MasonHeader", { fg = M.ui.title_fg, bg = M.ui.float_bg, bold = true })',
    'hl("MasonHeaderSecondary", { fg = M.ui.question_fg, bg = M.ui.float_bg, bold = true })',
    'hl("MasonHighlight", { fg = M.ui.directory_fg })',
    'hl("MasonHighlightBlock", { fg = M.ui.bg, bg = M.ui.directory_fg })',
    'hl("MasonHighlightBlockBold", { fg = M.ui.bg, bg = M.ui.directory_fg, bold = true })',
    'hl("MasonHighlightSecondary", { fg = M.ui.title_fg })',
    'hl("MasonHighlightBlockSecondary", { fg = M.ui.bg, bg = M.ui.title_fg })',
    'hl("MasonHighlightBlockBoldSecondary", { fg = M.ui.bg, bg = M.ui.title_fg, bold = true })',
    'hl("MasonLink", { fg = M.ui.directory_fg, underline = true })',
    'hl("MasonMuted", { fg = M.ui.non_text })',
    'hl("MasonMutedBlock", { fg = M.ui.bg, bg = M.ui.non_text })',
    'hl("MasonMutedBlockBold", { fg = M.ui.bg, bg = M.ui.non_text, bold = true })',
    'hl("MasonError", { fg = M.ui.error_fg, bold = true })',
    'hl("MasonWarning", { fg = M.ui.warning_fg, bold = true })',
    'hl("MasonHeading", { fg = M.ui.title_fg, bold = true })',
    'hl("NvimTreeNormal", { fg = M.ui.float_fg, bg = M.ui.float_bg })',
    'hl("NvimTreeNormalFloat", { fg = M.ui.float_fg, bg = M.ui.float_bg })',
    'hl("NvimTreeNormalFloatBorder", { fg = M.ui.float_border_fg, bg = M.ui.float_bg })',
    'hl("NvimTreeLineNr", { fg = M.ui.line_nr })',
    'hl("NvimTreeWinSeparator", { fg = M.ui.split_fg, bg = M.ui.bg })',
    'hl("NvimTreeCursorLine", { bg = M.ui.cursor_line })',
    'hl("NvimTreeCursorLineNr", { bg = M.ui.cursor_line_nr, bold = true })',
    'hl("NvimTreeExecFile", { fg = M.ui.fg })',
    'hl("NvimTreeImageFile", { fg = M.ui.fg })',
    'hl("NvimTreeSpecialFile", { fg = M.ui.fg })',
    'hl("NvimTreeSymlink", { fg = M.ui.fg, underline = true })',
    'hl("NvimTreeFolderName", { fg = M.ui.directory_fg })',
    'hl("NvimTreeRootFolder", { fg = M.ui.title_fg, bold = true })',
    'hl("NvimTreeGitFileNewHL", { fg = M.git.add })',
    'hl("NvimTreeGitFileDirtyHL", { fg = M.git.change })',
    'hl("NvimTreeGitFileDeletedHL", { fg = M.git.delete })',
    'hl("NvimTreeGitFileStagedHL", { fg = M.git.add })',
    'hl("NvimTreeGitNewIcon", { fg = M.git.add })',
    'hl("NvimTreeGitStagedIcon", { fg = M.git.add })',
    'hl("NvimTreeGitRenamedIcon", { fg = M.git.rename })',
    'hl("NvimTreeGitDirtyIcon", { fg = M.git.change })',
    'hl("NvimTreeGitDeletedIcon", { fg = M.git.delete })',
    'hl("NvimTreeGitIgnoredIcon", { fg = M.git.ignored })',
    'hl("GitSignsAdd", { fg = M.git.add })',
    'hl("GitSignsChange", { fg = M.git.change })',
    'hl("GitSignsDelete", { fg = M.git.delete })',
    'hl("GitSignsCurrentLineBlame", { fg = M.git.blame })',
    'hl("DiagnosticError", { fg = M.diagnostic.error })',
    'hl("DiagnosticWarn", { fg = M.diagnostic.warn })',
    'hl("DiagnosticInfo", { fg = M.diagnostic.info })',
    'hl("DiagnosticHint", { fg = M.diagnostic.hint })',
    'hl("DiagnosticOk", { fg = M.diagnostic.ok })',
    'hl("DiagnosticUnderlineError", { sp = M.diagnostic.error, undercurl = true })',
    'hl("DiagnosticSignError", { fg = M.diagnostic.error })',
    'hl("NvimTreeDiagnosticErrorIcon", { fg = M.diagnostic.error })',
    'hl("NvimTreeDiagnosticWarnIcon", { fg = M.diagnostic.warn })',
    'M.fzf_lua = {',
    'hl("FzfLuaNormal", { fg = M.fzf_lua.normal_fg, bg = M.fzf_lua.normal_bg })',
    'hl("FzfLuaBorder", { fg = M.fzf_lua.border_fg, bg = M.fzf_lua.border_bg })',
    'hl("FzfLuaCursorLine", { fg = M.fzf_lua.normal_fg, bg = M.fzf_lua.cursorline_bg })',
    'hl("FzfLuaSearch", { fg = M.fzf_lua.search_fg, bg = M.fzf_lua.search_bg, bold = true })',
    'hl("FzfLuaFzfSpinner", { fg = M.fzf.spinner })',
    'hl("Function", { fg = M.syntax["function"] })',
    'hl("Keyword", { fg = M.syntax.keyword })',
    'hl("Type", { fg = M.syntax.type })',
    'hl("SpecialChar", { fg = M.syntax.special_char })',
    'hl("Todo", { fg = M.syntax.comment, bold = true })',
    'hl("@variable", { fg = M.syntax.variable })',
    'hl("@string.regexp", { fg = M.syntax.special_char })',
    'hl("@function.call", { fg = M.syntax["function"] })',
    'hl("@keyword.conditional", { fg = M.syntax.keyword })',
    'hl("@comment.todo", { fg = M.syntax.comment, bold = true })',
    'hl("@markup.heading.1", { fg = M.syntax.type, bold = true })',
    'hl("@diff.plus", { fg = M.syntax.constant })',
    'hl("@tag.delimiter", { fg = M.syntax.delimiter })',
    'hl("Whitespace", { fg = M.ui.whitespace })',
]:
    if re.sub(r'\s+', '', line) not in squashed:
        raise SystemExit(f"missing block: {line}")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}
