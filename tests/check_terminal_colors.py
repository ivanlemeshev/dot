#!/usr/bin/env python3

import configparser
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXPECTED = [
    "#1d1f21", "#cc6666", "#b5bd68", "#f0c674",
    "#81a2be", "#b294bb", "#8abeb7", "#c5c8c6",
    "#969896", "#cc6666", "#b5bd68", "#f0c674",
    "#81a2be", "#b294bb", "#8abeb7", "#ffffff",
]
KEYS = [
    "black", "red", "green", "yellow", "blue", "purple", "cyan", "white",
    "brightBlack", "brightRed", "brightGreen", "brightYellow",
    "brightBlue", "brightPurple", "brightCyan", "brightWhite",
]


def check(actual, expected, label):
    assert actual == expected, f"{label}: {actual!r} != {expected!r}"


def rgb_hex(value):
    return "#" + "".join(f"{int(component):02x}" for component in value.split(","))


def iterm_hex(value):
    return "#" + "".join(
        f"{round(value[channel + ' Component'] * 255):02x}"
        for channel in ("Red", "Green", "Blue")
    )


settings = json.loads((ROOT / "windows/terminal/settings.json").read_text())
scheme = next(item for item in settings["schemes"] if item["name"] == "Tomorrow Night")
check([scheme[key].lower() for key in KEYS], EXPECTED, "Windows Terminal ANSI colors")
check(settings["profiles"]["defaults"]["colorScheme"], "Tomorrow Night", "Windows Terminal selection")
check(scheme["selectionBackground"].lower(), scheme["brightBlack"].lower(), "Terminal selection background")

palette = {}
ghostty = {}
for line in (ROOT / ".config/ghostty/themes/TomorrowNight").read_text().splitlines():
    key, _, value = line.partition("=")
    if key.strip() == "palette":
        index, color = value.strip().split("=")
        palette[int(index)] = color.lower()
    else:
        ghostty[key.strip()] = value.strip().lower()
check(sorted(palette), list(range(16)), "Ghostty ANSI indices")
check([palette[index] for index in range(16)], EXPECTED, "Ghostty ANSI colors")
check((ROOT / ".config/ghostty/config").read_text().splitlines()[0], "theme = TomorrowNight", "Ghostty selection")

konsole = configparser.ConfigParser()
konsole.read(ROOT / ".config/konsole/TomorrowNight.colorscheme")
check([rgb_hex(konsole[f"Color{i}"]["Color"]) for i in range(8)]
      + [rgb_hex(konsole[f"Color{i}Intense"]["Color"]) for i in range(8)], EXPECTED, "Konsole ANSI colors")
profile = configparser.ConfigParser()
profile.read(ROOT / ".config/konsole/dot.profile.in")
check(profile["Appearance"]["ColorScheme"], "TomorrowNight", "Konsole selection")

iterm = json.loads((ROOT / "macos/iterm2/TomorrowNight.json").read_text())["Profiles"][0]
check(iterm["Name"], "Tomorrow Night", "iTerm2 profile name")
check([iterm_hex(iterm[f"Ansi {i} Color"]) for i in range(16)], EXPECTED, "iTerm2 ANSI colors")
for terminal_key, ghostty_key, iterm_key in [
    ("background", "background", "Background Color"),
    ("foreground", "foreground", "Foreground Color"),
    ("cursorColor", "cursor-color", "Cursor Color"),
    ("selectionBackground", "selection-background", "Selection Color"),
]:
    expected = scheme[terminal_key].lower()
    check(ghostty[ghostty_key], expected, f"Ghostty {ghostty_key}")
    check(iterm_hex(iterm[iterm_key]), expected, f"iTerm2 {iterm_key}")
for section, key in [("Background", "background"), ("Foreground", "foreground")]:
    check(rgb_hex(konsole[section]["Color"]), scheme[key].lower(), f"Konsole {section}")
check(iterm_hex(iterm["Cursor Text Color"]), scheme["background"].lower(), "iTerm2 cursor text")
check(ghostty["cursor-text"], scheme["background"].lower(), "Ghostty cursor text")
check(ghostty["selection-foreground"], scheme["black"].lower(), "Ghostty selected text")
check(iterm_hex(iterm["Selected Text Color"]), scheme["black"].lower(), "iTerm2 selected text")
vscode = json.loads((ROOT / "windows/vscode/settings.json").read_text())["workbench.colorCustomizations"]
vscode_keys = ["terminal.ansi" + key[0].upper() + key[1:] for key in KEYS]
vscode_keys = [key.replace("Purple", "Magenta") for key in vscode_keys]
check([vscode[key].lower() for key in vscode_keys], EXPECTED, "VS Code terminal ANSI colors")
for name, key in [("background", "background"), ("foreground", "foreground"), ("selectionBackground", "selectionBackground")]:
    check(vscode["terminal." + name].lower(), scheme[key].lower(), f"VS Code terminal {name}")
check(vscode["terminalCursor.foreground"].lower(), scheme["cursorColor"].lower(), "VS Code terminal cursor")
check(vscode["terminal.selectionForeground"].lower(), scheme["black"].lower(), "VS Code selected text")
print("All five terminals use the same Tomorrow Night ANSI 16 palette")
