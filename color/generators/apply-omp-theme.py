#!/usr/bin/env python3

import json
import os
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

from theme import load_theme

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <theme.omp.json>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
omp_file = sys.argv[2]

try:
    colors = load_theme(yaml_file, prefix="#", uppercase=False)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)
template_file = os.path.join(
    os.path.dirname(__file__), "..", "templates", "oh-my-posh.json.tmpl"
)
with open(template_file, encoding="utf-8") as f:
    content = f.read()

for name, hex_val in colors.items():
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
