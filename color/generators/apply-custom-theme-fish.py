#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_sections

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom_theme.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    colors, palette = load_theme_sections(yaml_file, prefix="", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

# fish variable -> YAML color name
# Format in file: set -l <var>    <hex6>   (bare hex, no #)
palette_map = {
    "bg0": ("background_0", "background"),
    "bg1": ("background_1", "brightBlack"),
    "fg0": ("foreground", "foreground"),
    "fg1": ("grey_2", "brightWhite"),
    "red": ("red", "red"),
    "yellow": ("yellow", "yellow"),
    "green": ("green", "green"),
    "blue": ("blue", "blue"),
    "magenta": ("purple", "magenta"),
    "cyan": ("aqua", "cyan"),
}


def resolve_color(primary, fallback):
    if primary in palette:
        return palette[primary]
    return colors[fallback]


with open(fish_file) as f:
    content = f.read()

for fish_var, (primary, fallback) in palette_map.items():
    hex_val = resolve_color(primary, fallback)
    content = re.sub(
        rf"^(set -l {fish_var}\s+)[0-9a-fA-F]{{6}}$",
        rf"\g<1>{hex_val}",
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
