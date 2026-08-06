#!/usr/bin/env python3

import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(
        f"Usage: {sys.argv[0]} <color-scheme.yaml> <konsole-colorscheme>",
        file=sys.stderr,
    )
    sys.exit(1)

yaml_file = sys.argv[1]
konsole_file = sys.argv[2]

PALETTE_KEYS = {
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

NORMAL_COLORS = [
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
]

BRIGHT_COLORS = [
    "bright_black",
    "bright_red",
    "bright_green",
    "bright_yellow",
    "bright_blue",
    "bright_magenta",
    "bright_cyan",
    "bright_white",
]


def parse_theme(path):
    name = None
    palette = {}
    active_section = False
    name_pattern = re.compile(r'^name:\s+"?([^"\n]+)"?\s*$')
    color_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+"?(#[0-9a-fA-F]{6})"?(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            if name is None:
                match = name_pattern.match(line)
                if match:
                    name = match.group(1)

            if line.strip() == "base_palette:":
                active_section = True
                continue
            if active_section:
                if line and not line.startswith("  "):
                    active_section = False
                    continue
                match = color_pattern.match(line)
                if match:
                    key = match.group(1) or match.group(2)
                    palette[key] = match.group(3)

    if not name:
        raise ValueError("Theme name is required in YAML")

    missing = sorted(PALETTE_KEYS - set(palette))
    if missing:
        raise ValueError("Base palette is missing required keys: " + ", ".join(missing))

    return name, palette


def rgb(value):
    value = value.lstrip("#")
    return ",".join(str(int(value[index : index + 2], 16)) for index in (0, 2, 4))


try:
    theme_name, base_palette = parse_theme(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

sections = [
    ("Background", base_palette["bg"]),
    ("BackgroundFaint", base_palette["bg"]),
    ("BackgroundIntense", base_palette["bg"]),
]

for index, (normal, bright) in enumerate(zip(NORMAL_COLORS, BRIGHT_COLORS)):
    sections.extend(
        [
            (f"Color{index}", base_palette[normal]),
            (f"Color{index}Faint", base_palette[normal]),
            (f"Color{index}Intense", base_palette[bright]),
        ]
    )

sections.extend(
    [
        ("Foreground", base_palette["fg"]),
        ("ForegroundFaint", base_palette["fg"]),
        ("ForegroundIntense", base_palette["bright_white"]),
    ]
)

lines = []
for section, color in sections:
    lines.extend([f"[{section}]", f"Color={rgb(color)}", ""])

lines.extend(
    [
        "[General]",
        "Blur=false",
        "ColorRandomization=false",
        f"Description={theme_name}",
        "Opacity=1",
        "Wallpaper=",
        "",
    ]
)

directory = os.path.dirname(os.path.abspath(konsole_file))
os.makedirs(directory, exist_ok=True)
with tempfile.NamedTemporaryFile(
    mode="w", dir=directory, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    tmp.write("\n".join(lines))
os.replace(tmp_path, konsole_file)
print(f"Updated {konsole_file}")
