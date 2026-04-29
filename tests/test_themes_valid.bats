#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
}

@test "tomorrow night base_palette is complete and normalized" {
  run python3 - <<PY
import os
import re

path = os.path.join("${PROJECT_ROOT}", "color/themes/tomorrow-night.yaml")
required = {
    "cursor",
    "statusline",
    "selection",
    "bg",
    "fg",
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "bright_black",
    "bright_red",
    "bright_green",
    "bright_yellow",
    "bright_blue",
    "bright_magenta",
    "bright_cyan",
    "bright_white",
}

values = {}
active = False
pattern = re.compile(r'^\s{2}([\w_]+):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$')

with open(path, encoding="utf-8") as handle:
    for line in handle:
        stripped = line.strip()
        if stripped == "base_palette:":
            active = True
            continue
        if active:
            if line and not line.startswith("  "):
                break
            match = pattern.match(line)
            if match:
                values[match.group(1)] = match.group(2)

missing = sorted(required - set(values))
if missing:
    raise SystemExit("missing base_palette keys: " + ", ".join(missing))

bad = [f"{key}={value}" for key, value in sorted(values.items()) if value != value.lower()]
if bad:
    raise SystemExit("non-normalized hex values: " + ", ".join(bad))

print("ok")
PY
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}
