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
  [ "$output" = '{"background": "282828", "brightBlack": "928374", "foreground": "d4be98"}' ]
}

@test "load_theme reads gruvbox light material colors map" {
  run python3 - <<PY
import json
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

colors = load_theme("${PROJECT_ROOT}/color/schemes/gruvbox-light-material.yaml", prefix="", uppercase=False)
print(json.dumps({k: colors[k] for k in ("foreground", "background", "brightBlack")}, sort_keys=True))
PY
  [ "$status" -eq 0 ]
  [ "$output" = '{"background": "fbf1c7", "brightBlack": "7c6f64", "foreground": "3c3836"}' ]
}

@test "load_theme_bundle reads gruvbox light material bundle" {
  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme_bundle

bundle = load_theme_bundle("${PROJECT_ROOT}/color/schemes/gruvbox-light-material.yaml", prefix="", uppercase=False)
print(bundle["tmux"]["bell_bg"])
print(bundle["statusline"]["normal_bg"])
PY
  [ "$status" -eq 0 ]
  [ "$output" = $'d79921\n3c3836' ]
}

@test "load_theme reads melange dark colors map" {
  run python3 - <<PY
import json
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

colors = load_theme("${PROJECT_ROOT}/color/schemes/melange-dark.yaml", prefix="", uppercase=False)
print(json.dumps({k: colors[k] for k in ("foreground", "background", "brightBlack")}, sort_keys=True))
PY
  [ "$status" -eq 0 ]
  [ "$output" = '{"background": "292522", "brightBlack": "867462", "foreground": "ece1d7"}' ]
}

@test "load_theme_bundle reads melange light bundle" {
  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme_bundle

bundle = load_theme_bundle("${PROJECT_ROOT}/color/schemes/melange-light.yaml", prefix="", uppercase=False)
print(bundle["tmux"]["bell_bg"])
print(bundle["semantic"]["module"])
print(bundle["semantic"]["function"])
print(bundle["semantic"]["info"])
PY
  [ "$status" -eq 0 ]
  [ "$output" = $'a06d00\n54433a\na06d00\n7892bd' ]
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
  [[ "$output" == *"Ansi section is required in YAML"* ]]
}

@test "load_theme rejects ansi-less semantic scheme" {
  cat >"$TMPDIR_SCHEMA/ansi-less.yaml" <<'YAML'
name: "Ansi Less"
YAML

  run python3 - <<PY
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

load_theme("${TMPDIR_SCHEMA}/ansi-less.yaml", prefix="", uppercase=False)
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Ansi section is required in YAML"* ]]
}

@test "load_theme_bundle requires nvim semantic sections" {
  cat >"$TMPDIR_SCHEMA/missing-nvim-sections.yaml" <<'YAML'
name: "Missing Nvim Sections"
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
  added_bg: "#34381b"
  changed: "#7daea3"
  changed_bg: "#0e363e"
  removed: "#ea6962"
  removed_bg: "#402120"
  diff_text: "#7daea3"
  diff_text_bg: "#374141"
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
  added_bg: "#34381b"
  changed: "#7daea3"
  changed_bg: "#0e363e"
  removed: "#ea6962"
  removed_bg: "#402120"
  diff_text: "#7daea3"
  diff_text_bg: "#374141"
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
