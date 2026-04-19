#!/usr/bin/env python3

import json
import os
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme_bundle

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <theme.omp.json>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
omp_file = sys.argv[2]

try:
    bundle = load_theme_bundle(yaml_file, prefix="#", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)
template_file = os.path.join(
    os.path.dirname(__file__), "..", "templates", "oh-my-posh.json.tmpl"
)
with open(template_file, encoding="utf-8") as f:
    content = f.read()

colors = bundle["colors"]
ansi = bundle["ansi"]
merged = {
    **colors,
    **ansi,
    "foreground": bundle["ui"]["fg"],
    "time": bundle["tool"]["git_clean"],
    "user": bundle["tool"]["prompt"],
    "host": bundle["tool"]["path"],
    "root": bundle["tool"]["root"],
    "git_clean": bundle["tool"]["git_clean"],
    "git_dirty": bundle["tool"]["git_dirty"],
    "git_ahead": bundle["tool"]["git_ahead"],
    "git_behind": bundle["tool"]["git_behind"],
    "duration": bundle["tool"]["duration"],
    "status_ok": bundle["tool"]["git_clean"],
    "status_error": bundle["diagnostic"]["error"],
    "prompt": bundle["tool"]["path"],
}
for name, hex_val in merged.items():
    content = content.replace(f"__{name}__", hex_val)

data = json.loads(content)

dir_ = os.path.dirname(os.path.abspath(omp_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    json.dump(data, tmp, indent=2, ensure_ascii=False)
    tmp.write("\n")
os.replace(tmp_path, omp_file)
print(f"Updated {omp_file}")
