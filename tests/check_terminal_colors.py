#!/usr/bin/env python3

import configparser
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXPECTED = [
    "#1d1f21", "#a54242", "#8c9440", "#de935f",
    "#5f819d", "#85678f", "#5e8d87", "#a7adb1",
    "#5d666e", "#cc6666", "#b5bd68", "#f0c674",
    "#81a2be", "#b294bb", "#8abeb7", "#e6e8e6",
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
scheme = next(item for item in settings["schemes"] if item["name"] == "custom")
check([scheme[key].lower() for key in KEYS], EXPECTED, "Windows Terminal ANSI colors")
check(settings["profiles"]["defaults"]["colorScheme"], "custom", "Windows Terminal selection")
check(scheme["selectionBackground"].lower(), scheme["brightBlue"].lower(), "Terminal selection background")
check(scheme["background"].lower(), "#1d1f21", "Terminal background")
check(scheme["black"].lower(), scheme["background"].lower(), "ANSI black matches the background")
for theme in settings["themes"]:
    for section in ("tab", "tabRow"):
        for value in theme[section].values():
            if isinstance(value, str) and value.startswith("#"):
                check(value[:7].lower() in EXPECTED, True, "Terminal chrome uses the ANSI palette")
check(scheme["foreground"].lower(), "#e6e8e6", "Terminal foreground")
check(scheme["cursorColor"].lower(), "#e6e8e6", "Terminal cursor")

palette = {}
ghostty = {}
for line in (ROOT / ".config/ghostty/themes/custom").read_text().splitlines():
    key, _, value = line.partition("=")
    if key.strip() == "palette":
        index, color = value.strip().split("=")
        palette[int(index)] = color.lower()
    else:
        ghostty[key.strip()] = value.strip().lower()
check(sorted(palette), list(range(16)), "Ghostty ANSI indices")
check([palette[index] for index in range(16)], EXPECTED, "Ghostty ANSI colors")
ghostty_config = (ROOT / ".config/ghostty/config").read_text().splitlines()
check(ghostty_config[0], "theme = custom", "Ghostty selection")
check("cursor-style-blink = false" in ghostty_config, True, "Ghostty cursor blinking")

konsole = configparser.ConfigParser()
konsole.read(ROOT / ".config/konsole/custom.colorscheme")
check([rgb_hex(konsole[f"Color{i}"]["Color"]) for i in range(8)]
      + [rgb_hex(konsole[f"Color{i}Intense"]["Color"]) for i in range(8)], EXPECTED, "Konsole ANSI colors")
check([rgb_hex(konsole[f"Color{i}Faint"]["Color"]) for i in range(8)], EXPECTED[:8], "Konsole faint colors")
check(konsole["General"]["Description"], "custom", "Konsole theme name")
profile = configparser.ConfigParser()
profile.read(ROOT / ".config/konsole/dot.profile.in")
check(profile["Appearance"]["ColorScheme"], "custom", "Konsole selection")
check(profile["Terminal Features"].getboolean("BlinkingCursorEnabled"), False, "Konsole cursor blinking")

iterm = json.loads((ROOT / "macos/iterm2/custom.json").read_text())["Profiles"][0]
check(iterm["Name"], "custom", "iTerm2 profile name")
check(iterm_hex(iterm["Bold Color"]), "#e6e8e6", "iTerm2 bold text")
check(iterm["Blinking Cursor"], False, "iTerm2 cursor blinking")
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
check(ghostty["selection-foreground"], scheme["background"].lower(), "Ghostty selected text")
check(iterm_hex(iterm["Selected Text Color"]), scheme["background"].lower(), "iTerm2 selected text")
vscode_settings = json.loads((ROOT / "windows/vscode/settings.json").read_text())
check(vscode_settings["editor.cursorBlinking"], "solid", "VS Code editor cursor blinking")
check(vscode_settings["terminal.integrated.cursorBlinking"], False, "VS Code terminal cursor blinking")
vscode = vscode_settings["workbench.colorCustomizations"]
vscode_keys = ["terminal.ansi" + key[0].upper() + key[1:] for key in KEYS]
vscode_keys = [key.replace("Purple", "Magenta") for key in vscode_keys]
check([vscode[key].lower() for key in vscode_keys], EXPECTED, "VS Code terminal ANSI colors")
for name, key in [("background", "background"), ("foreground", "foreground"), ("selectionBackground", "selectionBackground")]:
    check(vscode["terminal." + name].lower(), scheme[key].lower(), f"VS Code terminal {name}")
check(vscode["terminalCursor.foreground"].lower(), scheme["cursorColor"].lower(), "VS Code terminal cursor")
check(vscode["terminal.selectionForeground"].lower(), scheme["background"].lower(), "VS Code selected text")
print("All five terminals use the same custom ANSI 16 palette")
