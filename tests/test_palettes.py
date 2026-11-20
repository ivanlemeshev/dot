import configparser
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    "warm-earth": "1f1d1b a38b7b 9b9b87 b5a18a 959ba0 a99aa3 93a6a2 b4ada5 80746a c2a394 b7baa0 d0b79a b0b8c0 c5b1bd b1c6c1 ebe1d2".split(),
    "charcoal-pastel": "1d1f21 e07878 b4ca73 f3ca78 88b4d9 c29ccd 78c9c1 d3d6d4 999d9b ff9993 d3e78e ffe09a b1d0f2 deb6e8 a6e7db f6f6f3".split(),
}


class PaletteTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="dot-palettes-")
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.state = self.directory / "state"
        self.env = dict(os.environ, DOTFILES_PALETTE_STATE=str(self.state))

    def run_palette(self, *arguments, success=True):
        result = subprocess.run(
            [
                "pwsh",
                "-NoProfile",
                "-File",
                str(ROOT / "scripts/palette.ps1"),
                *arguments,
            ],
            env=self.env,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result.stdout

    def test_native_palettes(self):
        windows_keys = "black red green yellow blue purple cyan white brightBlack brightRed brightGreen brightYellow brightBlue brightPurple brightCyan brightWhite".split()
        for name, expected in EXPECTED.items():
            with self.subTest(palette=name):
                directory = ROOT / "palettes" / name
                ghostty = (directory / "ghostty").read_text()
                self.assertEqual(
                    re.findall(r"palette = \d+=#([0-9a-f]{6})", ghostty), expected
                )
                windows = json.loads((directory / "windows-terminal.json").read_text())
                scheme = windows["schemes"][0]
                self.assertEqual(
                    [scheme[key][1:].lower() for key in windows_keys], expected
                )
                self.assertEqual(scheme["name"], "custom")
                self.assertEqual(
                    windows["themes"][0]["tabRow"]["background"].lower(),
                    "#" + expected[0] + "ff",
                )
                konsole = configparser.ConfigParser()
                konsole.read(directory / "konsole.colorscheme")
                iterm = json.loads((directory / "iterm2.json").read_text())["Profiles"][
                    0
                ]
                self.assertEqual(iterm["Guid"], "b2f196a0-9822-4f69-8ce9-73f2de6b4371")
                for i, value in enumerate(expected):
                    rgb = tuple(int(value[j : j + 2], 16) for j in (0, 2, 4))
                    section = f"Color{i}" if i < 8 else f"Color{i - 8}Intense"
                    self.assertEqual(
                        tuple(map(int, konsole[section]["Color"].split(","))), rgb
                    )
                    self.assertEqual(
                        tuple(
                            round(
                                iterm[f"Ansi {i} Color"][channel + " Component"] * 255
                            )
                            for channel in ("Red", "Green", "Blue")
                        ),
                        rgb,
                    )
                for role, index in {
                    "background": 0,
                    "foreground": 7,
                    "cursor-color": 7,
                    "cursor-text": 0,
                    "selection-background": 4,
                    "selection-foreground": 0,
                }.items():
                    self.assertIn(f"{role} = #{expected[index]}\n", ghostty)

    @unittest.skipIf(os.name == "nt", "Unix links require a Unix host.")
    def test_switch_prepare_and_reverse_links(self):
        before = {
            path: hashlib.sha256(path.read_bytes()).digest()
            for path in (ROOT / "palettes").rglob("*")
            if path.is_file()
        }
        self.assertIn("* charcoal-pastel", self.run_palette("list"))
        self.assertFalse(self.state.exists())
        self.run_palette("prepare")
        ghostty = self.state / "ghostty/themes/custom"
        self.assertEqual(
            ghostty.read_bytes(), (ROOT / "palettes/charcoal-pastel/ghostty").read_bytes()
        )
        for name in ("charcoal-pastel", "warm-earth"):
            self.run_palette("use", name)
            self.assertEqual(self.run_palette("current").strip(), name)
            self.assertEqual(
                ghostty.read_bytes(),
                (ROOT / "palettes" / name / "ghostty").read_bytes(),
            )
            selection_time = (self.state / "selection").stat().st_mtime_ns
            active_time = (self.state / "active").lstat().st_mtime_ns
            self.run_palette("prepare")
            self.assertEqual(
                (self.state / "selection").stat().st_mtime_ns, selection_time
            )
            self.assertEqual((self.state / "active").lstat().st_mtime_ns, active_time)
        self.assertEqual(
            before,
            {path: hashlib.sha256(path.read_bytes()).digest() for path in before},
        )
        (self.state / "active").unlink()
        self.assertFalse(ghostty.exists())
        self.run_palette("prepare")
        self.assertTrue(ghostty.is_file())

    def test_reject_invalid_palette(self):
        self.run_palette("use", "../charcoal-pastel", success=False)
        self.run_palette("use", "missing", success=False)
        self.run_palette("use", success=False)
        self.run_palette("current", "charcoal-pastel", success=False)
        self.assertFalse(self.state.exists())

    @unittest.skipIf(os.name == "nt", "Unix links require a Unix host.")
    def test_preserve_conflicting_file(self):
        config = self.state / "ghostty/config"
        config.parent.mkdir(parents=True)
        config.write_text("local settings\n")
        self.run_palette("prepare", success=False)
        self.assertEqual(config.read_text(), "local settings\n")
        self.assertFalse((self.state / "selection").exists())

    @unittest.skipIf(os.name == "nt", "Unix links require a Unix host.")
    def test_mise_links_apply_and_reverse(self):
        self.run_palette("prepare")
        config = self.directory / "mise"
        config.mkdir()
        ghostty = self.directory / "ghostty"
        iterm = self.directory / "iterm2.json"
        (config / "config.toml").write_text(
            "[dotfiles]\n"
            + f"{json.dumps(str(ghostty))} = {{ source = {json.dumps(str(self.state / 'ghostty'))} }}\n"
            + f"{json.dumps(str(iterm))} = {{ source = {json.dumps(str(self.state / 'active/iterm2.json'))} }}\n"
        )
        env = dict(
            self.env,
            MISE_CONFIG_DIR=str(config),
            MISE_STATE_DIR=str(self.directory / "mise-state"),
            MISE_CACHE_DIR=str(self.directory / "mise-cache"),
            MISE_TRUSTED_CONFIG_PATHS=str(config),
        )

        def mise(*arguments):
            result = subprocess.run(
                ["mise", "dot", *arguments, "--yes"],
                cwd=self.directory,
                env=env,
                capture_output=True,
                text=True,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

        mise("apply")
        self.assertTrue(ghostty.is_symlink())
        self.assertTrue(iterm.is_symlink())
        self.run_palette("use", "charcoal-pastel")
        mise("apply")
        self.assertEqual(
            (ghostty / "themes/custom").read_bytes(),
            (ROOT / "palettes/charcoal-pastel/ghostty").read_bytes(),
        )
        self.assertEqual(
            iterm.read_bytes(), (ROOT / "palettes/charcoal-pastel/iterm2.json").read_bytes()
        )
        mise("unapply")
        self.assertFalse(ghostty.is_symlink())
        self.assertFalse(iterm.is_symlink())

    @unittest.skipIf(os.name == "nt", "The Fedora adapter requires Bash and jq.")
    def test_fedora_link_migration_and_restore(self):
        self.run_palette("prepare")
        script = self.directory / "fedora-test.sh"
        script.write_text(r"""
set -euo pipefail
. "$PALETTE_TEST_ROOT/fedora/state.sh"
STATE="$PALETTE_TEST_DIRECTORY/fedora-state"
PROFILE="$PALETTE_TEST_DIRECTORY/konsole"
mkdir -p "$PROFILE" "$STATE"
printf 'previous scheme\n' >"$STATE/backup"
ln -s "$ROOT/konsole/custom.colorscheme" "$PROFILE/custom.colorscheme"
jq -n --arg target "$PROFILE/custom.colorscheme" --arg source "$ROOT/konsole/custom.colorscheme" --arg backup "$STATE/backup" '{links:[{target:$target,source:$source,backup:$backup}],preferences:[]}' >"$STATE/state.json"
state="$(load)"
deploy
test "$(readlink "$PROFILE/custom.colorscheme")" = "$PALETTE_STATE/active/konsole.colorscheme"
test -f "$PROFILE/custom.colorscheme"
state="$(load)"
deploy
reload_keyboard() { :; }
unapply
test "$(cat "$PROFILE/custom.colorscheme")" = 'previous scheme'
test ! -e "$PROFILE/dot.profile"
""")
        result = subprocess.run(
            ["bash", str(script)],
            env=dict(
                self.env,
                PALETTE_TEST_ROOT=str(ROOT),
                PALETTE_TEST_DIRECTORY=str(self.directory),
            ),
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_windows_merge_and_restore(self):
        script = self.directory / "windows-test.ps1"
        script.write_text(r"""
$ErrorActionPreference = 'Stop'
$root = $env:PALETTE_TEST_ROOT
. (Join-Path $root 'windows/helpers.ps1')
. (Join-Path $root 'windows/terminal.ps1')
$StateDirectory = Join-Path $env:PALETTE_TEST_DIRECTORY 'windows-state'
$terminal = Join-Path $env:PALETTE_TEST_DIRECTORY 'terminal'
New-Item -ItemType Directory -Path $terminal | Out-Null
$path = Join-Path $terminal 'settings.json'
$original = '{"profiles":{"defaults":{"font":{"face":"local font"}},"list":[{"name":"shell","colorScheme":"other"}]},"keybindings":[{"keys":"ctrl+x","id":"copy"}],"schemes":[{"name":"other","black":"#000000"}]}'
[IO.File]::WriteAllText($path, $original)
foreach ($name in @('charcoal-pastel', 'warm-earth')) {
    Set-WindowsTerminalSettings $terminal (Join-Path $root 'windows/terminal/settings.json') -ThemesOnly -PaletteName $name
    $settings = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    if ($settings.profiles.defaults.font.face -ne 'local font') { throw 'Font changes.' }
    if ($settings.keybindings[0].keys -ne 'ctrl+x') { throw 'Keybindings change.' }
    if ($settings.profiles.list[0].colorScheme -ne 'custom') { throw 'Profile does not select the palette.' }
    if (@($settings.schemes | Where-Object name -eq 'other').Count -ne 1) { throw 'Another scheme changes.' }
    $expected = Get-Content (Join-Path $root "palettes/$name/windows-terminal.json") -Raw | ConvertFrom-Json
    $scheme = $settings.schemes | Where-Object name -eq 'custom'
    foreach ($property in $expected.schemes[0].PSObject.Properties) {
        if ($scheme.($property.Name) -ne $property.Value) { throw "Color differs: $($property.Name)" }
    }
    $hash = (Get-FileHash $path).Hash
    Set-WindowsTerminalSettings $terminal (Join-Path $root 'windows/terminal/settings.json') -ThemesOnly -PaletteName $name
    if ((Get-FileHash $path).Hash -ne $hash) { throw 'Repeated application changes settings.' }
}
Restore-WindowsTerminalSettings
if ([IO.File]::ReadAllText($path) -cne $original) { throw 'Restoration differs.' }
""")
        result = subprocess.run(
            ["pwsh", "-NoProfile", "-File", str(script)],
            env=dict(
                self.env,
                PALETTE_TEST_ROOT=str(ROOT),
                PALETTE_TEST_DIRECTORY=str(self.directory),
            ),
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
