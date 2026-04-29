#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  TEST_ROOT="$(mktemp -d /tmp/dot-theme-test-XXXXXX)"

  mkdir -p "$TEST_ROOT/color"
  mkdir -p "$TEST_ROOT/macos/iterm2"
  mkdir -p "$TEST_ROOT/.config/tmux"
  mkdir -p "$TEST_ROOT/windows/terminal"

  cp -R "$PROJECT_ROOT/color/." "$TEST_ROOT/color/"
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
print(theme["tab"]["background"])
print(theme["tabRow"]["unfocusedBackground"])
PY
  [ "$status" -eq 0 ]
  [ "$output" = $'#1D1F21\n#C5C8C6\n#1D1F21\n#969896\n#FFFFFF\n#1D1F21FF\n#282A2EFF' ]
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
from pathlib import Path

text = Path("${TEST_ROOT}/.config/tmux/.tmux.conf").read_text(encoding="utf-8")
for line in [
    'set -g @tmux_bar_bg "#282a2e"',
    'set -g @tmux_bar_fg "#c5c8c6"',
    'set -g @tmux_block_bg "#c5c8c6"',
    'set -g @tmux_block_fg "#1d1f21"',
    'set -g @tmux_alert_bg "#cc6666"',
    'set -g @tmux_alert_fg "#1d1f21"',
    'set -g @tmux_bell_bg "#de935f"',
    'set -g @tmux_bell_fg "#1d1f21"',
    'set -g @tmux_border_fg "#969896"',
    'set -g @tmux_border_active_fg "#c5c8c6"',
    'set -g @tmux_message_bg "#282a2e"',
    'set -g @tmux_message_fg "#c5c8c6"',
    'set -g @tmux_mode_bg "#282a2e"',
    'set -g @tmux_mode_fg "#c5c8c6"',
]:
    if line not in text:
        raise SystemExit(f"missing: {line}")
print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}
