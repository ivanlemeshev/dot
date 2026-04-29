#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <colorscheme.lua>", file=sys.stderr
    )
    sys.exit(1)

yaml_file = sys.argv[1]
lua_file = sys.argv[2]

FZF_KEYS = {
    "fg",
    "bg",
    "hl",
    "fg+",
    "bg+",
    "hl+",
    "info",
    "border",
    "query",
    "prompt",
    "pointer",
    "marker",
    "spinner",
    "header",
    "label",
    "gutter",
}

STATUSLINE_KEYS = {
    "normal_bg",
    "normal_fg",
    "insert_bg",
    "insert_fg",
    "visual_bg",
    "visual_fg",
    "replace_bg",
    "replace_fg",
    "command_bg",
    "command_fg",
    "terminal_bg",
    "terminal_fg",
    "section_bg",
    "section_fg",
    "inactive_bg",
    "inactive_fg",
}


def normalize_hex(value):
    return "#" + value.lstrip("#").lower()


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


def parse_statusline(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "statusline:":
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
        raise ValueError("Statusline section is required in YAML")

    missing = sorted(STATUSLINE_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Statusline is missing required keys: " + ", ".join(missing))

    return values


def render_fzf_block(values):
    lines = [
        "M.fzf = {",
        f'  fg = "{values["fg"]}",',
        f'  bg = "{values["bg"]}",',
        f'  hl = "{values["hl"]}",',
        f'  ["fg+"] = "{values["fg+"]}",',
        f'  ["bg+"] = "{values["bg+"]}",',
        f'  ["hl+"] = "{values["hl+"]}",',
        f'  info = "{values["info"]}",',
        f'  border = "{values["border"]}",',
        f'  query = "{values["query"]}",',
        f'  prompt = "{values["prompt"]}",',
        f'  pointer = "{values["pointer"]}",',
        f'  marker = "{values["marker"]}",',
        f'  spinner = "{values["spinner"]}",',
        f'  header = "{values["header"]}",',
        f'  label = "{values["label"]}",',
        f'  gutter = "{values["gutter"]}",',
        "}",
    ]
    return "\n".join(lines)


def render_statusline_block(values):
    lines = [
        "M.statusline = {",
        f'  normal_bg = "{values["normal_bg"]}",',
        f'  normal_fg = "{values["normal_fg"]}",',
        f'  insert_bg = "{values["insert_bg"]}",',
        f'  insert_fg = "{values["insert_fg"]}",',
        f'  visual_bg = "{values["visual_bg"]}",',
        f'  visual_fg = "{values["visual_fg"]}",',
        f'  replace_bg = "{values["replace_bg"]}",',
        f'  replace_fg = "{values["replace_fg"]}",',
        f'  command_bg = "{values["command_bg"]}",',
        f'  command_fg = "{values["command_fg"]}",',
        f'  terminal_bg = "{values["terminal_bg"]}",',
        f'  terminal_fg = "{values["terminal_fg"]}",',
        f'  section_bg = "{values["section_bg"]}",',
        f'  section_fg = "{values["section_fg"]}",',
        f'  inactive_bg = "{values["inactive_bg"]}",',
        f'  inactive_fg = "{values["inactive_fg"]}",',
        "}",
    ]
    return "\n".join(lines)


def replace_table_block(content, table_name, replacement_block):
    pattern = re.compile(
        rf"(M\.{re.escape(table_name)}\s*=\s*\{{)(.*?)(^\}})",
        re.DOTALL | re.MULTILINE,
    )

    def replace(match):
        return replacement_block

    content, count = pattern.subn(replace, content, count=1)
    if count == 0:
        raise ValueError(f"{table_name} block is missing from colorscheme.lua")
    return content


try:
    fzf = parse_fzf(yaml_file)
    statusline = parse_statusline(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

with open(lua_file, encoding="utf-8") as handle:
    content = handle.read()

content = replace_table_block(content, "fzf", render_fzf_block(fzf))
content = replace_table_block(
    content, "statusline", render_statusline_block(statusline)
)

dir_ = os.path.dirname(os.path.abspath(lua_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, lua_file)
print(f"Updated {lua_file}")
