#!/usr/bin/env python3

import re

SOURCE_KEYS = {
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


def _normalize_hex(value, prefix="#", uppercase=False):
    hex_value = value.lstrip("#")
    hex_value = hex_value.upper() if uppercase else hex_value.lower()
    return prefix + hex_value


def _parse_palette(yaml_file, prefix="#", uppercase=False):
    palette = {}
    active_section = None

    with open(yaml_file, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()

            if stripped == "palette:":
                active_section = "palette"
                continue

            if active_section:
                if line and not line.startswith("  "):
                    active_section = None
                    continue

                match = re.match(r'^\s{2}([\w_]+):\s+"(#[0-9a-fA-F]{6})"\s*$', line)
                if match:
                    palette[match.group(1)] = _normalize_hex(
                        match.group(2), prefix=prefix, uppercase=uppercase
                    )

    if not palette:
        raise ValueError("Palette section is required in YAML")

    missing = sorted(SOURCE_KEYS - set(palette.keys()))
    if missing:
        raise ValueError("Palette is missing required keys: " + ", ".join(missing))

    return palette


def derive_palette_roles(source_palette):
    if not source_palette:
        raise ValueError("Palette section is required in YAML")

    missing = sorted(SOURCE_KEYS - set(source_palette.keys()))
    if missing:
        raise ValueError("Palette is missing required keys: " + ", ".join(missing))

    return {
        **source_palette,
        "background": source_palette["bg"],
        "foreground": source_palette["fg"],
        "brightBlack": source_palette["bright_black"],
        "brightRed": source_palette["bright_red"],
        "brightGreen": source_palette["bright_green"],
        "brightYellow": source_palette["bright_yellow"],
        "brightBlue": source_palette["bright_blue"],
        "brightMagenta": source_palette["bright_magenta"],
        "brightCyan": source_palette["bright_cyan"],
        "brightWhite": source_palette["bright_white"],
    }


def load_theme_sections(yaml_file, prefix="#", uppercase=False):
    source_palette = _parse_palette(yaml_file, prefix=prefix, uppercase=uppercase)
    palette = derive_palette_roles(source_palette)

    colors = {
        "foreground": palette["foreground"],
        "background": palette["background"],
        "black": palette["black"],
        "red": palette["red"],
        "green": palette["green"],
        "yellow": palette["yellow"],
        "blue": palette["blue"],
        "magenta": palette["magenta"],
        "cyan": palette["cyan"],
        "white": palette["white"],
        "brightBlack": palette["brightBlack"],
        "brightRed": palette["brightRed"],
        "brightGreen": palette["brightGreen"],
        "brightYellow": palette["brightYellow"],
        "brightBlue": palette["brightBlue"],
        "brightMagenta": palette["brightMagenta"],
        "brightCyan": palette["brightCyan"],
        "brightWhite": palette["brightWhite"],
    }

    return colors, palette


def load_theme(yaml_file, prefix="#", uppercase=False):
    colors, _palette = load_theme_sections(
        yaml_file, prefix=prefix, uppercase=uppercase
    )
    return colors


def derive_editor_palette_with_palette(palette):
    required = {"background", "foreground"} | SOURCE_KEYS | {
        "brightBlack",
        "brightWhite",
        "brightCyan",
        "brightMagenta",
    }
    missing = sorted(required - set(palette.keys()))
    if missing:
        raise ValueError("Palette is missing required keys: " + ", ".join(missing))

    return {
        "bg": palette["bg"],
        "bg_alt": palette["black"],
        "bg_sel": palette["white"],
        "faint": palette["black"],
        "muted": palette["brightBlack"],
        "dim": palette["brightBlack"],
        "border": palette["brightBlack"],
        "fg": palette["fg"],
        "fg_alt": palette["white"],
        "bright": palette["brightWhite"],
        "red": palette["red"],
        "orange": palette["brightMagenta"],
        "yellow": palette["yellow"],
        "green": palette["green"],
        "cyan": palette["cyan"],
        "blue": palette["blue"],
        "magenta": palette["magenta"],
        "background": palette["background"],
        "foreground": palette["foreground"],
        "black": palette["black"],
        "white": palette["white"],
        "background_red": palette["red"],
        "background_yellow": palette["yellow"],
        "background_green": palette["green"],
        "background_blue": palette["blue"],
        "background_purple": palette["magenta"],
        "background_visual": palette["white"],
        "background_3": palette["black"],
        "background_5": palette["brightBlack"],
    }


def editor_palette_to_vim(editor):
    required = {
        "bg",
        "bg_alt",
        "bg_sel",
        "faint",
        "muted",
        "dim",
        "border",
        "fg",
        "fg_alt",
        "bright",
        "red",
        "orange",
        "yellow",
        "green",
        "cyan",
        "blue",
        "magenta",
        "background_red",
        "background_yellow",
        "background_green",
        "background_blue",
        "background_purple",
        "background_visual",
        "background_3",
        "background_5",
    }
    missing = sorted(required - set(editor.keys()))
    if missing:
        raise ValueError(
            "Editor palette is missing required keys: " + ", ".join(missing)
        )

    return {
        "gui00": editor["bg"],
        "gui01": editor["bg_alt"],
        "gui02": editor["bg_sel"],
        "gui03": editor["muted"],
        "gui04": editor["dim"],
        "gui05": editor["fg"],
        "gui06": editor["fg_alt"],
        "gui07": editor["bright"],
        "gui08": editor["red"],
        "gui09": editor["orange"],
        "gui0A": editor["yellow"],
        "gui0B": editor["green"],
        "gui0C": editor["cyan"],
        "gui0D": editor["blue"],
        "gui0E": editor["magenta"],
        "gui0F": editor["background_red"],
        "gui_faint": editor["faint"],
        "gui_border": editor["border"],
        "gui_bg_red": editor["background_red"],
        "gui_bg_yellow": editor["background_yellow"],
        "gui_bg_green": editor["background_green"],
        "gui_bg_blue": editor["background_blue"],
        "gui_bg_purple": editor["background_purple"],
        "gui_bg_visual": editor["background_visual"],
        "gui_bg3": editor["background_3"],
        "gui_bg5": editor["background_5"],
    }


def derive_vim_palette_with_palette(palette):
    return editor_palette_to_vim(derive_editor_palette_with_palette(palette))
