#!/usr/bin/env python3

import json
import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <settings.json>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
json_file = sys.argv[2]

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

WINDOWS_TERMINAL_KEYS = {
    "tab_background",
    "tab_unfocused_background",
}

PALETTE_TO_SCHEME = {
    "bg": "background",
    "fg": "foreground",
    "black": "black",
    "red": "red",
    "green": "green",
    "yellow": "yellow",
    "blue": "blue",
    "magenta": "purple",
    "cyan": "cyan",
    "white": "white",
    "bright_black": "brightBlack",
    "bright_red": "brightRed",
    "bright_green": "brightGreen",
    "bright_yellow": "brightYellow",
    "bright_blue": "brightBlue",
    "bright_magenta": "brightPurple",
    "bright_cyan": "brightCyan",
    "bright_white": "brightWhite",
}


def normalize_hex(value):
    return "#" + value.lstrip("#").upper()


def parse_section(path, section_name, required_keys):
    values = {}
    active_section = None
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()

            if stripped == f"{section_name}:":
                active_section = section_name
                continue

            if active_section:
                if line and not line.startswith("  "):
                    active_section = None
                    continue

                match = key_pattern.match(line)
                if match:
                    key = match.group(1) or match.group(2)
                    values[key] = normalize_hex(match.group(3))

    if not values:
        raise ValueError(
            f"{section_name.replace('_', ' ').title()} section is required in YAML"
        )

    missing = sorted(required_keys - set(values.keys()))
    if missing:
        raise ValueError(
            f"{section_name.replace('_', ' ').title()} is missing required keys: "
            + ", ".join(missing)
        )

    return values


try:
    base_palette = parse_section(yaml_file, "base_palette", BASE_PALETTE_KEYS)
    windows_terminal = parse_section(
        yaml_file, "windows_terminal", WINDOWS_TERMINAL_KEYS
    )
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

colors = {
    scheme_key: base_palette[palette_key]
    for palette_key, scheme_key in PALETTE_TO_SCHEME.items()
}

with open(json_file) as f:
    settings = json.load(f)

scheme = settings["schemes"][0]
for name, hex_val in colors.items():
    scheme[name] = hex_val

scheme["cursorColor"] = base_palette["cursor"]
scheme["selectionBackground"] = base_palette["selection"]

# Windows Terminal theme colors support alpha; use fully-opaque alpha for consistency.
tab_bg = windows_terminal["tab_background"] + "FF"
tab_unfocused_background = windows_terminal["tab_unfocused_background"] + "FF"
settings["themes"][0]["tab"]["background"] = tab_bg
settings["themes"][0]["tabRow"]["background"] = tab_bg
settings["themes"][0]["tabRow"]["unfocusedBackground"] = tab_unfocused_background

dir_ = os.path.dirname(os.path.abspath(json_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    json.dump(settings, tmp, indent=2, ensure_ascii=False)
    tmp.write("\n")
os.replace(tmp_path, json_file)
print(f"Updated {json_file}")
