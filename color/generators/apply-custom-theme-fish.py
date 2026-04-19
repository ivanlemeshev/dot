#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_bundle

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom_theme.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

palette = bundle["palette"]
syntax = bundle["syntax"]
diagnostic = bundle["diagnostic"]
tool = bundle["tool"]
ui = bundle["ui"]

roles = {
    "ui_background": palette["bg0"],
    "ui_background_alt": palette["bg1"],
    "ui_selection": ui["selection"],
    "ui_foreground": palette["fg0"],
    "ui_foreground_alt": palette["fg1"],
    "ui_muted": syntax["comment"],
    "syntax_function": syntax["function"],
    "syntax_keyword": syntax["keyword"],
    "syntax_type": syntax["type"],
    "syntax_variable": syntax["variable"],
    "syntax_string": syntax["string"],
    "syntax_operator": syntax["operator"],
    "syntax_escape": syntax["escape"],
    "diagnostic_error": diagnostic["error"],
    "tool_path": tool["path"],
    "tool_root": tool["root"],
    "tool_remote": tool["prompt"],
}


with open(fish_file) as f:
    content = f.read()

for fish_var, hex_val in roles.items():
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
