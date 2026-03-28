#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import derive_vim_palette, load_theme_bundle

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom.vim>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
vim_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="", uppercase=False)
    palette = derive_vim_palette(base16=bundle["base16"], ansi=bundle["ansi_roles"])
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

with open(vim_file) as f:
    content = f.read()

for slot, hex_val in palette.items():
    # Replace: let s:gui0A        = "XXXXXX"
    content = re.sub(
        rf'(let s:{re.escape(slot)}\s+=\s+)"[0-9a-fA-F]{{6}}"',
        rf'\g<1>"{hex_val}"',
        content,
    )
    # Replace: let g:base16_gui0A = "XXXXXX"
    content = re.sub(
        rf'(let g:base16_{re.escape(slot)}\s+=\s+)"[0-9a-fA-F]{{6}}"',
        rf'\g<1>"{hex_val}"',
        content,
    )

dir_ = os.path.dirname(os.path.abspath(vim_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, vim_file)
print(f"Updated {vim_file}")
