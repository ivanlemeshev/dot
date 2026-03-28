#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_bundle

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <.tmux.conf>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
tmux_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="#", uppercase=False)
    base16 = bundle["base16"] or {}
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

# tmux theme variable -> Base16 slot
thm_vars = {
    "@theme_bg": "base00",  # main background
    "@theme_fg": "base05",  # default text
    "@theme_black": "base01",  # elevated background surfaces
    "@theme_red": "base08",  # urgent: prefix active, battery low, offline
    "@theme_green": "base0B",  # ok: session name, staging
    "@theme_yellow": "base0A",  # accent: current window, zoom, last window
    "@theme_blue": "base0D",  # path, date/time
    "@theme_magenta": "base0E",  # battery, online status
    "@theme_cyan": "base0C",  # misc accents
    "@theme_surface": "base02",  # raised status/message surface
    "@theme_bright_black": "base03",  # separators, borders
    "@theme_bright_white": "base07",  # strong neutral accents
}


def hex_to_rgb(hex_value):
    clean = hex_value.lstrip("#")
    return (
        int(clean[0:2], 16),
        int(clean[2:4], 16),
        int(clean[4:6], 16),
    )


def relative_luminance(hex_value):
    def channel(value):
        value = value / 255.0
        if value <= 0.03928:
            return value / 12.92
        return ((value + 0.055) / 1.055) ** 2.4

    r, g, b = hex_to_rgb(hex_value)
    return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)


def contrast_ratio(a, b):
    l1 = relative_luminance(a)
    l2 = relative_luminance(b)
    lighter = max(l1, l2)
    darker = min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)


def best_contrast_fg(bg):
    candidates = (base16["base00"], base16["base05"])
    return max(candidates, key=lambda fg: contrast_ratio(bg, fg))


contrast_vars = {
    "@theme_on_bg": "base00",
    "@theme_on_surface": "base02",
    "@theme_on_red": "base08",
    "@theme_on_bright_black": "base03",
    "@theme_on_bright_white": "base07",
}

with open(tmux_file) as f:
    content = f.read()


for var, slot in thm_vars.items():
    new_hex = base16[slot]
    content = re.sub(
        rf'(set -g {re.escape(var)} )"#[0-9a-fA-F]{{6}}"',
        rf'\g<1>"{new_hex}"',
        content,
    )

for var, slot in contrast_vars.items():
    new_hex = best_contrast_fg(base16[slot])
    content = re.sub(
        rf'(set -g {re.escape(var)} )"#[0-9a-fA-F]{{6}}"',
        rf'\g<1>"{new_hex}"',
        content,
    )

dir_ = os.path.dirname(os.path.abspath(tmux_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, tmux_file)
print(f"Updated {tmux_file}")
