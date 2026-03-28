#!/usr/bin/env python3

import os
import plistlib
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_sections

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <output.itermcolors>",
        file=sys.stderr,
    )
    sys.exit(1)

yaml_file = sys.argv[1]
itermcolors_file = sys.argv[2]

try:
    colors, ansi = load_theme_sections(yaml_file, prefix="#", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

ansi_map = [
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "brightBlack",
    "brightRed",
    "brightGreen",
    "brightYellow",
    "brightBlue",
    "brightMagenta",
    "brightCyan",
    "brightWhite",
]


def color_entry(name):
    return color_entry_hex(colors[name])


def color_entry_hex(hex_val):
    h = hex_val.lstrip("#")
    r, g, b = int(h[0:2], 16) / 255, int(h[2:4], 16) / 255, int(h[4:6], 16) / 255
    return {
        "Blue Component": b,
        "Color Space": "sRGB",
        "Green Component": g,
        "Red Component": r,
    }


pl = {}

for i, name in enumerate(ansi_map):
    pl[f"Ansi {i} Color"] = color_entry(name)

bg = ansi.get("bg", colors["background"])
fg = ansi.get("fg", colors["foreground"])
selection_bg = ansi.get("white", colors["brightWhite"])

pl["Background Color"] = color_entry_hex(bg)
pl["Bold Color"] = color_entry_hex(fg)
pl["Cursor Color"] = color_entry_hex(fg)
pl["Cursor Text Color"] = color_entry_hex(bg)
pl["Foreground Color"] = color_entry_hex(fg)
pl["Selected Text Color"] = color_entry_hex(fg)
pl["Selection Color"] = color_entry_hex(selection_bg)

dir_ = os.path.dirname(os.path.abspath(itermcolors_file))
with tempfile.NamedTemporaryFile(
    mode="wb", dir=dir_, delete=False, suffix=".tmp"
) as tmp:
    tmp_path = tmp.name
    plistlib.dump(pl, tmp, fmt=plistlib.FMT_XML)
os.replace(tmp_path, itermcolors_file)
print(f"Updated {itermcolors_file}")
