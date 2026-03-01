#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <ls_colors.fish>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    colors = load_theme(yaml_file, prefix="#", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

# fish variable -> YAML color name
# Format in file: set -l <var>    "<R>;<G>;<B>"  # #<HEX>
palette = {
    "fg0": "foreground",
    "bg0": "background",
    "red": "red",
    "yellow": "yellow",
    "green": "green",
    "blue": "blue",
    "magenta": "magenta",
    "dim": "brightBlack",
    "cyan": "cyan",
}


def to_rgb(hex_color):
    h = hex_color.lstrip("#")
    return f"{int(h[0:2], 16)};{int(h[2:4], 16)};{int(h[4:6], 16)}"


with open(fish_file) as f:
    content = f.read()

for fish_var, yaml_key in palette.items():
    hex_val = colors[yaml_key]
    rgb_val = to_rgb(hex_val)
    content = re.sub(
        rf'^(set -l {fish_var}\s+)"[0-9;]+"(\s+#\s*)#[0-9a-fA-F]{{6}}',
        rf'\g<1>"{rgb_val}"\g<2>{hex_val}',
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
