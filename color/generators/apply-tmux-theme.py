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

statusline = bundle["statusline"]
semantic = bundle["semantic"]
ui = bundle["ui"]

thm_vars = {
    "@theme_ui_background": ui["bg"],
    "@theme_ui_foreground": ui["fg"],
    "@theme_ui_background_alt": ui["bg_alt"],
    "@theme_ui_surface": statusline["section_bg"],
    "@theme_ui_muted": ui["muted"],
    "@theme_ui_emphasis": statusline["normal_bg"],
    "@theme_status_alert": semantic["error"],
    "@theme_status_active": ui["fg"],
    "@theme_status_prompt": ui["fg"],
    "@theme_path": semantic["directory"],
    "@theme_accent": ui["fg"],
    "@theme_accent_alt": ui["fg"],
    "@theme_on_ui_background": ui["bg"],
    "@theme_on_ui_surface": statusline["section_fg"],
    "@theme_on_status_active": ui["bg"],
    "@theme_on_status_prompt": ui["bg"],
    "@theme_on_status_alert": ui["bg"],
    "@theme_on_ui_muted": ui["bg"],
    "@theme_on_ui_emphasis": statusline["normal_fg"],
}

with open(tmux_file) as f:
    content = f.read()


for var, new_hex in thm_vars.items():
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
