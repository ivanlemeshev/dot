#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <fzf_colors.fish>",
        file=sys.stderr,
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

FZF_KEYS = {
    "fg",
    "bg",
    "hl",
    "fg+",
    "bg+",
    "hl+",
    "info",
    "border",
    "gutter",
    "query",
    "prompt",
    "pointer",
    "marker",
    "spinner",
    "header",
    "label",
}


def normalize_hex(value):
    return "#" + value.lstrip("#").upper()


def parse_fzf(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "fzf:":
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
        raise ValueError("Fzf section is required in YAML")

    missing = sorted(FZF_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Fzf is missing required keys: " + ", ".join(missing))

    return values


try:
    fzf = parse_fzf(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

fzf_roles = {
    "fzf_foreground": fzf["fg"],
    "fzf_background": fzf["bg"],
    "fzf_selected_background": fzf["bg+"],
    "fzf_muted": fzf["border"],
    "fzf_match": fzf["hl"],
    "fzf_selected_match": fzf["hl+"],
    "fzf_info": fzf["info"],
    "fzf_border": fzf["border"],
    "fzf_gutter": fzf["gutter"],
    "fzf_query": fzf["query"],
    "fzf_prompt": fzf["prompt"],
    "fzf_pointer": fzf["pointer"],
    "fzf_marker": fzf["marker"],
    "fzf_header": fzf["header"],
    "fzf_label": fzf["label"],
    "fzf_spinner": fzf["spinner"],
}

with open(fish_file, encoding="utf-8") as f:
    content = f.read()

for fish_var, hex_val in fzf_roles.items():
    content = re.sub(
        rf'^(set -l {re.escape(fish_var)}\s+)"#[0-9a-fA-F]{{6}}"',
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
