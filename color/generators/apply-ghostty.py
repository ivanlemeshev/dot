#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <ghostty-theme>",
        file=sys.stderr,
    )
    sys.exit(1)

yaml_file = sys.argv[1]
ghostty_file = sys.argv[2]

BASE_PALETTE_KEYS = {
    "statusline",
    "selection",
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


try:
    base_palette = parse_base_palette(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

lines = []
for i, key in enumerate(ANSI_ORDER):
    lines.append(f"palette = {i}={base_palette[key]}")

lines.extend(
    [
        f"background = {base_palette['bg']}",
        f"foreground = {base_palette['fg']}",
        f"cursor-color = {base_palette['cursor']}",
        # Match the behavior of the other terminal theme generators: use the
        # editor/terminal background under the cursor so block cursors stay legible.
        f"cursor-text = {base_palette['bg']}",
        f"selection-background = {base_palette['selection']}",
        f"selection-foreground = {base_palette['fg']}",
    ]
)

dir_ = os.path.dirname(os.path.abspath(ghostty_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write("\n".join(lines) + "\n")
os.replace(tmp_path, ghostty_file)
print(f"Updated {ghostty_file}")
