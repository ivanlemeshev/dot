#!/usr/bin/env bats

setup() {
  PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
}

@test "generated theme files match at least one known scheme palette" {
  run python3 - <<PY
import glob
import os
import re
import sys

project_root = "${PROJECT_ROOT}"
schemes_glob = os.path.join(project_root, "color/schemes/*.yaml")
schemes = sorted(glob.glob(schemes_glob))
if not schemes:
    print("No color schemes found.")
    raise SystemExit(1)

sys.path.insert(0, os.path.join(project_root, "color/lib"))
from theme import load_theme_bundle

allowed_by_scheme = {}
for scheme in schemes:
    if "\\npalette:\\n" not in "\\n" + open(scheme, encoding="utf-8").read():
        continue
    bundle = load_theme_bundle(scheme, prefix="#", uppercase=False)
    colors = bundle["colors"]
    raw_ansi = bundle["ansi"]
    semantic = {}
    for section in ("palette", "ui", "statusline", "semantic", "syntax", "diagnostic", "diff", "tool", "omp", "terminal", "tmux", "ls_colors", "fzf", "fish"):
        semantic.update(bundle.get(section, {}))
    allowed_hex = (
        {v.lower() for v in raw_ansi.values()}
        | {v.lower() for v in colors.values()}
        | {v.lower() for v in semantic.values()}
    )
    allowed_hex6 = {h.lstrip("#") for h in allowed_hex}
    allowed_by_scheme[scheme] = (allowed_hex, allowed_hex6)

if not allowed_by_scheme:
    print("No strict semantic color schemes found.")
    raise SystemExit(1)

targets = [
    "windows/terminal/settings.json",
    ".config/tmux/.tmux.conf",
    ".config/oh-my-posh/theme.omp.json",
    ".config/bat/themes/custom.tmTheme",
    ".config/fish/conf.d/fzf_colors.fish",
    ".config/fish/conf.d/ls_colors.fish",
    ".config/fish/conf.d/custom_theme.fish",
    ".config/vim/colors/custom.vim",
    ".config/nvim/lua/lem/colorscheme.lua",
]

observed = []

hex7 = re.compile(r"#[0-9a-fA-F]{6}")
hex8 = re.compile(r"#[0-9a-fA-F]{8}")
for rel in targets:
    path = os.path.join(project_root, rel)
    text = open(path, encoding="utf-8").read()

    for h in hex7.findall(text):
        observed.append((rel, h.lower(), "hex7"))

    # Allow fully-opaque alpha variants (e.g. Windows Terminal tab backgrounds): #RRGGBBFF
    for h in hex8.findall(text):
        observed.append((rel, h.lower(), "hex8"))

    if rel.endswith("custom_theme.fish"):
        for line in text.splitlines():
            m = re.match(r"^set -l \\w+\\s+([0-9a-fA-F]{6})$", line.strip())
            if m:
                observed.append((rel, m.group(1).lower(), "hex6"))

for scheme, (allowed_hex, allowed_hex6) in allowed_by_scheme.items():
    bad = []
    for rel, value, kind in observed:
        if kind == "hex7":
            if value not in allowed_hex:
                bad.append((rel, value))
        elif kind == "hex8":
            base = value[0:7]
            alpha = value[7:9]
            if base not in allowed_hex or alpha != "ff":
                bad.append((rel, value))
        else:
            if value not in allowed_hex6:
                bad.append((rel, value))
    if not bad:
        raise SystemExit(0)

print("Generated files do not match any known scheme palette.")
for rel, value, _ in observed:
    print(f"Observed color in outputs: {rel}: {value}")
raise SystemExit(1)
PY

  [ "$status" -eq 0 ]
}
