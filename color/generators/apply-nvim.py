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
    "cur_search_bg",
    "cur_search_fg",
    "directory_fg",
    "end_of_buffer_fg",
    "error_fg",
    "float_bg",
    "float_border_fg",
    "float_fg",
    "float_title_fg",
    "folded_bg",
    "folded_fg",
    "fg",
    "inc_search_bg",
    "inc_search_fg",
    "line_nr",
    "matchparen_bg",
    "mode_fg",
    "non_text",
    "more_fg",
    "msg_area_fg",
    "msg_separator_fg",
    "pmenu_bg",
    "pmenu_fg",
    "pmenu_sel_bg",
    "pmenu_sel_fg",
    "pmenu_sbar_bg",
    "pmenu_thumb_bg",
    "question_fg",
    "quickfix_line_bg",
    "search_bg",
    "search_fg",
    "selection_bg",
    "selection_fg",
    "split_fg",
    "statusline_bg",
    "statusline_fg",
    "statusline_nc_bg",
    "statusline_nc_fg",
    "special_key",
    "tabline_bg",
    "tabline_fill_bg",
    "tabline_fg",
    "tabline_sel_bg",
    "tabline_sel_fg",
    "title_fg",
    "warning_fg",
    "winbar_bg",
    "winbar_fg",
    "winbar_nc_bg",
    "winbar_nc_fg",
    "whitespace",
}

REQUIRED_SYNTAX_KEYS = {
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

GIT_KEYS = {
    "add",
    "change",
    "delete",
    "rename",
    "ignored",
    "blame",
}

DIAGNOSTIC_KEYS = {
    "error",
    "warn",
    "info",
    "hint",
    "ok",
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

    missing = sorted(REQUIRED_SYNTAX_KEYS - set(values.keys()))
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


def parse_git(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "git:":
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
        raise ValueError("Git section is required in YAML")

    missing = sorted(GIT_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Git is missing required keys: " + ", ".join(missing))

    return values


def parse_diagnostic(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "diagnostic:":
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
        raise ValueError("Diagnostic section is required in YAML")

    missing = sorted(DIAGNOSTIC_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Diagnostic is missing required keys: " + ", ".join(missing))

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
        f'  cur_search_bg = "{values["cur_search_bg"]}",',
        f'  cur_search_fg = "{values["cur_search_fg"]}",',
        f'  directory_fg = "{values["directory_fg"]}",',
        f'  end_of_buffer_fg = "{values["end_of_buffer_fg"]}",',
        f'  error_fg = "{values["error_fg"]}",',
        f'  float_bg = "{values["float_bg"]}",',
        f'  float_border_fg = "{values["float_border_fg"]}",',
        f'  float_fg = "{values["float_fg"]}",',
        f'  float_title_fg = "{values["float_title_fg"]}",',
        f'  folded_bg = "{values["folded_bg"]}",',
        f'  folded_fg = "{values["folded_fg"]}",',
        f'  fg = "{values["fg"]}",',
        f'  inc_search_bg = "{values["inc_search_bg"]}",',
        f'  inc_search_fg = "{values["inc_search_fg"]}",',
        f'  line_nr = "{values["line_nr"]}",',
        f'  matchparen_bg = "{values["matchparen_bg"]}",',
        f'  mode_fg = "{values["mode_fg"]}",',
        f'  non_text = "{values["non_text"]}",',
        f'  more_fg = "{values["more_fg"]}",',
        f'  msg_area_fg = "{values["msg_area_fg"]}",',
        f'  msg_separator_fg = "{values["msg_separator_fg"]}",',
        f'  pmenu_bg = "{values["pmenu_bg"]}",',
        f'  pmenu_fg = "{values["pmenu_fg"]}",',
        f'  pmenu_sel_bg = "{values["pmenu_sel_bg"]}",',
        f'  pmenu_sel_fg = "{values["pmenu_sel_fg"]}",',
        f'  pmenu_sbar_bg = "{values["pmenu_sbar_bg"]}",',
        f'  pmenu_thumb_bg = "{values["pmenu_thumb_bg"]}",',
        f'  question_fg = "{values["question_fg"]}",',
        f'  quickfix_line_bg = "{values["quickfix_line_bg"]}",',
        f'  search_bg = "{values["search_bg"]}",',
        f'  search_fg = "{values["search_fg"]}",',
        f'  selection_bg = "{values["selection_bg"]}",',
        f'  selection_fg = "{values["selection_fg"]}",',
        f'  split_fg = "{values["split_fg"]}",',
        f'  statusline_bg = "{values["statusline_bg"]}",',
        f'  statusline_fg = "{values["statusline_fg"]}",',
        f'  statusline_nc_bg = "{values["statusline_nc_bg"]}",',
        f'  statusline_nc_fg = "{values["statusline_nc_fg"]}",',
        f'  special_key = "{values["special_key"]}",',
        f'  tabline_bg = "{values["tabline_bg"]}",',
        f'  tabline_fill_bg = "{values["tabline_fill_bg"]}",',
        f'  tabline_fg = "{values["tabline_fg"]}",',
        f'  tabline_sel_bg = "{values["tabline_sel_bg"]}",',
        f'  tabline_sel_fg = "{values["tabline_sel_fg"]}",',
        f'  title_fg = "{values["title_fg"]}",',
        f'  warning_fg = "{values["warning_fg"]}",',
        f'  winbar_bg = "{values["winbar_bg"]}",',
        f'  winbar_fg = "{values["winbar_fg"]}",',
        f'  winbar_nc_bg = "{values["winbar_nc_bg"]}",',
        f'  winbar_nc_fg = "{values["winbar_nc_fg"]}",',
        f'  whitespace = "{values["whitespace"]}",',
        "}",
    ]
    return "\n".join(lines)


def render_syntax_block(values):
    syntax_keys = [
        "comment",
        "constant",
        "constant_builtin",
        "constant_macro",
        "error",
        "delimiter",
        "character",
        "character_special",
        "float",
        "variable_builtin",
        "variable_parameter",
        "variable_parameter_builtin",
        "variable_member",
        "identifier",
        "namespace",
        "namespace_builtin",
        "field",
        "field_builtin",
        "parameter",
        "parameter_builtin",
        "boolean",
        "module",
        "module_builtin",
        "label",
        "statement",
        "conditional",
        "repeat",
        "exception",
        "attribute",
        "attribute_builtin",
        "property",
        "constructor",
        "include",
        "define",
        "macro",
        "precondit",
        "text",
        "text_strong",
        "text_emphasis",
        "text_strike",
        "text_underline",
        "text_title",
        "text_literal",
        "text_quote",
        "text_uri",
        "text_math",
        "text_todo",
        "text_note",
        "text_warning",
        "text_reference",
        "function",
        "function_builtin",
        "function_call",
        "function_macro",
        "function_method",
        "function_method_call",
        "keyword",
        "keyword_coroutine",
        "keyword_function",
        "keyword_operator",
        "keyword_import",
        "keyword_type",
        "keyword_modifier",
        "keyword_repeat",
        "keyword_return",
        "keyword_debug",
        "keyword_exception",
        "keyword_conditional",
        "keyword_conditional_ternary",
        "keyword_directive",
        "keyword_directive_define",
        "number",
        "number_float",
        "operator",
        "preproc",
        "storageclass",
        "structure",
        "typedef",
        "punctuation_delimiter",
        "punctuation_bracket",
        "punctuation_special",
        "special",
        "comment_special",
        "debug",
        "underlined",
        "todo",
        "string",
        "string_documentation",
        "string_regexp",
        "string_escape",
        "string_special",
        "string_special_symbol",
        "string_special_path",
        "string_special_url",
        "type",
        "type_builtin",
        "type_definition",
        "variable",
        "comment_documentation",
        "comment_error",
        "comment_warning",
        "comment_todo",
        "comment_note",
        "markup_strong",
        "markup_italic",
        "markup_strikethrough",
        "markup_underline",
        "markup_heading",
        "markup_heading_1",
        "markup_heading_2",
        "markup_heading_3",
        "markup_heading_4",
        "markup_heading_5",
        "markup_heading_6",
        "markup_quote",
        "markup_math",
        "markup_link",
        "markup_link_label",
        "markup_link_url",
        "markup_raw",
        "markup_raw_block",
        "markup_list",
        "markup_list_checked",
        "markup_list_unchecked",
        "diff_plus",
        "diff_minus",
        "diff_delta",
        "tag",
        "tag_builtin",
        "tag_attribute",
        "tag_delimiter",
    ]
    lines = [
        "M.syntax = {",
    ]
    for key in syntax_keys:
        if key in values:
            rendered_key = f'["{key}"]' if key in {"function", "repeat"} else key
            lines.append(f'  {rendered_key} = "{values[key]}",')
    lines.extend([
        "}",
    ])
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


def render_git_block(values):
    lines = [
        "M.git = {",
        f'  add = "{values["add"]}",',
        f'  change = "{values["change"]}",',
        f'  delete = "{values["delete"]}",',
        f'  rename = "{values["rename"]}",',
        f'  ignored = "{values["ignored"]}",',
        f'  blame = "{values["blame"]}",',
        "}",
    ]
    return "\n".join(lines)


def render_diagnostic_block(values):
    lines = [
        "M.diagnostic = {",
        f'  error = "{values["error"]}",',
        f'  warn = "{values["warn"]}",',
        f'  info = "{values["info"]}",',
        f'  hint = "{values["hint"]}",',
        f'  ok = "{values["ok"]}",',
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
    git = parse_git(yaml_file)
    diagnostic = parse_diagnostic(yaml_file)
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
content = replace_table_block(content, "git", render_git_block(git))
content = replace_table_block(content, "diagnostic", render_diagnostic_block(diagnostic))

dir_ = os.path.dirname(os.path.abspath(lua_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write(content)
os.replace(tmp_path, lua_file)
print(f"Updated {lua_file}")
