#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import lighten, load_theme

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <fzf_colors.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    colors = load_theme(yaml_file, prefix="#", uppercase=True)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)


# fish variable -> resolved hex color
# bg1 is computed (cursor line color), matching apply-nvim-theme's bg_alt = lighten(bg, 0x10)
palette = {
    "fg0": colors["foreground"],
    "bg0": colors["background"],
    "bg1": lighten(colors["background"], 0x10, prefix="#", uppercase=True),
    "bg2": colors["brightBlack"],
    "red": colors["red"],
    "yellow": colors["yellow"],
    "green": colors["green"],
    "magenta": colors["magenta"],
}

with open(fish_file) as f:
    content = f.read()

for fish_var, hex_val in palette.items():
    content = re.sub(
        rf'^(set -l {fish_var}\s+)"#[0-9a-fA-F]{{6}}"',
        rf'\g<1>"{hex_val}"',
        content,
        flags=re.MULTILINE,
    )

dir_ = os.path.dirname(os.path.abspath(fish_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, fish_file)
print(f"Updated {fish_file}")
