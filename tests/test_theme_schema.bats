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

colors = load_theme("${PROJECT_ROOT}/color/schemes/color-scheme.default.yaml", prefix="", uppercase=False)
print(json.dumps({k: colors[k] for k in ("foreground", "background", "brightBlack")}, sort_keys=True))
PY
  [ "$status" -eq 0 ]
  [ "$output" = '{"background": "151515", "brightBlack": "505050", "foreground": "d0d0d0"}' ]
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
  [[ "$output" == *"No colors section found in YAML"* ]]
}
