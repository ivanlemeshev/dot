#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_bundle

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <colorscheme.lua>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
lua_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="", uppercase=False)
    sections = {
        "ui": bundle["ui"],
        "statusline": bundle["statusline"],
        "semantic": bundle["semantic"],
        "syntax": bundle["syntax"],
        "tool": bundle["tool"],
        "fzf": bundle["fzf"],
    }
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)


def _replace_hex_value(content, slot, hex_val):
    key = rf'(?:\[\s*["\']{re.escape(slot)}["\']\s*\]|\b{re.escape(slot)})'
    return re.sub(
        rf'({key}\s*=\s*)"#[0-9a-fA-F]{{6}}"',
        rf'\g<1>"#{hex_val}"',
        content,
    )


def _replace_table_block(content, table_name, values):
    pattern = re.compile(
        rf"(M\.{re.escape(table_name)}\s*=\s*\{{)(.*?)(^\}})",
        re.DOTALL | re.MULTILINE,
    )

    def replace(match):
        body = match.group(2)
        for slot, hex_val in values.items():
            body = _replace_hex_value(body, slot, hex_val)
        return match.group(1) + body + match.group(3)

    content, count = pattern.subn(replace, content, count=1)
    if count == 0:
        raise ValueError(f"{table_name} block is missing from colorscheme.lua")
    return content


with open(lua_file) as f:
    content = f.read()

for table_name, values in sections.items():
    content = _replace_table_block(content, table_name, values)

dir_ = os.path.dirname(os.path.abspath(lua_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, lua_file)
print(f"Updated {lua_file}")
