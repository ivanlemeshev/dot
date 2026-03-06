#!/usr/bin/env python3

import json
import os
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_sections

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <settings.json>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
json_file = sys.argv[2]

try:
    colors, palette = load_theme_sections(yaml_file, prefix="#", uppercase=True)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

# Windows Terminal uses 'purple'/'brightPurple' instead of 'magenta'/'brightMagenta'
wt_name = {"magenta": "purple", "brightMagenta": "brightPurple"}

with open(json_file) as f:
    settings = json.load(f)

scheme = settings["schemes"][0]
for name, hex_val in colors.items():
    scheme[wt_name.get(name, name)] = hex_val
scheme["background"] = palette.get("background_0", colors["background"])
scheme["foreground"] = palette.get("foreground", colors["foreground"])
scheme["cursorColor"] = palette.get("foreground", colors["white"])
scheme["selectionBackground"] = palette.get("background_2", colors["brightBlack"])

# Windows Terminal theme colors support alpha; use fully-opaque alpha for consistency.
tab_bg = palette.get("background_0", colors["background"]) + "FF"
settings["themes"][0]["tab"]["background"] = tab_bg
settings["themes"][0]["tabRow"]["background"] = tab_bg
settings["themes"][0]["tabRow"]["unfocusedBackground"] = tab_bg

dir_ = os.path.dirname(os.path.abspath(json_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    json.dump(settings, tmp, indent=2, ensure_ascii=False)
    tmp.write("\n")
os.replace(tmp_path, json_file)
print(f"Updated {json_file}")
