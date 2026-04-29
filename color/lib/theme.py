#!/usr/bin/env python3

import re

ANSI_KEYS = {
    "bg",
    "fg",
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "bright_black",
    "bright_red",
    "bright_green",
    "bright_yellow",
    "bright_blue",
    "bright_magenta",
    "bright_cyan",
    "bright_white",
}

UI_KEYS = {
    "bg",
    "bg_alt",
    "bg_dim",
    "fg",
    "fg_alt",
    "fg_dim",
    "muted",
    "border",
    "border_active",
    "selection",
    "visual",
    "cursorline",
    "search_bg",
    "search_fg",
    "inc_search_bg",
    "inc_search_fg",
    "popup_bg",
    "popup_sel",
    "status_bg",
    "status_fg",
    "status_inactive_fg",
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

SEMANTIC_KEYS = {
    "text",
    "muted",
    "error",
    "warning",
    "info",
    "hint",
    "success",
    "prompt",
    "operator",
    "type",
    "function",
    "constant",
    "variable",
    "number",
    "directory",
    "symlink",
    "executable",
    "special",
    "special_char",
    "title",
    "added",
    "added_bg",
    "changed",
    "changed_bg",
    "removed",
    "removed_bg",
    "diff_text",
    "diff_text_bg",
    "border",
    "border_active",
    "surface",
    "surface_alt",
    "selection",
    "current_word",
    "status_bg",
    "status_fg",
    "status_inactive_fg",
    "search_bg",
    "search_fg",
    "inc_search_bg",
    "inc_search_fg",
    "popup_bg",
    "popup_sel",
}

SYNTAX_KEYS = {
    "comment",
    "string",
    "escape",
    "number",
    "constant",
    "keyword",
    "operator",
    "type",
    "function",
    "variable",
    "property",
    "builtin",
    "preproc",
    "special",
    "delimiter",
}

TOOL_KEYS = {
    "prompt",
    "prompt_alt",
    "path",
    "root",
    "duration",
    "git_clean",
    "git_dirty",
    "git_ahead",
    "git_behind",
    "directory",
    "executable",
    "symlink",
    "archive",
    "media",
    "document",
    "backup",
}

OMP_KEYS = {
    "foreground",
    "time",
    "user",
    "host",
    "root",
    "git_clean",
    "git_dirty",
    "git_ahead",
    "git_behind",
    "duration",
    "status_ok",
    "status_error",
    "prompt",
}

LS_COLORS_KEYS = {
    "foreground",
    "background",
    "error",
    "executable",
    "document",
    "directory",
    "special",
    "media",
    "backup",
}

TMUX_KEYS = {
    "bar_bg",
    "bar_fg",
    "block_bg",
    "block_fg",
    "alert_bg",
    "alert_fg",
    "bell_bg",
    "bell_fg",
    "border_fg",
    "border_active_fg",
    "message_bg",
    "message_fg",
    "mode_bg",
    "mode_fg",
}

FZF_KEYS = {
    "fg",
    "bg",
    "hl",
    "fg+",
    "bg+",
    "hl+",
    "info",
    "border",
    "gutter",
    "query",
    "prompt",
    "pointer",
    "marker",
    "spinner",
    "header",
    "label",
}

FISH_KEYS = {
    "background",
    "background_alt",
    "foreground",
    "foreground_alt",
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


def _normalize_hex(value, prefix="#", uppercase=False):
    hex_value = value.lstrip("#")
    hex_value = hex_value.upper() if uppercase else hex_value.lower()
    return prefix + hex_value


def _parse_section(yaml_file, section_name, required_keys, prefix="#", uppercase=False):
    values = {}
    active_section = None

    with open(yaml_file, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()

            if stripped == f"{section_name}:":
                active_section = section_name
                continue

            if active_section:
                if line and not line.startswith("  "):
                    active_section = None
                    continue

                match = re.match(
                    r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$',
                    line,
                )
                if match:
                    key = match.group(1) or match.group(2)
                    values[key] = _normalize_hex(
                        match.group(3), prefix=prefix, uppercase=uppercase
                    )

    if not values:
        return None

    missing = sorted(required_keys - set(values.keys()))
    if missing:
        raise ValueError(
            f"{section_name.capitalize()} is missing required keys: "
            + ", ".join(missing)
        )

    return values


def _parse_ansi(yaml_file, prefix="#", uppercase=False):
    return _parse_section(
        yaml_file, "ansi", ANSI_KEYS, prefix=prefix, uppercase=uppercase
    )


def _parse_required_section(
    yaml_file, section_name, required_keys, prefix="#", uppercase=False
):
    values = _parse_section(
        yaml_file, section_name, required_keys, prefix=prefix, uppercase=uppercase
    )
    if values is None:
        section_label = section_name.replace("_", " ").title()
        raise ValueError(f"{section_label} section is required in YAML")
    return values


def derive_ansi_roles(source_ansi):
    if not source_ansi:
        raise ValueError("Ansi section is required in YAML")

    missing = sorted(ANSI_KEYS - set(source_ansi.keys()))
    if missing:
        raise ValueError("Ansi is missing required keys: " + ", ".join(missing))

    return {
        **source_ansi,
        "background": source_ansi["bg"],
        "foreground": source_ansi["fg"],
        "brightBlack": source_ansi["bright_black"],
        "brightRed": source_ansi["bright_red"],
        "brightGreen": source_ansi["bright_green"],
        "brightYellow": source_ansi["bright_yellow"],
        "brightBlue": source_ansi["bright_blue"],
        "brightMagenta": source_ansi["bright_magenta"],
        "brightCyan": source_ansi["bright_cyan"],
        "brightWhite": source_ansi["bright_white"],
    }


def load_theme_bundle(yaml_file, prefix="#", uppercase=False):
    source_ansi = _parse_required_section(
        yaml_file, "ansi", ANSI_KEYS, prefix=prefix, uppercase=uppercase
    )
    ui = _parse_required_section(
        yaml_file, "ui", UI_KEYS, prefix=prefix, uppercase=uppercase
    )
    statusline = _parse_required_section(
        yaml_file, "statusline", STATUSLINE_KEYS, prefix=prefix, uppercase=uppercase
    )
    semantic = _parse_required_section(
        yaml_file, "semantic", SEMANTIC_KEYS, prefix=prefix, uppercase=uppercase
    )
    syntax = _parse_required_section(
        yaml_file, "syntax", SYNTAX_KEYS, prefix=prefix, uppercase=uppercase
    )
    tool = _parse_required_section(
        yaml_file, "tool", TOOL_KEYS, prefix=prefix, uppercase=uppercase
    )
    omp = _parse_required_section(
        yaml_file, "omp", OMP_KEYS, prefix=prefix, uppercase=uppercase
    )
    terminal = _parse_required_section(
        yaml_file, "terminal", TERMINAL_KEYS, prefix=prefix, uppercase=uppercase
    )
    ls_colors = _parse_required_section(
        yaml_file,
        "ls_colors",
        LS_COLORS_KEYS,
        prefix=prefix,
        uppercase=uppercase,
    )
    tmux = _parse_required_section(
        yaml_file, "tmux", TMUX_KEYS, prefix=prefix, uppercase=uppercase
    )
    fzf = _parse_required_section(
        yaml_file, "fzf", FZF_KEYS, prefix=prefix, uppercase=uppercase
    )
    fish = _parse_required_section(
        yaml_file, "fish", FISH_KEYS, prefix=prefix, uppercase=uppercase
    )

    ansi_roles = derive_ansi_roles(source_ansi)

    colors = {
        "foreground": ansi_roles["foreground"],
        "background": ansi_roles["background"],
        "black": ansi_roles["black"],
        "red": ansi_roles["red"],
        "green": ansi_roles["green"],
        "yellow": ansi_roles["yellow"],
        "blue": ansi_roles["blue"],
        "magenta": ansi_roles["magenta"],
        "cyan": ansi_roles["cyan"],
        "white": ansi_roles["white"],
        "brightBlack": ansi_roles["brightBlack"],
        "brightRed": ansi_roles["brightRed"],
        "brightGreen": ansi_roles["brightGreen"],
        "brightYellow": ansi_roles["brightYellow"],
        "brightBlue": ansi_roles["brightBlue"],
        "brightMagenta": ansi_roles["brightMagenta"],
        "brightCyan": ansi_roles["brightCyan"],
        "brightWhite": ansi_roles["brightWhite"],
    }

    return {
        "colors": colors,
        "ansi": source_ansi,
        "ansi_roles": ansi_roles,
        "ui": ui,
        "statusline": statusline,
        "semantic": semantic,
        "syntax": syntax,
        "tool": tool,
        "omp": omp,
        "terminal": terminal,
        "ls_colors": ls_colors,
        "tmux": tmux,
        "fzf": fzf,
        "fish": fish,
    }


def load_theme_sections(yaml_file, prefix="#", uppercase=False):
    bundle = load_theme_bundle(yaml_file, prefix=prefix, uppercase=uppercase)
    return bundle["colors"], bundle["ansi"]


def load_theme(yaml_file, prefix="#", uppercase=False):
    colors, _palette = load_theme_sections(
        yaml_file, prefix=prefix, uppercase=uppercase
    )
    return colors


def derive_vim_semantic_vars(bundle):
    ui = bundle["ui"]
    statusline = bundle["statusline"]
    semantic = bundle["semantic"]
    syntax = bundle["syntax"]
    tool = bundle["tool"]
    terminal = bundle["terminal"]

    return {
        "ui_bg_dim": ui["bg_dim"],
        "ui_bg": ui["bg"],
        "ui_bg_alt": ui["bg_alt"],
        "ui_fg": ui["fg"],
        "ui_fg_alt": ui["fg_alt"],
        "ui_fg_dim": ui["fg_dim"],
        "ui_muted": ui["muted"],
        "ui_border": ui["border"],
        "ui_border_active": ui["border_active"],
        "ui_selection": ui["selection"],
        "ui_visual": ui["visual"],
        "ui_cursorline": ui["cursorline"],
        "ui_search_bg": ui["search_bg"],
        "ui_search_fg": ui["search_fg"],
        "ui_inc_search_bg": ui["inc_search_bg"],
        "ui_inc_search_fg": ui["inc_search_fg"],
        "ui_popup_bg": ui["popup_bg"],
        "ui_popup_sel": ui["popup_sel"],
        "ui_status_bg": ui["status_bg"],
        "ui_status_fg": ui["status_fg"],
        "ui_status_inactive_fg": ui["status_inactive_fg"],
        "statusline_normal_bg": statusline["normal_bg"],
        "statusline_normal_fg": statusline["normal_fg"],
        "statusline_insert_bg": statusline["insert_bg"],
        "statusline_insert_fg": statusline["insert_fg"],
        "statusline_visual_bg": statusline["visual_bg"],
        "statusline_visual_fg": statusline["visual_fg"],
        "statusline_replace_bg": statusline["replace_bg"],
        "statusline_replace_fg": statusline["replace_fg"],
        "statusline_command_bg": statusline["command_bg"],
        "statusline_command_fg": statusline["command_fg"],
        "statusline_terminal_bg": statusline["terminal_bg"],
        "statusline_terminal_fg": statusline["terminal_fg"],
        "statusline_section_bg": statusline["section_bg"],
        "statusline_section_fg": statusline["section_fg"],
        "statusline_inactive_bg": statusline["inactive_bg"],
        "statusline_inactive_fg": statusline["inactive_fg"],
        "semantic_text": semantic["text"],
        "semantic_muted": semantic["muted"],
        "semantic_error": semantic["error"],
        "semantic_warning": semantic["warning"],
        "semantic_info": semantic["info"],
        "semantic_hint": semantic["hint"],
        "semantic_success": semantic["success"],
        "semantic_prompt": semantic["prompt"],
        "semantic_operator": semantic["operator"],
        "semantic_type": semantic["type"],
        "semantic_function": semantic["function"],
        "semantic_constant": semantic["constant"],
        "semantic_variable": semantic["variable"],
        "semantic_number": semantic["number"],
        "semantic_directory": semantic["directory"],
        "semantic_symlink": semantic["symlink"],
        "semantic_executable": semantic["executable"],
        "semantic_special": semantic["special"],
        "semantic_special_char": semantic["special_char"],
        "semantic_title": semantic["title"],
        "semantic_added": semantic["added"],
        "semantic_added_bg": semantic["added_bg"],
        "semantic_changed": semantic["changed"],
        "semantic_changed_bg": semantic["changed_bg"],
        "semantic_removed": semantic["removed"],
        "semantic_removed_bg": semantic["removed_bg"],
        "semantic_diff_text": semantic["diff_text"],
        "semantic_diff_text_bg": semantic["diff_text_bg"],
        "semantic_border": semantic["border"],
        "semantic_border_active": semantic["border_active"],
        "semantic_surface": semantic["surface"],
        "semantic_surface_alt": semantic["surface_alt"],
        "semantic_selection": semantic["selection"],
        "semantic_current_word": semantic["current_word"],
        "semantic_status_bg": semantic["status_bg"],
        "semantic_status_fg": semantic["status_fg"],
        "semantic_status_inactive_fg": semantic["status_inactive_fg"],
        "semantic_search_bg": semantic["search_bg"],
        "semantic_search_fg": semantic["search_fg"],
        "semantic_inc_search_bg": semantic["inc_search_bg"],
        "semantic_inc_search_fg": semantic["inc_search_fg"],
        "semantic_popup_bg": semantic["popup_bg"],
        "semantic_popup_sel": semantic["popup_sel"],
        "syntax_comment": syntax["comment"],
        "syntax_string": syntax["string"],
        "syntax_escape": syntax["escape"],
        "syntax_number": syntax["number"],
        "syntax_constant": syntax["constant"],
        "syntax_keyword": syntax["keyword"],
        "syntax_operator": syntax["operator"],
        "syntax_type": syntax["type"],
        "syntax_function": syntax["function"],
        "syntax_variable": syntax["variable"],
        "syntax_property": syntax["property"],
        "syntax_builtin": syntax["builtin"],
        "syntax_preproc": syntax["preproc"],
        "syntax_special": syntax["special"],
        "syntax_delimiter": syntax["delimiter"],
        "diagnostic_error": semantic["error"],
        "diagnostic_warn": semantic["warning"],
        "diagnostic_info": semantic["info"],
        "diagnostic_hint": semantic["hint"],
        "diagnostic_ok": semantic["success"],
        "diff_add": semantic["added"],
        "diff_change": semantic["changed"],
        "diff_delete": semantic["removed"],
        "diff_text": semantic["diff_text"],
        "diff_add_bg": semantic["added_bg"],
        "diff_change_bg": semantic["changed_bg"],
        "diff_delete_bg": semantic["removed_bg"],
        "diff_text_bg": semantic["diff_text_bg"],
        "tool_prompt": tool["prompt"],
        "tool_prompt_alt": tool["prompt_alt"],
        "tool_path": tool["path"],
        "tool_root": tool["root"],
        "tool_duration": tool["duration"],
        "tool_git_clean": tool["git_clean"],
        "tool_git_dirty": tool["git_dirty"],
        "tool_git_ahead": tool["git_ahead"],
        "tool_git_behind": tool["git_behind"],
        "tool_directory": tool["directory"],
        "tool_executable": tool["executable"],
        "tool_symlink": tool["symlink"],
        "tool_archive": tool["archive"],
        "tool_media": tool["media"],
        "tool_document": tool["document"],
        "tool_backup": tool["backup"],
        "terminal_background": terminal["background"],
        "terminal_foreground": terminal["foreground"],
        "terminal_selection": terminal["selection"],
        "terminal_tab_background": terminal["tab_background"],
        "terminal_tab_unfocused_background": terminal["tab_unfocused_background"],
    }
