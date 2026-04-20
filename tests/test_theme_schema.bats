#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  TMPDIR_SCHEMA="$(mktemp -d /tmp/dot-theme-schema-XXXXXX)"
}

teardown() {
  rm -rf "$TMPDIR_SCHEMA"
}

@test "load_theme reads strict semantic scheme colors map" {
  run python3 - <<PY
import json
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

colors = load_theme("${PROJECT_ROOT}/color/schemes/gruvbox-dark-material.yaml", prefix="", uppercase=False)
print(json.dumps({k: colors[k] for k in ("foreground", "background", "brightBlack")}, sort_keys=True))
PY
  [ "$status" -eq 0 ]
  [ "$output" = '{"background": "282828", "brightBlack": "7c6f64", "foreground": "d4be98"}' ]
}

@test "load_theme rejects incomplete semantic scheme" {
  cat >"$TMPDIR_SCHEMA/incomplete.yaml" <<'YAML'
name: "Incomplete"
hex:
  foreground: "#ffffff"
  background: "#000000"
  colors:
    black: "#000000"
YAML

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

load_theme("${TMPDIR_SCHEMA}/incomplete.yaml")
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Palette section is required in YAML"* ]]
}

@test "load_theme rejects palette-only semantic scheme" {
  cat >"$TMPDIR_SCHEMA/palette-only.yaml" <<'YAML'
name: "Palette Only"
palette:
  bg_dim: "#1b1b1b"
  bg0: "#282828"
  bg1: "#32302f"
  bg2: "#32302f"
  bg3: "#45403d"
  bg4: "#45403d"
  bg5: "#5a524c"
  bg_statusline1: "#32302f"
  bg_statusline2: "#3a3735"
  bg_statusline3: "#504945"
  bg_visual: "#45403d"
  bg_visual_red: "#4c3432"
  bg_visual_yellow: "#4f422e"
  bg_visual_green: "#3b4439"
  bg_visual_blue: "#374141"
  bg_visual_purple: "#443840"
  bg_diff_red: "#402120"
  bg_diff_green: "#34381b"
  bg_diff_blue: "#0e363e"
  bg_current_word: "#3c3836"
  fg0: "#d4be98"
  fg1: "#ddc7a1"
  red: "#ea6962"
  orange: "#e78a4e"
  yellow: "#d8a657"
  green: "#a9b665"
  aqua: "#89b482"
  blue: "#7daea3"
  purple: "#d3869b"
  bg_red: "#ea6962"
  bg_green: "#a9b665"
  bg_yellow: "#d8a657"
  grey0: "#7c6f64"
  grey1: "#928374"
  grey2: "#a89984"
YAML

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

load_theme("${TMPDIR_SCHEMA}/palette-only.yaml", prefix="", uppercase=False)
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Ansi section is required in YAML"* ]]
}

@test "load_theme_bundle requires nvim semantic sections" {
  cat >"$TMPDIR_SCHEMA/missing-nvim-sections.yaml" <<'YAML'
name: "Missing Nvim Sections"
palette:
  bg_dim: "#1b1b1b"
  bg0: "#282828"
  bg1: "#32302f"
  bg2: "#32302f"
  bg3: "#45403d"
  bg4: "#45403d"
  bg5: "#5a524c"
  bg_statusline1: "#32302f"
  bg_statusline2: "#3a3735"
  bg_statusline3: "#504945"
  bg_visual: "#45403d"
  bg_visual_red: "#4c3432"
  bg_visual_yellow: "#4f422e"
  bg_visual_green: "#3b4439"
  bg_visual_blue: "#374141"
  bg_visual_purple: "#443840"
  bg_diff_red: "#402120"
  bg_diff_green: "#34381b"
  bg_diff_blue: "#0e363e"
  bg_current_word: "#3c3836"
  fg0: "#d4be98"
  fg1: "#ddc7a1"
  red: "#ea6962"
  orange: "#e78a4e"
  yellow: "#d8a657"
  green: "#a9b665"
  aqua: "#89b482"
  blue: "#7daea3"
  purple: "#d3869b"
  bg_red: "#ea6962"
  bg_green: "#a9b665"
  bg_yellow: "#d8a657"
  grey0: "#7c6f64"
  grey1: "#928374"
  grey2: "#a89984"
ansi:
  bg: "#282828"
  fg: "#d4be98"
  black: "#32302f"
  red: "#ea6962"
  green: "#a9b665"
  yellow: "#d8a657"
  blue: "#7daea3"
  magenta: "#d3869b"
  cyan: "#89b482"
  white: "#ddc7a1"
  bright_black: "#7c6f64"
  bright_red: "#ea6962"
  bright_green: "#a9b665"
  bright_yellow: "#d8a657"
  bright_blue: "#7daea3"
  bright_magenta: "#d3869b"
  bright_cyan: "#89b482"
  bright_white: "#ebdbb2"
ui:
  bg: "#282828"
  bg_alt: "#32302f"
  bg_dim: "#1b1b1b"
  fg: "#d4be98"
  fg_alt: "#ddc7a1"
  fg_dim: "#928374"
  muted: "#928374"
  border: "#928374"
  border_active: "#a89984"
  selection: "#45403d"
  visual: "#45403d"
  cursorline: "#32302f"
  search_bg: "#d8a657"
  search_fg: "#282828"
  inc_search_bg: "#e78a4e"
  inc_search_fg: "#282828"
  popup_bg: "#282828"
  popup_sel: "#45403d"
  status_bg: "#32302f"
  status_fg: "#ddc7a1"
  status_inactive_fg: "#928374"
syntax:
  comment: "#928374"
  string: "#89b482"
  escape: "#d8a657"
  number: "#d3869b"
  constant: "#89b482"
  keyword: "#ea6962"
  operator: "#e78a4e"
  type: "#d8a657"
  function: "#a9b665"
  variable: "#7daea3"
  property: "#7daea3"
  builtin: "#ea6962"
  preproc: "#d3869b"
  special: "#d8a657"
  delimiter: "#d4be98"
diagnostic:
  error: "#ea6962"
  warn: "#d8a657"
  info: "#7daea3"
  hint: "#d3869b"
  ok: "#a9b665"
diff:
  add: "#a9b665"
  change: "#7daea3"
  delete: "#ea6962"
  text: "#7daea3"
  add_bg: "#34381b"
  change_bg: "#0e363e"
  delete_bg: "#402120"
  text_bg: "#374141"
tool:
  prompt: "#d8a657"
  prompt_alt: "#e78a4e"
  path: "#7daea3"
  root: "#ea6962"
  duration: "#d8a657"
  git_clean: "#a9b665"
  git_dirty: "#d8a657"
  git_ahead: "#7daea3"
  git_behind: "#ea6962"
  directory: "#7daea3"
  executable: "#a9b665"
  symlink: "#89b482"
  archive: "#d8a657"
  media: "#89b482"
  document: "#d8a657"
  backup: "#7c6f64"
omp:
  foreground: "#d4be98"
  time: "#a9b665"
  user: "#d8a657"
  host: "#7daea3"
  root: "#ea6962"
  git_clean: "#a9b665"
  git_dirty: "#ea6962"
  git_ahead: "#7daea3"
  git_behind: "#ea6962"
  duration: "#d8a657"
  status_ok: "#a9b665"
  status_error: "#ea6962"
  prompt: "#7daea3"
terminal:
  background: "#282828"
  foreground: "#d4be98"
  selection: "#45403d"
  tab_background: "#282828"
  tab_unfocused_background: "#282828"
tmux:
  bar_bg: "#504945"
  bar_fg: "#d4be98"
  block_bg: "#d4be98"
  block_fg: "#282828"
  alert_bg: "#ea6962"
  alert_fg: "#282828"
  border_fg: "#928374"
  border_active_fg: "#d4be98"
  message_bg: "#504945"
  message_fg: "#d4be98"
  mode_bg: "#3a3735"
  mode_fg: "#ddc7a1"
ls_colors:
  foreground: "#d4be98"
  background: "#282828"
  error: "#ea6962"
  executable: "#a9b665"
  document: "#d8a657"
  directory: "#7daea3"
  special: "#d3869b"
  media: "#89b482"
  backup: "#7c6f64"
fzf:
  fg: "#d4be98"
  bg: "#282828"
  hl: "#a9b665"
  "fg+": "#d4be98"
  "bg+": "#32302f"
  "hl+": "#89b482"
  info: "#89b482"
  border: "#928374"
  query: "#d4be98"
  prompt: "#e78a4e"
  pointer: "#7daea3"
  marker: "#d8a657"
  spinner: "#d8a657"
  header: "#928374"
  label: "#d4be98"
  gutter: "#282828"
YAML

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme_bundle

load_theme_bundle("${TMPDIR_SCHEMA}/missing-nvim-sections.yaml", prefix="", uppercase=False)
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Statusline section is required in YAML"* ]]
}

@test "load_theme_bundle requires omp section" {
  run python3 - <<PY
from pathlib import Path
source = Path("${PROJECT_ROOT}/color/schemes/gruvbox-dark-material.yaml").read_text(encoding="utf-8")
lines = source.splitlines()
out = []
skip = False
for line in lines:
    if line.startswith("omp:"):
        skip = True
        continue
    if skip and line and not line.startswith(" "):
        skip = False
    if not skip:
        out.append(line)
Path("${TMPDIR_SCHEMA}/missing-omp.yaml").write_text("\n".join(out) + "\n", encoding="utf-8")
PY
  [ "$status" -eq 0 ]

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme_bundle

load_theme_bundle("${TMPDIR_SCHEMA}/missing-omp.yaml", prefix="", uppercase=False)
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Omp section is required in YAML"* ]]
}

@test "load_theme_bundle requires terminal section" {
  run python3 - <<PY
from pathlib import Path
source = Path("${PROJECT_ROOT}/color/schemes/gruvbox-dark-material.yaml").read_text(encoding="utf-8")
lines = source.splitlines()
out = []
skip = False
for line in lines:
    if line.startswith("terminal:"):
        skip = True
        continue
    if skip and line and not line.startswith(" "):
        skip = False
    if not skip:
        out.append(line)
Path("${TMPDIR_SCHEMA}/missing-terminal.yaml").write_text("\n".join(out) + "\n", encoding="utf-8")
PY
  [ "$status" -eq 0 ]

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme_bundle

load_theme_bundle("${TMPDIR_SCHEMA}/missing-terminal.yaml", prefix="", uppercase=False)
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Terminal section is required in YAML"* ]]
}

@test "load_theme_bundle requires tmux section" {
  cat >"$TMPDIR_SCHEMA/missing-tmux-section.yaml" <<'YAML'
name: "Missing Tmux Section"
palette:
  bg_dim: "#1b1b1b"
  bg0: "#282828"
  bg1: "#32302f"
  bg2: "#32302f"
  bg3: "#45403d"
  bg4: "#45403d"
  bg5: "#5a524c"
  bg_statusline1: "#32302f"
  bg_statusline2: "#3a3735"
  bg_statusline3: "#504945"
  bg_visual: "#45403d"
  bg_visual_red: "#4c3432"
  bg_visual_yellow: "#4f422e"
  bg_visual_green: "#3b4439"
  bg_visual_blue: "#374141"
  bg_visual_purple: "#443840"
  bg_diff_red: "#402120"
  bg_diff_green: "#34381b"
  bg_diff_blue: "#0e363e"
  bg_current_word: "#3c3836"
  fg0: "#d4be98"
  fg1: "#ddc7a1"
  red: "#ea6962"
  orange: "#e78a4e"
  yellow: "#d8a657"
  green: "#a9b665"
  aqua: "#89b482"
  blue: "#7daea3"
  purple: "#d3869b"
  bg_red: "#ea6962"
  bg_green: "#a9b665"
  bg_yellow: "#d8a657"
  grey0: "#7c6f64"
  grey1: "#928374"
  grey2: "#a89984"
ansi:
  bg: "#282828"
  fg: "#d4be98"
  black: "#32302f"
  red: "#ea6962"
  green: "#a9b665"
  yellow: "#d8a657"
  blue: "#7daea3"
  magenta: "#d3869b"
  cyan: "#89b482"
  white: "#ddc7a1"
  bright_black: "#7c6f64"
  bright_red: "#ea6962"
  bright_green: "#a9b665"
  bright_yellow: "#d8a657"
  bright_blue: "#7daea3"
  bright_magenta: "#d3869b"
  bright_cyan: "#89b482"
  bright_white: "#ebdbb2"
ui:
  bg: "#282828"
  bg_alt: "#32302f"
  bg_dim: "#1b1b1b"
  fg: "#d4be98"
  fg_alt: "#ddc7a1"
  fg_dim: "#928374"
  muted: "#928374"
  border: "#928374"
  border_active: "#a89984"
  selection: "#45403d"
  visual: "#45403d"
  cursorline: "#32302f"
  search_bg: "#d8a657"
  search_fg: "#282828"
  inc_search_bg: "#e78a4e"
  inc_search_fg: "#282828"
  popup_bg: "#282828"
  popup_sel: "#45403d"
  status_bg: "#32302f"
  status_fg: "#ddc7a1"
  status_inactive_fg: "#928374"
statusline:
  normal_bg: "#3a3735"
  normal_fg: "#ddc7a1"
  insert_bg: "#a9b665"
  insert_fg: "#282828"
  visual_bg: "#d8a657"
  visual_fg: "#282828"
  replace_bg: "#ea6962"
  replace_fg: "#282828"
  command_bg: "#7daea3"
  command_fg: "#282828"
  terminal_bg: "#d3869b"
  terminal_fg: "#282828"
  section_bg: "#504945"
  section_fg: "#d4be98"
  inactive_bg: "#32302f"
  inactive_fg: "#928374"
semantic:
  text: "#d4be98"
  muted: "#928374"
  error: "#ea6962"
  warning: "#d8a657"
  info: "#7daea3"
  hint: "#d3869b"
  success: "#a9b665"
  prompt: "#e78a4e"
  operator: "#e78a4e"
  type: "#d8a657"
  function: "#a9b665"
  constant: "#89b482"
  variable: "#7daea3"
  number: "#d3869b"
  directory: "#7daea3"
  symlink: "#89b482"
  executable: "#a9b665"
  special: "#d8a657"
  special_char: "#d8a657"
  module: "#7daea3"
  title: "#a9b665"
  added: "#a9b665"
  changed: "#7daea3"
  removed: "#ea6962"
  diff_text: "#7daea3"
  border: "#928374"
  border_active: "#a89984"
  surface: "#32302f"
  surface_alt: "#45403d"
  selection: "#45403d"
  current_word: "#3c3836"
  status_bg: "#3a3735"
  status_fg: "#ddc7a1"
  status_inactive_fg: "#928374"
  search_bg: "#d8a657"
  search_fg: "#282828"
  inc_search_bg: "#e78a4e"
  inc_search_fg: "#282828"
  popup_bg: "#282828"
  popup_sel: "#45403d"
syntax:
  comment: "#928374"
  string: "#89b482"
  escape: "#d8a657"
  number: "#d3869b"
  constant: "#89b482"
  keyword: "#ea6962"
  operator: "#e78a4e"
  type: "#d8a657"
  function: "#a9b665"
  variable: "#7daea3"
  property: "#7daea3"
  builtin: "#ea6962"
  preproc: "#d3869b"
  special: "#d8a657"
  delimiter: "#d4be98"
diagnostic:
  error: "#ea6962"
  warn: "#d8a657"
  info: "#7daea3"
  hint: "#d3869b"
  ok: "#a9b665"
diff:
  add: "#a9b665"
  change: "#7daea3"
  delete: "#ea6962"
  text: "#7daea3"
  add_bg: "#34381b"
  change_bg: "#0e363e"
  delete_bg: "#402120"
  text_bg: "#374141"
tool:
  prompt: "#d8a657"
  prompt_alt: "#e78a4e"
  path: "#7daea3"
  root: "#ea6962"
  duration: "#d8a657"
  git_clean: "#a9b665"
  git_dirty: "#d8a657"
  git_ahead: "#7daea3"
  git_behind: "#ea6962"
  directory: "#7daea3"
  executable: "#a9b665"
  symlink: "#89b482"
  archive: "#d8a657"
  media: "#89b482"
  document: "#d8a657"
  backup: "#7c6f64"
omp:
  foreground: "#d4be98"
  time: "#a9b665"
  user: "#d8a657"
  host: "#7daea3"
  root: "#ea6962"
  git_clean: "#a9b665"
  git_dirty: "#ea6962"
  git_ahead: "#7daea3"
  git_behind: "#ea6962"
  duration: "#d8a657"
  status_ok: "#a9b665"
  status_error: "#ea6962"
  prompt: "#7daea3"
terminal:
  background: "#282828"
  foreground: "#d4be98"
  selection: "#45403d"
  tab_background: "#282828"
  tab_unfocused_background: "#282828"
ls_colors:
  foreground: "#d4be98"
  background: "#282828"
  error: "#ea6962"
  executable: "#a9b665"
  document: "#d8a657"
  directory: "#7daea3"
  special: "#d3869b"
  media: "#89b482"
  backup: "#7c6f64"
fzf:
  fg: "#d4be98"
  bg: "#282828"
  hl: "#a9b665"
  "fg+": "#d4be98"
  "bg+": "#32302f"
  "hl+": "#89b482"
  info: "#89b482"
  border: "#928374"
  query: "#d4be98"
  prompt: "#e78a4e"
  pointer: "#7daea3"
  marker: "#d8a657"
  spinner: "#d8a657"
  header: "#928374"
  label: "#d4be98"
  gutter: "#282828"
fish_ui:
  background: "#282828"
  background_alt: "#32302f"
  foreground: "#d4be98"
  foreground_alt: "#ddc7a1"
  muted: "#928374"
fish_syntax:
  function: "#a9b665"
  keyword: "#ea6962"
  type: "#d8a657"
  variable: "#7daea3"
  string: "#89b482"
  operator: "#e78a4e"
  escape: "#d8a657"
  comment: "#928374"
  error: "#ea6962"
  autosuggestion: "#ddc7a1"
  valid_path: "#7daea3"
  cancel: "#ea6962"
fish_selection:
  selection: "#45403d"
  search_match: "#45403d"
fish_prompt:
  cwd: "#7daea3"
  cwd_root: "#ea6962"
  user: "#d4be98"
  host: "#7daea3"
  host_remote: "#d8a657"
  status: "#ea6962"
fish_pager:
  progress: "#928374"
  prefix: "#d8a657"
  completion: "#d4be98"
  description: "#928374"
  selected_background: "#45403d"
  selected_completion: "#d4be98"
  selected_description: "#928374"
YAML

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme_bundle

load_theme_bundle("${TMPDIR_SCHEMA}/missing-tmux-section.yaml", prefix="", uppercase=False)
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Tmux section is required in YAML"* ]]
}

@test "load_theme_bundle requires fish section" {
  cat >"$TMPDIR_SCHEMA/missing-fish-section.yaml" <<'YAML'
name: "Missing Fish Section"
palette:
  bg_dim: "#1b1b1b"
  bg0: "#282828"
  bg1: "#32302f"
  bg2: "#32302f"
  bg3: "#45403d"
  bg4: "#45403d"
  bg5: "#5a524c"
  bg_statusline1: "#32302f"
  bg_statusline2: "#3a3735"
  bg_statusline3: "#504945"
  bg_visual: "#45403d"
  bg_visual_red: "#4c3432"
  bg_visual_yellow: "#4f422e"
  bg_visual_green: "#3b4439"
  bg_visual_blue: "#374141"
  bg_visual_purple: "#443840"
  bg_diff_red: "#402120"
  bg_diff_green: "#34381b"
  bg_diff_blue: "#0e363e"
  bg_current_word: "#3c3836"
  fg0: "#d4be98"
  fg1: "#ddc7a1"
  red: "#ea6962"
  orange: "#e78a4e"
  yellow: "#d8a657"
  green: "#a9b665"
  aqua: "#89b482"
  blue: "#7daea3"
  purple: "#d3869b"
  bg_red: "#ea6962"
  bg_green: "#a9b665"
  bg_yellow: "#d8a657"
  grey0: "#7c6f64"
  grey1: "#928374"
  grey2: "#a89984"
ansi:
  bg: "#282828"
  fg: "#d4be98"
  black: "#32302f"
  red: "#ea6962"
  green: "#a9b665"
  yellow: "#d8a657"
  blue: "#7daea3"
  magenta: "#d3869b"
  cyan: "#89b482"
  white: "#ddc7a1"
  bright_black: "#7c6f64"
  bright_red: "#ea6962"
  bright_green: "#a9b665"
  bright_yellow: "#d8a657"
  bright_blue: "#7daea3"
  bright_magenta: "#d3869b"
  bright_cyan: "#89b482"
  bright_white: "#ebdbb2"
ui:
  bg: "#282828"
  bg_alt: "#32302f"
  bg_dim: "#1b1b1b"
  fg: "#d4be98"
  fg_alt: "#ddc7a1"
  fg_dim: "#928374"
  muted: "#928374"
  border: "#928374"
  border_active: "#a89984"
  selection: "#45403d"
  visual: "#45403d"
  cursorline: "#32302f"
  search_bg: "#d8a657"
  search_fg: "#282828"
  inc_search_bg: "#e78a4e"
  inc_search_fg: "#282828"
  popup_bg: "#282828"
  popup_sel: "#45403d"
  status_bg: "#32302f"
  status_fg: "#ddc7a1"
  status_inactive_fg: "#928374"
statusline:
  normal_bg: "#3a3735"
  normal_fg: "#ddc7a1"
  insert_bg: "#a9b665"
  insert_fg: "#282828"
  visual_bg: "#d8a657"
  visual_fg: "#282828"
  replace_bg: "#ea6962"
  replace_fg: "#282828"
  command_bg: "#7daea3"
  command_fg: "#282828"
  terminal_bg: "#d3869b"
  terminal_fg: "#282828"
  section_bg: "#504945"
  section_fg: "#d4be98"
  inactive_bg: "#32302f"
  inactive_fg: "#928374"
semantic:
  text: "#d4be98"
  muted: "#928374"
  error: "#ea6962"
  warning: "#d8a657"
  info: "#7daea3"
  hint: "#d3869b"
  success: "#a9b665"
  prompt: "#e78a4e"
  operator: "#e78a4e"
  type: "#d8a657"
  function: "#a9b665"
  constant: "#89b482"
  variable: "#7daea3"
  number: "#d3869b"
  directory: "#7daea3"
  symlink: "#89b482"
  executable: "#a9b665"
  special: "#d8a657"
  special_char: "#d8a657"
  module: "#7daea3"
  title: "#a9b665"
  added: "#a9b665"
  changed: "#7daea3"
  removed: "#ea6962"
  diff_text: "#7daea3"
  border: "#928374"
  border_active: "#a89984"
  surface: "#32302f"
  surface_alt: "#45403d"
  selection: "#45403d"
  current_word: "#3c3836"
  status_bg: "#3a3735"
  status_fg: "#ddc7a1"
  status_inactive_fg: "#928374"
  search_bg: "#d8a657"
  search_fg: "#282828"
  inc_search_bg: "#e78a4e"
  inc_search_fg: "#282828"
  popup_bg: "#282828"
  popup_sel: "#45403d"
syntax:
  comment: "#928374"
  string: "#89b482"
  escape: "#d8a657"
  number: "#d3869b"
  constant: "#89b482"
  keyword: "#ea6962"
  operator: "#e78a4e"
  type: "#d8a657"
  function: "#a9b665"
  variable: "#7daea3"
  property: "#7daea3"
  builtin: "#ea6962"
  preproc: "#d3869b"
  special: "#d8a657"
  delimiter: "#d4be98"
diagnostic:
  error: "#ea6962"
  warn: "#d8a657"
  info: "#7daea3"
  hint: "#d3869b"
  ok: "#a9b665"
diff:
  add: "#a9b665"
  change: "#7daea3"
  delete: "#ea6962"
  text: "#7daea3"
  add_bg: "#34381b"
  change_bg: "#0e363e"
  delete_bg: "#402120"
  text_bg: "#374141"
tool:
  prompt: "#d8a657"
  prompt_alt: "#e78a4e"
  path: "#7daea3"
  root: "#ea6962"
  duration: "#d8a657"
  git_clean: "#a9b665"
  git_dirty: "#d8a657"
  git_ahead: "#7daea3"
  git_behind: "#ea6962"
  directory: "#7daea3"
  executable: "#a9b665"
  symlink: "#89b482"
  archive: "#d8a657"
  media: "#89b482"
  document: "#d8a657"
  backup: "#7c6f64"
omp:
  foreground: "#d4be98"
  time: "#a9b665"
  user: "#d8a657"
  host: "#7daea3"
  root: "#ea6962"
  git_clean: "#a9b665"
  git_dirty: "#ea6962"
  git_ahead: "#7daea3"
  git_behind: "#ea6962"
  duration: "#d8a657"
  status_ok: "#a9b665"
  status_error: "#ea6962"
  prompt: "#7daea3"
terminal:
  background: "#282828"
  foreground: "#d4be98"
  selection: "#45403d"
  tab_background: "#282828"
  tab_unfocused_background: "#282828"
tmux:
  bar_bg: "#504945"
  bar_fg: "#d4be98"
  block_bg: "#d4be98"
  block_fg: "#282828"
  alert_bg: "#ea6962"
  alert_fg: "#282828"
  border_fg: "#928374"
  border_active_fg: "#d4be98"
  message_bg: "#504945"
  message_fg: "#d4be98"
  mode_bg: "#3a3735"
  mode_fg: "#ddc7a1"
ls_colors:
  foreground: "#d4be98"
  background: "#282828"
  error: "#ea6962"
  executable: "#a9b665"
  document: "#d8a657"
  directory: "#7daea3"
  special: "#d3869b"
  media: "#89b482"
  backup: "#7c6f64"
fzf:
  fg: "#d4be98"
  bg: "#282828"
  hl: "#a9b665"
  "fg+": "#d4be98"
  "bg+": "#32302f"
  "hl+": "#89b482"
  info: "#89b482"
  border: "#928374"
  query: "#d4be98"
  prompt: "#e78a4e"
  pointer: "#7daea3"
  marker: "#d8a657"
  spinner: "#d8a657"
  header: "#928374"
  label: "#d4be98"
  gutter: "#282828"
YAML

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme_bundle

load_theme_bundle("${TMPDIR_SCHEMA}/missing-fish-section.yaml", prefix="", uppercase=False)
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Fish section is required in YAML"* ]]
}

@test "derive_vim_palette preserves palette semantics distinct from diagnostics" {
  run python3 - <<PY
import json
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import derive_vim_palette

bundle = {
    "palette": {
        "bg_dim": "#010101",
        "bg0": "#020202",
        "bg1": "#030303",
        "bg2": "#040404",
        "bg3": "#050505",
        "bg4": "#060606",
        "bg5": "#070707",
        "bg_statusline1": "#080808",
        "bg_statusline2": "#090909",
        "bg_statusline3": "#0a0a0a",
        "bg_visual": "#0b0b0b",
        "bg_visual_red": "#0c0c0c",
        "bg_visual_yellow": "#0d0d0d",
        "bg_visual_green": "#0e0e0e",
        "bg_visual_blue": "#0f0f0f",
        "bg_visual_purple": "#101010",
        "bg_diff_red": "#111111",
        "bg_diff_green": "#121212",
        "bg_diff_blue": "#131313",
        "bg_current_word": "#141414",
        "fg0": "#151515",
        "fg1": "#161616",
        "red": "#aa0001",
        "orange": "#aa0002",
        "yellow": "#aa0003",
        "green": "#aa0004",
        "aqua": "#aa0005",
        "blue": "#aa0006",
        "purple": "#aa0007",
        "bg_red": "#171717",
        "bg_green": "#181818",
        "bg_yellow": "#191919",
        "grey0": "#1a1a1a",
        "grey1": "#1b1b1b",
        "grey2": "#1c1c1c",
    },
    "diagnostic": {
        "error": "#bb0001",
        "warn": "#bb0002",
        "info": "#bb0003",
        "hint": "#bb0004",
        "ok": "#bb0005",
    },
    "diff": {
        "add": "#cc0001",
        "change": "#cc0002",
        "delete": "#cc0003",
        "text": "#cc0004",
        "add_bg": "#dd0001",
        "change_bg": "#dd0002",
        "delete_bg": "#dd0003",
        "text_bg": "#dd0004",
    },
}

palette = derive_vim_palette(bundle)
print(json.dumps({k: palette[k] for k in ("red", "yellow", "green", "blue", "purple")}, sort_keys=True))
PY
  [ "$status" -eq 0 ]
  [ "$output" = '{"blue": "#aa0006", "green": "#aa0004", "purple": "#aa0007", "red": "#aa0001", "yellow": "#aa0003"}' ]
}
