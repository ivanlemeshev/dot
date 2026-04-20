#!/usr/bin/env python3

import os
import re
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_bundle

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom_theme.fish>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

fish = bundle["fish"]

roles = {
    "fish_ui_background": fish["background"],
    "fish_ui_background_alt": fish["background_alt"],
    "fish_ui_foreground": fish["foreground"],
    "fish_ui_foreground_alt": fish["foreground_alt"],
    "fish_ui_muted": fish["muted"],
    "fish_syntax_normal": fish["foreground"],
    "fish_syntax_command": fish["command"],
    "fish_syntax_keyword": fish["keyword"],
    "fish_syntax_option": fish["option"],
    "fish_syntax_param": fish["param"],
    "fish_syntax_quote": fish["quote"],
    "fish_syntax_redirection": fish["redirection"],
    "fish_syntax_end": fish["end"],
    "fish_syntax_operator": fish["operator"],
    "fish_syntax_escape": fish["escape"],
    "fish_syntax_comment": fish["comment"],
    "fish_syntax_error": fish["error"],
    "fish_syntax_autosuggestion": fish["foreground_alt"],
    "fish_syntax_valid_path": fish["valid_path"],
    "fish_syntax_cancel": fish["error"],
    "fish_selection_background": fish["selection_background"],
    "fish_selection_search_match": fish["search_match_background"],
    "fish_prompt_cwd": fish["cwd"],
    "fish_prompt_cwd_root": fish["cwd_root"],
    "fish_prompt_user": fish["user"],
    "fish_prompt_host": fish["host"],
    "fish_prompt_host_remote": fish["host_remote"],
    "fish_prompt_status": fish["status"],
    "fish_pager_progress": fish["pager_progress"],
    "fish_pager_prefix": fish["pager_prefix"],
    "fish_pager_completion": fish["pager_completion"],
    "fish_pager_description": fish["pager_description"],
    "fish_pager_selected_background": fish["pager_selected_background"],
    "fish_pager_selected_completion": fish["pager_selected_completion"],
    "fish_pager_selected_description": fish["pager_selected_description"],
}


with open(fish_file) as f:
    content = f.read()

for fish_var, hex_val in roles.items():
    content = re.sub(
        rf"^(set -l {fish_var}\s+)[0-9a-fA-F]{{6}}$",
        rf"\g<1>{hex_val}",
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
