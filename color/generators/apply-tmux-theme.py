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

tmux = bundle["tmux"]

tmux_vars = {
    "@tmux_bar_bg": tmux["bar_bg"],
    "@tmux_bar_fg": tmux["bar_fg"],
    "@tmux_block_bg": tmux["block_bg"],
    "@tmux_block_fg": tmux["block_fg"],
    "@tmux_alert_bg": tmux["alert_bg"],
    "@tmux_alert_fg": tmux["alert_fg"],
    "@tmux_bell_bg": tmux["bell_bg"],
    "@tmux_bell_fg": tmux["bell_fg"],
    "@tmux_border_fg": tmux["border_fg"],
    "@tmux_border_active_fg": tmux["border_active_fg"],
    "@tmux_message_bg": tmux["message_bg"],
    "@tmux_message_fg": tmux["message_fg"],
    "@tmux_mode_bg": tmux["mode_bg"],
    "@tmux_mode_fg": tmux["mode_fg"],
}

with open(tmux_file) as f:
    content = f.read()


for var, new_hex in tmux_vars.items():
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
