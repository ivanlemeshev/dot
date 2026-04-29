#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <.tmux.conf>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
tmux_file = sys.argv[2]

TMUX_KEYS = {
    "bar_bg",
    "bar_fg",
    "block_bg",
    "block_fg",
    "alert_bg",
    "alert_fg",
    "bell_bg",
    "bell_fg",
    "border_fg",
    "border_active_fg",
    "message_bg",
    "message_fg",
    "mode_bg",
    "mode_fg",
}


def normalize_hex(value):
    return "#" + value.lstrip("#").lower()


def parse_tmux(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "tmux:":
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
        raise ValueError("Tmux section is required in YAML")

    missing = sorted(TMUX_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Tmux is missing required keys: " + ", ".join(missing))

    return values


try:
    tmux = parse_tmux(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

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

with open(tmux_file, encoding="utf-8") as f:
    content = f.read()

for var, new_hex in tmux_vars.items():
    content = re.sub(
        rf'(set -g\s+{re.escape(var)}\s+)"#[0-9a-fA-F]{{6}}"',
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
