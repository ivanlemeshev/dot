#!/usr/bin/env python3

import json
import os
import plistlib
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_sections

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom.tmTheme>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
tmtheme_file = sys.argv[2]

try:
    colors, palette = load_theme_sections(yaml_file, prefix="#", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)
spec_file = os.path.join(
    os.path.dirname(__file__), "..", "templates", "tmtheme_spec.json"
)
with open(spec_file, encoding="utf-8") as f:
    spec = json.load(f)


def resolve_color(name):
    if name in colors:
        return colors[name]
    return palette[name]


global_settings = {}
for item in spec["global_settings"]:
    suffix = item.get("alpha", "")
    global_settings[item["key"]] = resolve_color(item["color"]) + suffix

settings = [{"settings": global_settings}]
for entry in spec["entries"]:
    entry_settings = {"foreground": resolve_color(entry["color"])}
    font_style = entry.get("fontStyle", "")
    if font_style:
        entry_settings["fontStyle"] = font_style
    settings.append(
        {
            "name": entry["name"],
            "scope": entry["scope"],
            "settings": entry_settings,
        }
    )

content = {
    "name": spec["name"],
    "settings": settings,
}

dir_ = os.path.dirname(os.path.abspath(tmtheme_file))
with tempfile.NamedTemporaryFile(
    mode="wb", dir=dir_, delete=False, suffix=".tmp"
) as tmp:
    tmp_path = tmp.name
    plistlib.dump(content, tmp, fmt=plistlib.FMT_XML, sort_keys=False)
os.replace(tmp_path, tmtheme_file)
print(f"Updated {tmtheme_file}")
