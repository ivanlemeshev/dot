#!/usr/bin/env python3

import os
import plistlib
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <output.itermcolors>",
        file=sys.stderr,
    )
    sys.exit(1)

yaml_file = sys.argv[1]
itermcolors_file = sys.argv[2]

try:
    colors = load_theme(yaml_file, prefix="#", uppercase=False)
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
    h = colors[name].lstrip("#")
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

pl["Background Color"] = color_entry("background")
pl["Bold Color"] = color_entry("foreground")
pl["Cursor Color"] = color_entry("foreground")
pl["Cursor Text Color"] = color_entry("background")
pl["Foreground Color"] = color_entry("foreground")
pl["Selected Text Color"] = color_entry("foreground")
pl["Selection Color"] = color_entry("background")

dir_ = os.path.dirname(os.path.abspath(itermcolors_file))
with tempfile.NamedTemporaryFile(
    mode="wb", dir=dir_, delete=False, suffix=".tmp"
) as tmp:
    tmp_path = tmp.name
    plistlib.dump(pl, tmp, fmt=plistlib.FMT_XML)
os.replace(tmp_path, itermcolors_file)
print(f"Updated {itermcolors_file}")
