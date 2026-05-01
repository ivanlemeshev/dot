#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <theme.lua>", file=sys.stderr)
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

UI_KEYS = {
    "bg",
    "color_column",
    "cursor",
    "cursor_line",
    "cursor_line_nr",
    "cursor_column",
    "fg",
    "line_nr",
    "non_text",
    "special_key",
    "whitespace",
}

SYNTAX_KEYS = {
    "builtin",
    "comment",
    "constant",
    "delimiter",
    "character",
    "function",
    "keyword",
    "number",
    "operator",
    "preproc",
    "property",
    "special",
    "special_char",
    "string",
    "type",
    "variable",
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


def parse_ui(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "ui:":
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
        raise ValueError("UI section is required in YAML")

    missing = sorted(UI_KEYS - set(values.keys()))
    if missing:
        raise ValueError("UI is missing required keys: " + ", ".join(missing))

    return values


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


def parse_syntax(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "syntax:":
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
        raise ValueError("Syntax section is required in YAML")

    missing = sorted(SYNTAX_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Syntax is missing required keys: " + ", ".join(missing))

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


def render_ui_block(values):
    lines = [
        "M.ui = {",
        f'  bg = "{values["bg"]}",',
        f'  color_column = "{values["color_column"]}",',
        f'  cursor = "{values["cursor"]}",',
        f'  cursor_column = "{values["cursor_column"]}",',
        f'  cursor_line = "{values["cursor_line"]}",',
        f'  cursor_line_nr = "{values["cursor_line_nr"]}",',
        f'  fg = "{values["fg"]}",',
        f'  line_nr = "{values["line_nr"]}",',
        f'  non_text = "{values["non_text"]}",',
        f'  special_key = "{values["special_key"]}",',
        f'  whitespace = "{values["whitespace"]}",',
        "}",
    ]
    return "\n".join(lines)


def render_syntax_block(values):
    lines = [
        "M.syntax = {",
        f'  builtin = "{values["builtin"]}",',
        f'  comment = "{values["comment"]}",',
        f'  constant = "{values["constant"]}",',
        f'  delimiter = "{values["delimiter"]}",',
        f'  character = "{values["character"]}",',
        f'  ["function"] = "{values["function"]}",',
        f'  keyword = "{values["keyword"]}",',
        f'  number = "{values["number"]}",',
        f'  operator = "{values["operator"]}",',
        f'  preproc = "{values["preproc"]}",',
        f'  property = "{values["property"]}",',
        f'  special = "{values["special"]}",',
        f'  special_char = "{values["special_char"]}",',
        f'  string = "{values["string"]}",',
        f'  type = "{values["type"]}",',
        f'  variable = "{values["variable"]}",',
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
        raise ValueError(f"{table_name} block is missing from theme.lua")
    return content


try:
    ui = parse_ui(yaml_file)
    syntax = parse_syntax(yaml_file)
    fzf = parse_fzf(yaml_file)
    statusline = parse_statusline(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

with open(lua_file, encoding="utf-8") as handle:
    content = handle.read()

content = replace_table_block(content, "ui", render_ui_block(ui))
content = replace_table_block(content, "syntax", render_syntax_block(syntax))
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
