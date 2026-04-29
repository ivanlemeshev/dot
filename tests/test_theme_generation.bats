#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  TEST_ROOT="$(mktemp -d /tmp/dot-theme-test-XXXXXX)"

  mkdir -p "$TEST_ROOT/color"
  mkdir -p "$TEST_ROOT/windows/terminal"

  cp -R "$PROJECT_ROOT/color/." "$TEST_ROOT/color/"
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
