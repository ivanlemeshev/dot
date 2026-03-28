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

BASE16_KEYS = {
    "base00",
    "base01",
    "base02",
    "base03",
    "base04",
    "base05",
    "base06",
    "base07",
    "base08",
    "base09",
    "base0A",
    "base0B",
    "base0C",
    "base0D",
    "base0E",
    "base0F",
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


def _parse_base16(yaml_file, prefix="#", uppercase=False):
    return _parse_section(
        yaml_file, "base16", BASE16_KEYS, prefix=prefix, uppercase=uppercase
    )


def derive_ansi_from_base16(base16):
    if not base16:
        raise ValueError("Base16 section is required in YAML")

    missing = sorted(BASE16_KEYS - set(base16.keys()))
    if missing:
        raise ValueError("Base16 is missing required keys: " + ", ".join(missing))

    return {
        "bg": base16["base00"],
        "fg": base16["base05"],
        "black": base16["base01"],
        "red": base16["base08"],
        "green": base16["base0B"],
        "yellow": base16["base0A"],
        "blue": base16["base0D"],
        "magenta": base16["base0E"],
        "cyan": base16["base0C"],
        "white": base16["base06"],
        "bright_black": base16["base03"],
        "bright_red": base16["base08"],
        "bright_green": base16["base0B"],
        "bright_yellow": base16["base0A"],
        "bright_blue": base16["base0D"],
        "bright_magenta": base16["base0E"],
        "bright_cyan": base16["base0C"],
        "bright_white": base16["base07"],
    }


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
    source_ansi = _parse_ansi(yaml_file, prefix=prefix, uppercase=uppercase)
    base16 = _parse_base16(yaml_file, prefix=prefix, uppercase=uppercase)

    if source_ansi is None and base16 is None:
        raise ValueError("Ansi or base16 section is required in YAML")

    if source_ansi is None:
        source_ansi = derive_ansi_from_base16(base16)

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
        "base16": base16,
    }


def load_theme_sections(yaml_file, prefix="#", uppercase=False):
    bundle = load_theme_bundle(yaml_file, prefix=prefix, uppercase=uppercase)
    return bundle["colors"], bundle["ansi"]


def load_theme(yaml_file, prefix="#", uppercase=False):
    colors, _palette = load_theme_sections(
        yaml_file, prefix=prefix, uppercase=uppercase
    )
    return colors


def derive_editor_palette_with_ansi(ansi):
    required = {"background", "foreground"} | ANSI_KEYS | {
        "brightBlack",
        "brightWhite",
        "brightCyan",
        "brightMagenta",
    }
    missing = sorted(required - set(ansi.keys()))
    if missing:
        raise ValueError("Ansi is missing required keys: " + ", ".join(missing))

    return {
        "bg": ansi["bg"],
        "bg_alt": ansi["black"],
        "bg_sel": ansi["white"],
        "faint": ansi["black"],
        "muted": ansi["brightBlack"],
        "dim": ansi["brightBlack"],
        "border": ansi["brightBlack"],
        "fg": ansi["fg"],
        "fg_alt": ansi["white"],
        "bright": ansi["brightWhite"],
        "red": ansi["red"],
        "orange": ansi["brightMagenta"],
        "yellow": ansi["yellow"],
        "green": ansi["green"],
        "cyan": ansi["cyan"],
        "blue": ansi["blue"],
        "magenta": ansi["magenta"],
        "background": ansi["background"],
        "foreground": ansi["foreground"],
        "black": ansi["black"],
        "white": ansi["white"],
        "background_red": ansi["red"],
        "background_yellow": ansi["yellow"],
        "background_green": ansi["green"],
        "background_blue": ansi["blue"],
        "background_purple": ansi["magenta"],
        "background_visual": ansi["white"],
        "background_3": ansi["black"],
        "background_5": ansi["brightBlack"],
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
        "gui08_bright": editor["bright_red"],
        "gui0B_bright": editor["bright_green"],
        "gui0C_bright": editor["bright_cyan"],
        "gui0D_bright": editor["bright_blue"],
        "gui0E_bright": editor["bright_magenta"],
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


def derive_vim_palette_with_ansi(ansi):
    editor = derive_editor_palette_with_ansi(ansi)
    editor["bright_red"] = ansi["brightRed"]
    editor["bright_green"] = ansi["brightGreen"]
    editor["bright_cyan"] = ansi["brightCyan"]
    editor["bright_blue"] = ansi["brightBlue"]
    editor["bright_magenta"] = ansi["brightMagenta"]
    return editor_palette_to_vim(editor)


def derive_vim_palette_with_base16(base16, ansi):
    if not base16:
        raise ValueError("Base16 section is required in YAML")

    missing = sorted(BASE16_KEYS - set(base16.keys()))
    if missing:
        raise ValueError("Base16 is missing required keys: " + ", ".join(missing))

    if ansi is None:
        ansi = derive_ansi_roles(derive_ansi_from_base16(base16))

    return {
        "gui00": base16["base00"],
        "gui01": base16["base01"],
        "gui02": base16["base02"],
        "gui03": base16["base03"],
        "gui04": base16["base04"],
        "gui05": base16["base05"],
        "gui06": base16["base06"],
        "gui07": base16["base07"],
        "gui08": base16["base08"],
        "gui09": base16["base09"],
        "gui0A": base16["base0A"],
        "gui0B": base16["base0B"],
        "gui0C": base16["base0C"],
        "gui0D": base16["base0D"],
        "gui0E": base16["base0E"],
        "gui0F": base16["base0F"],
        "gui08_bright": ansi["brightRed"],
        "gui0B_bright": ansi["brightGreen"],
        "gui0C_bright": ansi["brightCyan"],
        "gui0D_bright": ansi["brightBlue"],
        "gui0E_bright": ansi["brightMagenta"],
        "gui_faint": base16["base01"],
        "gui_border": base16["base03"],
        "gui_bg_red": base16["base08"],
        "gui_bg_yellow": base16["base0A"],
        "gui_bg_green": base16["base0B"],
        "gui_bg_blue": base16["base0D"],
        "gui_bg_purple": base16["base0E"],
        "gui_bg_visual": base16["base02"],
        "gui_bg3": base16["base01"],
        "gui_bg5": base16["base03"],
    }


def derive_vim_palette(base16=None, ansi=None):
    if base16 is not None:
        return derive_vim_palette_with_base16(base16, ansi)
    if ansi is not None:
        return derive_vim_palette_with_ansi(ansi)
    raise ValueError("Ansi or base16 section is required in YAML")
