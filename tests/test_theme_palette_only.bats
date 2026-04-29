#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  TEST_ROOT="$(mktemp -d /tmp/dot-theme-test-XXXXXX)"

  mkdir -p "$TEST_ROOT/color"
  mkdir -p "$TEST_ROOT/.config/fish/conf.d"
  mkdir -p "$TEST_ROOT/.config/tmux"
  mkdir -p "$TEST_ROOT/windows/terminal"
  mkdir -p "$TEST_ROOT/macos/iterm2"

  cp -R "$PROJECT_ROOT/color/." "$TEST_ROOT/color/"
  cp "$PROJECT_ROOT/.config/fish/conf.d/custom_theme.fish" "$TEST_ROOT/.config/fish/conf.d/custom_theme.fish"
  cp "$PROJECT_ROOT/.config/tmux/.tmux.conf" "$TEST_ROOT/.config/tmux/.tmux.conf"
  cp "$PROJECT_ROOT/windows/terminal/settings.json" "$TEST_ROOT/windows/terminal/settings.json"
  cp "$PROJECT_ROOT/macos/iterm2/custom-color-theme.itermcolors" "$TEST_ROOT/macos/iterm2/custom-color-theme.itermcolors"
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "tomorrow night generated theme files stay within tomorrow night colors" {
  run python3 "$TEST_ROOT/color/generators/apply-windows-terminal.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/windows/terminal/settings.json"
  [ "$status" -eq 0 ]

  run python3 "$TEST_ROOT/color/generators/apply-iterm2.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/macos/iterm2/custom-color-theme.itermcolors"
  [ "$status" -eq 0 ]

  run python3 "$TEST_ROOT/color/generators/apply-tmux.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/tmux/.tmux.conf"
  [ "$status" -eq 0 ]

  run python3 "$TEST_ROOT/color/generators/apply-fish.py" \
    "$TEST_ROOT/color/themes/tomorrow-night.yaml" \
    "$TEST_ROOT/.config/fish/conf.d/custom_theme.fish"
  [ "$status" -eq 0 ]

  run python3 - <<PY
import os
import re
import plistlib

project_root = "${TEST_ROOT}"
theme = os.path.join(project_root, "color/themes/tomorrow-night.yaml")

def parse_section(path, section_name):
    values = {}
    active = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )
    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == f"{section_name}:":
                active = True
                continue
            if active:
                if not stripped or stripped.startswith("#"):
                    continue
                if line and not line.startswith("  "):
                    break
                match = key_pattern.match(line)
                if match:
                    key = match.group(1) or match.group(2)
                    values[key] = match.group(3).lower()
    return values

allowed = {}
for section in ("base_palette", "windows_terminal", "tmux", "fish", "ls_colors"):
    allowed.update(parse_section(theme, section))

allowed_hex = {value.lower() for value in allowed.values()}
allowed_hex6 = {value.lstrip("#") for value in allowed_hex}

targets = [
    "windows/terminal/settings.json",
    ".config/tmux/.tmux.conf",
    ".config/fish/conf.d/custom_theme.fish",
    "macos/iterm2/custom-color-theme.itermcolors",
]

observed = []
hex7 = re.compile(r"#[0-9a-fA-F]{6}")
hex8 = re.compile(r"#[0-9a-fA-F]{8}")

for rel in targets:
    path = os.path.join(project_root, rel)
    if rel.endswith(".itermcolors"):
        data = plistlib.loads(open(path, "rb").read())
        for key, value in data.items():
            if isinstance(value, dict) and {"Red Component", "Green Component", "Blue Component"} <= set(value):
                r = round(value["Red Component"] * 255)
                g = round(value["Green Component"] * 255)
                b = round(value["Blue Component"] * 255)
                observed.append((rel, f"#{r:02x}{g:02x}{b:02x}", "hex7"))
        continue

    text = open(path, encoding="utf-8").read()
    for h in hex7.findall(text):
        observed.append((rel, h.lower(), "hex7"))
    for h in hex8.findall(text):
        observed.append((rel, h.lower(), "hex8"))

    if rel.endswith("custom_theme.fish"):
        for line in text.splitlines():
            m = re.match(r"^set -l \w+\s+([0-9a-fA-F]{6})$", line.strip())
            if m:
                observed.append((rel, m.group(1).lower(), "hex6"))

bad = []
for rel, value, kind in observed:
    if kind == "hex7":
        if value not in allowed_hex:
            bad.append((rel, value))
    elif kind == "hex8":
        base = value[0:7]
        alpha = value[7:9]
        if base not in allowed_hex or alpha != "ff":
            bad.append((rel, value))
    else:
        if value not in allowed_hex6:
            bad.append((rel, value))

if bad:
    print("Generated files contain colors outside Tomorrow Night.")
    for rel, value in bad:
        print(f"Observed color in outputs: {rel}: {value}")
    raise SystemExit(1)
PY

  [ "$status" -eq 0 ]
}
