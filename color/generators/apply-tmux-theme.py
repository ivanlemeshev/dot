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
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

palette = bundle["palette"]
ui = bundle["ui"]
diagnostic = bundle["diagnostic"]
tool = bundle["tool"]

thm_vars = {
    "@theme_ui_background": palette["bg0"],
    "@theme_ui_foreground": palette["fg0"],
    "@theme_ui_background_alt": palette["bg1"],
    "@theme_ui_surface": palette["bg3"],
    "@theme_ui_muted": palette["grey0"],
    "@theme_ui_emphasis": palette["grey2"],
    "@theme_status_alert": diagnostic["error"],
    "@theme_status_active": diagnostic["ok"],
    "@theme_status_prompt": tool["prompt"],
    "@theme_path": tool["path"],
    "@theme_accent": palette["purple"],
    "@theme_accent_alt": palette["aqua"],
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
    candidates = (palette["bg0"], palette["fg0"])
    return max(candidates, key=lambda fg: contrast_ratio(bg, fg))


contrast_vars = {
    "@theme_on_ui_background": palette["bg0"],
    "@theme_on_ui_surface": palette["bg3"],
    "@theme_on_status_alert": diagnostic["error"],
    "@theme_on_ui_muted": palette["grey0"],
    "@theme_on_ui_emphasis": palette["grey2"],
}

with open(tmux_file) as f:
    content = f.read()


for var, new_hex in thm_vars.items():
    content = re.sub(
        rf'(set -g {re.escape(var)} )"#[0-9a-fA-F]{{6}}"',
        rf'\g<1>"{new_hex}"',
        content,
    )

for var, bg in contrast_vars.items():
    new_hex = best_contrast_fg(bg)
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
