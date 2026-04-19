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

PALETTE_KEYS = {
    "bg_dim",
    "bg0",
    "bg1",
    "bg2",
    "bg3",
    "bg4",
    "bg5",
    "bg_statusline1",
    "bg_statusline2",
    "bg_statusline3",
    "bg_visual",
    "bg_visual_red",
    "bg_visual_yellow",
    "bg_visual_green",
    "bg_visual_blue",
    "bg_visual_purple",
    "bg_diff_red",
    "bg_diff_green",
    "bg_diff_blue",
    "bg_current_word",
    "fg0",
    "fg1",
    "red",
    "orange",
    "yellow",
    "green",
    "aqua",
    "blue",
    "purple",
    "bg_red",
    "bg_green",
    "bg_yellow",
    "grey0",
    "grey1",
    "grey2",
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

DIAGNOSTIC_KEYS = {"error", "warn", "info", "hint", "ok"}

DIFF_KEYS = {
    "add",
    "change",
    "delete",
    "text",
    "add_bg",
    "change_bg",
    "delete_bg",
    "text_bg",
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

FZF_KEYS = {
    "foreground",
    "background",
    "selected_background",
    "muted",
    "match",
    "selected_match",
    "info",
    "marker",
    "prompt",
    "spinner",
    "pointer",
    "border",
    "header",
    "label",
    "query",
    "gutter",
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

                match = re.match(r'^\s{2}([\w_]+):\s+"(#[0-9a-fA-F]{6})"\s*$', line)
                if match:
                    values[match.group(1)] = _normalize_hex(
                        match.group(2), prefix=prefix, uppercase=uppercase
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


def _parse_required_section(yaml_file, section_name, required_keys, prefix="#", uppercase=False):
    values = _parse_section(
        yaml_file, section_name, required_keys, prefix=prefix, uppercase=uppercase
    )
    if values is None:
        raise ValueError(f"{section_name.capitalize()} section is required in YAML")
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
    palette = _parse_required_section(
        yaml_file, "palette", PALETTE_KEYS, prefix=prefix, uppercase=uppercase
    )
    source_ansi = _parse_required_section(
        yaml_file, "ansi", ANSI_KEYS, prefix=prefix, uppercase=uppercase
    )
    ui = _parse_required_section(
        yaml_file, "ui", UI_KEYS, prefix=prefix, uppercase=uppercase
    )
    syntax = _parse_required_section(
        yaml_file, "syntax", SYNTAX_KEYS, prefix=prefix, uppercase=uppercase
    )
    diagnostic = _parse_required_section(
        yaml_file, "diagnostic", DIAGNOSTIC_KEYS, prefix=prefix, uppercase=uppercase
    )
    diff = _parse_required_section(
        yaml_file, "diff", DIFF_KEYS, prefix=prefix, uppercase=uppercase
    )
    tool = _parse_required_section(
        yaml_file, "tool", TOOL_KEYS, prefix=prefix, uppercase=uppercase
    )
    fzf = _parse_required_section(
        yaml_file, "fzf", FZF_KEYS, prefix=prefix, uppercase=uppercase
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
        "palette": palette,
        "ansi": source_ansi,
        "ansi_roles": ansi_roles,
        "ui": ui,
        "syntax": syntax,
        "diagnostic": diagnostic,
        "diff": diff,
        "tool": tool,
        "fzf": fzf,
    }


def load_theme_sections(yaml_file, prefix="#", uppercase=False):
    bundle = load_theme_bundle(yaml_file, prefix=prefix, uppercase=uppercase)
    return bundle["colors"], bundle["ansi"]


def load_theme(yaml_file, prefix="#", uppercase=False):
    colors, _palette = load_theme_sections(
        yaml_file, prefix=prefix, uppercase=uppercase
    )
    return colors


def derive_vim_palette(bundle):
    palette = bundle["palette"]
    diagnostic = bundle["diagnostic"]
    diff = bundle["diff"]

    editor_palette = {
        "bg_dim": palette["bg_dim"],
        "bg0": palette["bg0"],
        "bg1": palette["bg1"],
        "bg2": palette["bg2"],
        "bg3": palette["bg3"],
        "bg4": palette["bg4"],
        "bg5": palette["bg5"],
        "bg_statusline1": palette["bg_statusline1"],
        "bg_statusline2": palette["bg_statusline2"],
        "bg_statusline3": palette["bg_statusline3"],
        "bg_visual": palette["bg_visual"],
        "bg_visual_red": palette["bg_visual_red"],
        "bg_visual_yellow": palette["bg_visual_yellow"],
        "bg_visual_green": palette["bg_visual_green"],
        "bg_visual_blue": palette["bg_visual_blue"],
        "bg_visual_purple": palette["bg_visual_purple"],
        "bg_diff_red": diff["delete_bg"],
        "bg_diff_green": diff["add_bg"],
        "bg_diff_blue": diff["change_bg"],
        "bg_current_word": palette["bg_current_word"],
        "fg0": palette["fg0"],
        "fg1": palette["fg1"],
        "grey0": palette["grey0"],
        "grey1": palette["grey1"],
        "grey2": palette["grey2"],
        "red": diagnostic["error"],
        "orange": palette["orange"],
        "yellow": diagnostic["warn"],
        "green": diagnostic["ok"],
        "aqua": palette["aqua"],
        "blue": diagnostic["info"],
        "purple": diagnostic["hint"],
    }
    return editor_palette
