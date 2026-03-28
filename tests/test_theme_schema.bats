#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  TMPDIR_SCHEMA="$(mktemp -d /tmp/dot-theme-schema-XXXXXX)"
}

teardown() {
  rm -rf "$TMPDIR_SCHEMA"
}

@test "load_theme reads flattened colors map" {
  run python3 - <<PY
import json
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

colors = load_theme("${PROJECT_ROOT}/color/schemes/base16-default-dark.yaml", prefix="", uppercase=False)
print(json.dumps({k: colors[k] for k in ("foreground", "background", "brightBlack")}, sort_keys=True))
PY
  [ "$status" -eq 0 ]
  [ "$output" = '{"background": "181818", "brightBlack": "585858", "foreground": "d8d8d8"}' ]
}

@test "load_theme rejects legacy hex layout" {
  cat >"$TMPDIR_SCHEMA/legacy.yaml" <<'YAML'
name: "Legacy"
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

load_theme("${TMPDIR_SCHEMA}/legacy.yaml")
PY
  [ "$status" -eq 1 ]
  [[ "$output" == *"Ansi or base16 section is required in YAML"* ]]
}

@test "load_theme reads base16-only scheme by deriving ANSI colors" {
  cat >"$TMPDIR_SCHEMA/base16-only.yaml" <<'YAML'
name: "Base16 Only"
base16:
  base00: "#181818"
  base01: "#282828"
  base02: "#383838"
  base03: "#585858"
  base04: "#b8b8b8"
  base05: "#d8d8d8"
  base06: "#e8e8e8"
  base07: "#f8f8f8"
  base08: "#ab4642"
  base09: "#dc9656"
  base0A: "#f7ca88"
  base0B: "#a1b56c"
  base0C: "#86c1b9"
  base0D: "#7cafc2"
  base0E: "#ba8baf"
  base0F: "#a16946"
YAML

  run python3 - <<PY
import json
import sys
sys.path.insert(0, "${PROJECT_ROOT}/color/lib")
from theme import load_theme

colors = load_theme("${TMPDIR_SCHEMA}/base16-only.yaml", prefix="", uppercase=False)
print(json.dumps({k: colors[k] for k in ("foreground", "background", "brightBlack", "brightWhite")}, sort_keys=True))
PY
  [ "$status" -eq 0 ]
  [ "$output" = '{"background": "181818", "brightBlack": "585858", "brightWhite": "f8f8f8", "foreground": "d8d8d8"}' ]
}
