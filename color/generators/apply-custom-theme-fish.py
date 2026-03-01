#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom_theme.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    colors = load_theme(yaml_file, prefix="", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

# fish variable -> YAML color name
# Format in file: set -l <var>    <hex6>   (bare hex, no #)
palette = {
    "bg0": "background",
    "bg1": "brightBlack",
    "fg0": "foreground",
    "fg1": "brightWhite",
    "red": "red",
    "yellow": "yellow",
    "green": "green",
    "blue": "blue",
    "magenta": "magenta",
    "cyan": "cyan",
}

with open(fish_file) as f:
    content = f.read()

for fish_var, yaml_key in palette.items():
    content = re.sub(
        rf"^(set -l {fish_var}\s+)[0-9a-fA-F]{{6}}$",
        rf"\g<1>{colors[yaml_key]}",
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
