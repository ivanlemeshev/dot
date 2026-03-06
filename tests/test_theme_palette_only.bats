#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
}

@test "generated theme files use only Everforest palette colors" {
  run python3 - <<PY
import os
import re
import sys

project_root = "${PROJECT_ROOT}"
scheme = os.path.join(project_root, "color/schemes/color-scheme.everforest-hard.yaml")

sys.path.insert(0, os.path.join(project_root, "color/lib"))
from theme import load_theme_sections

colors, raw_palette = load_theme_sections(scheme, prefix="#", uppercase=False)

allowed_hex = {v.lower() for v in raw_palette.values()} | {v.lower() for v in colors.values()}
allowed_hex6 = {h.lstrip("#") for h in allowed_hex}

targets = [
    "windows/terminal/settings.json",
    ".config/tmux/.tmux.conf",
    ".config/oh-my-posh/theme.omp.json",
    ".config/bat/themes/custom.tmTheme",
    ".config/fish/conf.d/fzf_colors.fish",
    ".config/fish/conf.d/ls_colors.fish",
    ".config/fish/conf.d/custom_theme.fish",
    ".config/vim/colors/custom.vim",
    ".config/nvim/lua/lem/colorscheme.lua",
]

bad = []

hex7 = re.compile(r"#[0-9a-fA-F]{6}")
hex8 = re.compile(r"#[0-9a-fA-F]{8}")
for rel in targets:
    path = os.path.join(project_root, rel)
    text = open(path, encoding="utf-8").read()

    for h in hex7.findall(text):
        if h.lower() not in allowed_hex:
            bad.append((rel, h))

    # Allow fully-opaque alpha variants (e.g. Windows Terminal tab backgrounds): #RRGGBBFF
    for h in hex8.findall(text):
        base = h[0:7].lower()
        alpha = h[7:9].lower()
        if base not in allowed_hex or alpha != "ff":
            bad.append((rel, h))

    if rel.endswith("custom_theme.fish"):
        for line in text.splitlines():
            m = re.match(r"^set -l \\w+\\s+([0-9a-fA-F]{6})$", line.strip())
            if m and m.group(1).lower() not in allowed_hex6:
                bad.append((rel, m.group(1)))

if bad:
    for rel, h in bad:
        print(f"Found non-palette color in {rel}: {h}")
    raise SystemExit(1)
PY

  [ "$status" -eq 0 ]
}
