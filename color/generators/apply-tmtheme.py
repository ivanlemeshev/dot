#!/usr/bin/env python3

import json
import os
import plistlib
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <custom.tmTheme>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
tmtheme_file = sys.argv[2]

spec_file = os.path.join(
    os.path.dirname(__file__), "..", "templates", "tmtheme_spec.json"
)

SECTION_RE = re.compile(
    r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
)


def normalize_hex(value):
    return "#" + value.lstrip("#").lower()


def parse_section(path, section_name):
    values = {}
    active_section = False

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == f"{section_name}:":
                active_section = True
                continue
            if active_section:
                if line and not line.startswith("  "):
                    break
                match = SECTION_RE.match(line)
                if match:
                    key = match.group(1) or match.group(2)
                    values[key] = normalize_hex(match.group(3))

    if not values:
        raise ValueError(f"{section_name} section is required in YAML")

    return values


try:
    base_palette = parse_section(yaml_file, "base_palette")
    ui = parse_section(yaml_file, "ui")
    syntax = parse_section(yaml_file, "syntax")
    git = parse_section(yaml_file, "git")
    diagnostic = parse_section(yaml_file, "diagnostic")
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

with open(spec_file, encoding="utf-8") as f:
    spec = json.load(f)


def resolve_color(name):
    if "." in name:
        section, key = name.split(".", 1)
        if section == "base_palette" and key in base_palette:
            return base_palette[key]
        if section == "ui" and key in ui:
            return ui[key]
        if section == "syntax" and key in syntax:
            return syntax[key]
        if section == "git" and key in git:
            return git[key]
        if section == "diagnostic" and key in diagnostic:
            return diagnostic[key]
        if section == "semantic":
            semantic_aliases = {
                "added": git["add"],
                "removed": git["delete"],
                "changed": git["change"],
                "diff_text": ui["selection_bg"],
                "title": syntax["type"],
                "hint": diagnostic["hint"],
                "error": diagnostic["error"],
                "muted": ui["non_text"],
            }
            if key in semantic_aliases:
                return semantic_aliases[key]
        ui_aliases = {
            "cursorline": "cursor_line",
            "border": "float_border_fg",
            "bg_dim": "folded_bg",
            "fg_dim": "non_text",
            "muted": "non_text",
            "selection": "selection_bg",
        }
        syntax_aliases = {
            "escape": "special_char",
        }
        if section == "ui":
            alias = ui_aliases.get(key, key)
            if alias in ui:
                return ui[alias]
        if section == "syntax":
            alias = syntax_aliases.get(key, key)
            if alias in syntax:
                return syntax[alias]
    if name in base_palette:
        return base_palette[name]
    if name in ui:
        return ui[name]
    if name in syntax:
        return syntax[name]
    if name in git:
        return git[name]
    if name in diagnostic:
        return diagnostic[name]
    raise ValueError(f"Unknown color reference: {name}")


global_settings = {}
for item in spec["global_settings"]:
    suffix = item.get("alpha", "")
    global_settings[item["key"]] = resolve_color(item["color"]) + suffix

settings = [{"settings": global_settings}]
for entry in spec["entries"]:
    entry_settings = {}
    if "color" in entry:
        entry_settings["foreground"] = resolve_color(entry["color"])
    font_style = entry.get("fontStyle", "")
    if font_style:
        entry_settings["fontStyle"] = font_style
    settings.append(
        {
            "name": entry["name"],
            "scope": entry["scope"],
            "settings": entry_settings,
        }
    )

content = {
    "name": spec["name"],
    "settings": settings,
}

dir_ = os.path.dirname(os.path.abspath(tmtheme_file))
with tempfile.NamedTemporaryFile(
    mode="wb", dir=dir_, delete=False, suffix=".tmp"
) as tmp:
    tmp_path = tmp.name
    plistlib.dump(content, tmp, fmt=plistlib.FMT_XML, sort_keys=False)
os.replace(tmp_path, tmtheme_file)
print(f"Updated {tmtheme_file}")
