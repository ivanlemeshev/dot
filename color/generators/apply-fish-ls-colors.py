#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <ls_colors.fish>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

LS_COLORS_KEYS = {
    "foreground",
    "background",
    "error",
    "executable",
    "document",
    "directory",
    "special",
    "media",
    "backup",
}


def normalize_hex(value):
    return "#" + value.lstrip("#").lower()


def parse_ls_colors(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "ls_colors:":
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
        raise ValueError("Ls Colors section is required in YAML")

    missing = sorted(LS_COLORS_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Ls Colors is missing required keys: " + ", ".join(missing))

    return values


def to_rgb(hex_color):
    h = hex_color.lstrip("#")
    return f"{int(h[0:2], 16)};{int(h[2:4], 16)};{int(h[4:6], 16)}"


try:
    ls = parse_ls_colors(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

roles = {
    "ls_foreground": ls["foreground"],
    "ls_background": ls["background"],
    "ls_error": ls["error"],
    "ls_document": ls["document"],
    "ls_executable": ls["executable"],
    "ls_directory": ls["directory"],
    "ls_special": ls["special"],
    "ls_media": ls["media"],
    "ls_backup": ls["backup"],
}

with open(fish_file, encoding="utf-8") as f:
    content = f.read()

for fish_var, hex_val in roles.items():
    rgb_val = to_rgb(hex_val)
    content = re.sub(
        rf'^(set -l {re.escape(fish_var)}\s+)"[0-9;]+"(\s+#\s*)#[0-9a-fA-F]{{6}}',
        rf'\g<1>"{rgb_val}"\g<2>{hex_val}',
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
