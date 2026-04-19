#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_bundle

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <fzf_colors.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="#", uppercase=True)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

fzf = bundle["fzf"]

fzf_roles = {
    "fzf_foreground": fzf["foreground"],
    "fzf_background": fzf["background"],
    "fzf_selected_background": fzf["selected_background"],
    "fzf_muted": fzf["muted"],
    "fzf_match": fzf["match"],
    "fzf_selected_match": fzf["selected_match"],
    "fzf_info": fzf["info"],
    "fzf_marker": fzf["marker"],
    "fzf_prompt": fzf["prompt"],
    "fzf_spinner": fzf["spinner"],
    "fzf_pointer": fzf["pointer"],
    "fzf_border": fzf["border"],
    "fzf_header": fzf["header"],
    "fzf_label": fzf["label"],
    "fzf_query": fzf["query"],
    "fzf_gutter": fzf["gutter"],
}

with open(fish_file) as f:
    content = f.read()

for fish_var, hex_val in fzf_roles.items():
    content = re.sub(
        rf'^(set -l {fish_var}\s+)"#[0-9a-fA-F]{{6}}"',
        rf'\g<1>"{hex_val}"',
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
