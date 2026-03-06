#!/usr/bin/env python3

import re


def load_theme_sections(yaml_file, prefix="#", uppercase=False):
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
                else:
                    match = re.match(r'^\s{2}(\w+):\s+"(#[0-9a-fA-F]+)"', line)
                    if match:
                        value = match.group(2).lstrip("#")
                        value = value.upper() if uppercase else value.lower()
                        palette[match.group(1)] = prefix + value

    if not palette:
        raise ValueError("Palette section is required in YAML")

    required = {
        "foreground",
        "red",
        "yellow",
        "green",
        "blue",
        "purple",
        "aqua",
        "orange",
        "statusline_1",
        "statusline_2",
        "statusline_3",
        "grey_0",
        "grey_1",
        "grey_2",
        "background_dim",
        "background_0",
        "background_1",
        "background_2",
        "background_3",
        "background_4",
        "background_5",
        "background_red",
        "background_yellow",
        "background_green",
        "background_blue",
        "background_purple",
        "background_visual",
    }
    missing = sorted(required - set(palette.keys()))
    if missing:
        raise ValueError("Palette is missing required keys: " + ", ".join(missing))

    colors = {
        "foreground": palette["foreground"],
        "background": palette["background_0"],
        "black": palette["background_0"],
        "red": palette["red"],
        "green": palette["green"],
        "yellow": palette["yellow"],
        "blue": palette["blue"],
        "magenta": palette["purple"],
        "cyan": palette["aqua"],
        "white": palette["foreground"],
        "brightBlack": palette["grey_0"],
        "brightRed": palette["red"],
        "brightGreen": palette["green"],
        "brightYellow": palette["yellow"],
        "brightBlue": palette["blue"],
        "brightMagenta": palette["purple"],
        "brightCyan": palette["aqua"],
        "brightWhite": palette["grey_2"],
    }

    return colors, palette


def load_theme(yaml_file, prefix="#", uppercase=False):
    colors, _palette = load_theme_sections(
        yaml_file, prefix=prefix, uppercase=uppercase
    )
    return colors


def derive_editor_palette_with_palette(palette):
    if not palette:
        raise ValueError("Palette section is required in YAML")

    required = {
        "foreground",
        "red",
        "yellow",
        "green",
        "blue",
        "purple",
        "aqua",
        "orange",
        "grey_0",
        "grey_1",
        "grey_2",
        "background_dim",
        "background_0",
        "background_1",
        "background_2",
        "background_3",
        "background_4",
        "background_5",
        "background_red",
        "background_yellow",
        "background_green",
        "background_blue",
        "background_purple",
        "background_visual",
        "statusline_1",
        "statusline_2",
        "statusline_3",
    }
    missing = sorted(required - set(palette.keys()))
    if missing:
        raise ValueError("Palette is missing required keys: " + ", ".join(missing))

    editor = {
        "bg": palette["background_0"],
        "bg_alt": palette["background_1"],
        "bg_sel": palette["background_2"],
        "faint": palette["background_dim"],
        "muted": palette["grey_1"],
        "dim": palette["grey_0"],
        "border": palette["background_4"],
        "fg": palette["foreground"],
        "fg_alt": palette["grey_2"],
        "bright": palette["foreground"],
        "red": palette["red"],
        "orange": palette["orange"],
        "yellow": palette["yellow"],
        "green": palette["green"],
        "cyan": palette["aqua"],
        "blue": palette["blue"],
        "magenta": palette["purple"],
        "background": palette["background_0"],
        "foreground": palette["foreground"],
        "black": palette["background_0"],
        "white": palette["foreground"],
        "purple": palette["purple"],
        "aqua": palette["aqua"],
        "background_dim": palette["background_dim"],
        "background_0": palette["background_0"],
        "background_1": palette["background_1"],
        "background_2": palette["background_2"],
        "background_3": palette["background_3"],
        "background_4": palette["background_4"],
        "background_5": palette["background_5"],
        "background_red": palette["background_red"],
        "background_yellow": palette["background_yellow"],
        "background_green": palette["background_green"],
        "background_blue": palette["background_blue"],
        "background_purple": palette["background_purple"],
        "background_visual": palette["background_visual"],
        "statusline_1": palette["statusline_1"],
        "statusline_2": palette["statusline_2"],
        "statusline_3": palette["statusline_3"],
        "grey_0": palette["grey_0"],
        "grey_1": palette["grey_1"],
        "grey_2": palette["grey_2"],
    }

    return editor


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
