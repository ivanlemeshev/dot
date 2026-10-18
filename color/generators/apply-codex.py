#!/usr/bin/env python3

import glob
import json
import os
import plistlib
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <theme-directory>", file=sys.stderr)
    sys.exit(1)

source_yaml = sys.argv[1]
theme_directory = sys.argv[2]
spec_file = os.path.join(os.path.dirname(__file__), "..", "templates", "tmtheme_spec.json")
section_re = re.compile(
    r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
)
codex_settings = {
    "background": "background",
    "foreground": "foreground",
    "caret": "caret",
    "lineHighlight": "line_highlight",
    "selection": "selection",
    "selectionBorder": "selection_border",
    "invisibles": "invisibles",
    "guide": "guide",
    "activeGuide": "active_guide",
    "gutter": "gutter",
    "gutterForeground": "gutter_foreground",
    "findHighlight": "find_highlight",
    "findHighlightForeground": "find_highlight_foreground",
    "bracketsForeground": "brackets_foreground",
    "bracketContentsForeground": "bracket_contents_foreground",
}


def parse_section(yaml_file, section_name):
    values = {}
    active_section = False
    with open(yaml_file, encoding="utf-8") as handle:
        for line in handle:
            if line.strip() == f"{section_name}:":
                active_section = True
                continue
            if active_section:
                if line and not line.startswith("  "):
                    break
                match = section_re.match(line)
                if match:
                    key = match.group(1) or match.group(2)
                    values[key] = match.group(3).lower()
    if not values:
        raise ValueError(f"{section_name} section is required in YAML")
    return values


def parse_theme_name(yaml_file):
    with open(yaml_file, encoding="utf-8") as handle:
        match = re.search(r'^name:\s+"([^"]+)"\s*$', handle.read(), re.M)
    if not match:
        raise ValueError("Theme name is required in YAML")
    return match.group(1)


def generate_theme(yaml_file, spec, theme_directory, output_name=None, name_suffix=""):
    codex = parse_section(yaml_file, "codex")
    sections = {
        name: parse_section(yaml_file, name)
        for name in ("base_palette", "ui", "syntax", "git", "diagnostic")
    }
    global_settings = {
        setting: codex[key] for setting, key in codex_settings.items()
    }

    def resolve_color(name):
        if "." in name:
            section, key = name.split(".", 1)
            if section in sections and key in sections[section]:
                return sections[section][key]
        for values in sections.values():
            if name in values:
                return values[name]
        raise ValueError(f"Unknown color reference: {name}")

    settings = [{"settings": global_settings}]
    for entry in spec["entries"]:
        entry_settings = {}
        if "color" in entry:
            entry_settings["foreground"] = resolve_color(entry["color"])
        if entry.get("fontStyle"):
            entry_settings["fontStyle"] = entry["fontStyle"]
        settings.append(
            {
                "name": entry["name"],
                "scope": entry["scope"],
                "settings": entry_settings,
            }
        )

    theme_name = parse_theme_name(yaml_file) + name_suffix
    content = {"name": theme_name, "settings": settings}
    output_path = os.path.join(
        theme_directory,
        output_name or os.path.basename(yaml_file).removesuffix(".yaml") + ".tmTheme",
    )
    os.makedirs(theme_directory, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        mode="wb", dir=theme_directory, delete=False, suffix=".tmp"
    ) as tmp:
        plistlib.dump(content, tmp, fmt=plistlib.FMT_XML, sort_keys=False)
        tmp_path = tmp.name
    os.replace(tmp_path, output_path)
    print(f"Updated {output_path}")


try:
    with open(spec_file, encoding="utf-8") as handle:
        theme_spec = json.load(handle)
    theme_files = sorted(glob.glob(os.path.join(os.path.dirname(source_yaml), "*.yaml")))
    for theme_file in theme_files:
        generate_theme(theme_file, theme_spec, theme_directory)
    generate_theme(source_yaml, theme_spec, theme_directory, "custom.tmTheme", " (Custom)")
except (OSError, ValueError, json.JSONDecodeError) as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)
