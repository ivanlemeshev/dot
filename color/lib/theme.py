#!/usr/bin/env python3

import re


def hex_to_rgb(hex_value):
    value = hex_value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


def rgb_to_hex(r, g, b, prefix="", uppercase=False):
    fmt = "{:02X}" if uppercase else "{:02x}"
    return prefix + "".join(fmt.format(int(round(channel))) for channel in (r, g, b))


def lighten(hex_value, amount, prefix="", uppercase=False):
    r, g, b = hex_to_rgb(hex_value)
    return rgb_to_hex(
        min(255, r + amount),
        min(255, g + amount),
        min(255, b + amount),
        prefix=prefix,
        uppercase=uppercase,
    )


def blend(hex_left, hex_right, ratio, prefix="", uppercase=False):
    r1, g1, b1 = hex_to_rgb(hex_left)
    r2, g2, b2 = hex_to_rgb(hex_right)
    return rgb_to_hex(
        r1 + ratio * (r2 - r1),
        g1 + ratio * (g2 - g1),
        b1 + ratio * (b2 - b1),
        prefix=prefix,
        uppercase=uppercase,
    )


def load_theme(yaml_file, prefix="#", uppercase=False):
    colors = {}
    in_colors = False

    with open(yaml_file, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()

            if stripped == "colors:":
                in_colors = True
                continue

            if in_colors:
                if line and not line.startswith("  "):
                    in_colors = False
                else:
                    match = re.match(r'^\s{2}(\w+):\s+"(#[0-9a-fA-F]+)"', line)
                    if match:
                        value = match.group(2).lstrip("#")
                        value = value.upper() if uppercase else value.lower()
                        colors[match.group(1)] = prefix + value

    if not colors:
        raise ValueError("No colors section found in YAML")

    return colors


def derive_editor_palette(colors):
    bg = colors["background"]
    fg = colors["foreground"]
    bright_black = colors["brightBlack"]
    bright_white = colors["brightWhite"]
    red = colors["red"]
    yellow = colors["yellow"]

    return {
        "bg": bg,
        "bg_alt": lighten(bg, 0x10),
        "bg_sel": lighten(bg, 0x20),
        "faint": lighten(bg, 20),
        "muted": blend(bg, fg, 0.47),
        "dim": blend(bg, fg, 0.55),
        "border": bright_black,
        "fg": fg,
        "fg_alt": blend(fg, bright_white, 0.5),
        "bright": bright_white,
        "red": red,
        "orange": blend(red, yellow, 0.3),
        "yellow": yellow,
        "green": colors["green"],
        "cyan": colors["cyan"],
        "blue": colors["blue"],
        "magenta": colors["magenta"],
    }


def derive_vim_palette(colors):
    editor = derive_editor_palette(colors)
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
        "gui0F": blend(editor["bg"], editor["red"], 0.7),
        "gui_faint": editor["faint"],
        "gui_border": editor["border"],
    }
