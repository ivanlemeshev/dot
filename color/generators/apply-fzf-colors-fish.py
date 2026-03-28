#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_sections

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <fzf_colors.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    colors, raw_palette = load_theme_sections(yaml_file, prefix="#", uppercase=True)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)


def require_palette(key):
    if key not in raw_palette:
        raise ValueError(f"Missing required palette key: {key}")
    return raw_palette[key]


try:
    fzf_palette = {
        "fg0": require_palette("fg"),
        "bg0": require_palette("bg"),
        "bg1": require_palette("black"),
        "bg2": require_palette("bright_black"),
        "red": require_palette("red"),
        "yellow": require_palette("yellow"),
        "green": require_palette("green"),
        "magenta": require_palette("magenta"),
    }
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

with open(fish_file) as f:
    content = f.read()

for fish_var, hex_val in fzf_palette.items():
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
