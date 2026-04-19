#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
}

@test "strict semantic scheme YAMLs load and all scheme hex values are normalized" {
  run python3 - <<PY
import glob
import os
import re
import sys

project_root = "${PROJECT_ROOT}"
schemes = sorted(glob.glob(os.path.join(project_root, "color/schemes/*.yaml")))
if not schemes:
    raise SystemExit("No schemes found in color/schemes")

sys.path.insert(0, os.path.join(project_root, "color/lib"))
from theme import load_theme_sections

hex_re = re.compile(r'^\\s{2}([\\w_]+):\\s+"(#[0-9a-fA-F]{6})"\\s*$')

bad = []
strict = []
for path in schemes:
    # Enforce consistent hex casing in the source YAML (easier diffs, fewer surprises).
    text = open(path, encoding="utf-8").read()
    if "\\npalette:\\n" in "\\n" + text:
        strict.append(path)
        load_theme_sections(path, prefix="#", uppercase=False)

    for i, line in enumerate(text.splitlines(), start=1):
        m = hex_re.match(line)
        if not m:
            continue
        value = m.group(2)
        if value != value.lower():
            bad.append((os.path.relpath(path, project_root), i, value))

if bad:
    for rel, line_no, value in bad:
        print(f"{rel}:{line_no}: non-normalized hex: {value}")
    raise SystemExit(1)

if not strict:
    raise SystemExit("No strict semantic schemes found")
PY
  [ "$status" -eq 0 ]
}
