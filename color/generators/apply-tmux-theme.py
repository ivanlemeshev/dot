#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <.tmux.conf>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
tmux_file = sys.argv[2]

try:
    colors = load_theme(yaml_file, prefix="#", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

# tmux theme variable → YAML color name
thm_vars = {
    "@thm_bg": "background",  # status bar / pane background
    "@thm_fg": "foreground",  # default text
    "@thm_red": "red",  # urgent: prefix active, battery low, offline
    "@thm_green": "green",  # ok: session name, staging
    "@thm_yellow": "yellow",  # accent: current window, zoom, last window
    "@thm_blue": "blue",  # path, date/time
    "@thm_magenta": "magenta",  # battery, online status
    "@thm_dim": "brightBlack",  # separators, borders, inactive window labels
}

with open(tmux_file) as f:
    content = f.read()

for var, yaml_name in thm_vars.items():
    new_hex = colors[yaml_name]
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
