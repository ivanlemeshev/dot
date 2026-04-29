#!/usr/bin/env python3

import os
import plistlib
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <output.itermcolors>",
        file=sys.stderr,
    )
    sys.exit(1)

yaml_file = sys.argv[1]
itermcolors_file = sys.argv[2]

BASE_PALETTE_KEYS = {
    "current_line",
    "selection",
    "comment",
    "bg",
    "fg",
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "bright_black",
    "bright_red",
    "bright_green",
    "bright_yellow",
    "bright_blue",
    "bright_magenta",
    "bright_cyan",
    "bright_white",
}

ANSI_ORDER = [
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "bright_black",
    "bright_red",
    "bright_green",
    "bright_yellow",
    "bright_blue",
    "bright_magenta",
    "bright_cyan",
    "bright_white",
]


def normalize_hex(value):
    return "#" + value.lstrip("#").lower()


def parse_base_palette(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "base_palette:":
                active_section = True
                continue
            if active_section:
                if line and not line.startswith("  "):
                    break
                match = key_pattern.match(line)
                if match:
                    key = match.group(1) or match.group(2)
                    values[key] = normalize_hex(match.group(3))

    if not values:
        raise ValueError("Base palette section is required in YAML")

    missing = sorted(BASE_PALETTE_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Base palette is missing required keys: " + ", ".join(missing))

    return values


def color_entry_hex(hex_val):
    h = hex_val.lstrip("#")
    r, g, b = int(h[0:2], 16) / 255, int(h[2:4], 16) / 255, int(h[4:6], 16) / 255
    return {
        "Blue Component": b,
        "Color Space": "sRGB",
        "Green Component": g,
        "Red Component": r,
    }


try:
    base_palette = parse_base_palette(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

pl = {}

for i, key in enumerate(ANSI_ORDER):
    pl[f"Ansi {i} Color"] = color_entry_hex(base_palette[key])

bg = base_palette["bg"]
fg = base_palette["fg"]
selection_bg = base_palette["selection"]

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
