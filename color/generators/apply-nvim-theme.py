#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import derive_editor_palette, load_theme

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <colorscheme.lua>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
lua_file = sys.argv[2]

try:
    palette = derive_editor_palette(load_theme(yaml_file, prefix="", uppercase=False))
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

with open(lua_file) as f:
    content = f.read()

for slot, hex_val in palette.items():
    # Replace:   bg     = "#151515",
    content = re.sub(
        rf'\b({re.escape(slot)}\s*=\s*)"#[0-9a-fA-F]{{6}}"',
        rf'\g<1>"#{hex_val}"',
        content,
    )

dir_ = os.path.dirname(os.path.abspath(lua_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, lua_file)
print(f"Updated {lua_file}")
