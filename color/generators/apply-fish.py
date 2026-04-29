#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom_theme.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

FISH_KEYS = {
    "background",
    "foreground",
    "muted",
    "normal",
    "command",
    "keyword",
    "option",
    "param",
    "quote",
    "redirection",
    "end",
    "operator",
    "escape",
    "comment",
    "error",
    "autosuggestion",
    "valid_path",
    "cancel",
    "selection_background",
    "search_match_background",
    "cwd",
    "cwd_root",
    "user",
    "host",
    "host_remote",
    "status",
    "pager_progress",
    "pager_prefix",
    "pager_completion",
    "pager_description",
    "pager_selected_background",
    "pager_selected_completion",
    "pager_selected_description",
}


def normalize_hex(value):
    return "#" + value.lstrip("#").lower()


def parse_fish(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "fish:":
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
        raise ValueError("Fish section is required in YAML")

    missing = sorted(FISH_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Fish is missing required keys: " + ", ".join(missing))

    return values


try:
    fish = parse_fish(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

roles = {
    "fish_background": fish["background"],
    "fish_foreground": fish["foreground"],
    "fish_muted": fish["muted"],
    "fish_normal": fish["normal"],
    "fish_command": fish["command"],
    "fish_keyword": fish["keyword"],
    "fish_option": fish["option"],
    "fish_param": fish["param"],
    "fish_quote": fish["quote"],
    "fish_redirection": fish["redirection"],
    "fish_end": fish["end"],
    "fish_operator": fish["operator"],
    "fish_escape": fish["escape"],
    "fish_comment": fish["comment"],
    "fish_error": fish["error"],
    "fish_autosuggestion": fish["autosuggestion"],
    "fish_valid_path": fish["valid_path"],
    "fish_cancel": fish["cancel"],
    "fish_selection_background": fish["selection_background"],
    "fish_selection_search_match": fish["search_match_background"],
    "fish_cwd": fish["cwd"],
    "fish_cwd_root": fish["cwd_root"],
    "fish_user": fish["user"],
    "fish_host": fish["host"],
    "fish_host_remote": fish["host_remote"],
    "fish_status": fish["status"],
    "fish_pager_progress": fish["pager_progress"],
    "fish_pager_prefix": fish["pager_prefix"],
    "fish_pager_completion": fish["pager_completion"],
    "fish_pager_description": fish["pager_description"],
    "fish_pager_selected_background": fish["pager_selected_background"],
    "fish_pager_selected_completion": fish["pager_selected_completion"],
    "fish_pager_selected_description": fish["pager_selected_description"],
}

with open(fish_file, encoding="utf-8") as f:
    content = f.read()

for fish_var, hex_val in roles.items():
    content = re.sub(
        rf"^(set -l {re.escape(fish_var)}\s+)[0-9a-fA-F]{{6}}$",
        rf"\g<1>{hex_val.lstrip('#')}",
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
