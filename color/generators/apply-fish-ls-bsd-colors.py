#!/usr/bin/env python3

import os
import sys
import tempfile

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <ls_colors_bsd.fish.inc>",
        file=sys.stderr,
    )
    sys.exit(1)

yaml_file = sys.argv[1]
fish_file = sys.argv[2]

content = """# BSD/macOS ls colors for the portable fallback path.
# This file is sourced by the Fish selector in ls_colors.fish.

set -gx LSCOLORS exfxcxdxbxegedabagacad
set -gx CLICOLOR 1
set -gx __fish_ls_command ls
set -gx __fish_ls_color_opt -G
"""

dir_ = os.path.dirname(os.path.abspath(fish_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, fish_file)
print(f"Updated {fish_file}")
