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

fish_ui = bundle["fish_ui"]
fish_syntax = bundle["fish_syntax"]
fish_selection = bundle["fish_selection"]
fish_prompt = bundle["fish_prompt"]
fish_pager = bundle["fish_pager"]

roles = {
    "fish_ui_background": fish_ui["background"],
    "fish_ui_background_alt": fish_ui["background_alt"],
    "fish_ui_foreground": fish_ui["foreground"],
    "fish_ui_foreground_alt": fish_ui["foreground_alt"],
    "fish_ui_muted": fish_ui["muted"],
    "fish_syntax_normal": fish_ui["foreground"],
    "fish_syntax_command": fish_syntax["function"],
    "fish_syntax_keyword": fish_syntax["keyword"],
    "fish_syntax_option": fish_syntax["type"],
    "fish_syntax_param": fish_syntax["variable"],
    "fish_syntax_quote": fish_syntax["string"],
    "fish_syntax_redirection": fish_syntax["operator"],
    "fish_syntax_end": fish_syntax["operator"],
    "fish_syntax_operator": fish_syntax["operator"],
    "fish_syntax_escape": fish_syntax["escape"],
    "fish_syntax_comment": fish_syntax["comment"],
    "fish_syntax_error": fish_syntax["error"],
    "fish_syntax_autosuggestion": fish_ui["foreground_alt"],
    "fish_syntax_valid_path": fish_syntax["valid_path"],
    "fish_syntax_cancel": fish_syntax["error"],
    "fish_selection_background": fish_selection["selection"],
    "fish_selection_search_match": fish_selection["search_match"],
    "fish_prompt_cwd": fish_prompt["cwd"],
    "fish_prompt_cwd_root": fish_prompt["cwd_root"],
    "fish_prompt_user": fish_prompt["user"],
    "fish_prompt_host": fish_prompt["host"],
    "fish_prompt_host_remote": fish_prompt["host_remote"],
    "fish_prompt_status": fish_prompt["status"],
    "fish_pager_progress": fish_pager["progress"],
    "fish_pager_prefix": fish_pager["prefix"],
    "fish_pager_completion": fish_pager["completion"],
    "fish_pager_description": fish_pager["description"],
    "fish_pager_selected_background": fish_pager["selected_background"],
    "fish_pager_selected_completion": fish_pager["selected_completion"],
    "fish_pager_selected_description": fish_pager["selected_description"],
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
