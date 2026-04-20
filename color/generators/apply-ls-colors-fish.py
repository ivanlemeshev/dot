#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_bundle

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <ls_colors.fish>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="#", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

ls = bundle["ls_colors"]

roles = {
    "ls_foreground": ls["foreground"],
    "ls_background": ls["background"],
    "ls_error": ls["error"],
    "ls_document": ls["document"],
    "ls_executable": ls["executable"],
    "ls_directory": ls["directory"],
    "ls_special": ls["special"],
    "ls_media": ls["media"],
    "ls_backup": ls["backup"],
}


def to_rgb(hex_color):
    h = hex_color.lstrip("#")
    return f"{int(h[0:2], 16)};{int(h[2:4], 16)};{int(h[4:6], 16)}"


with open(fish_file) as f:
    content = f.read()


for fish_var, hex_val in roles.items():
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
