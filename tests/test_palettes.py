import colorsys
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
    "cold-graphite": "191d22 c58f99 91b5a5 c4ba91 91afd0 b6a0c9 8dbfc5 bbc2cb 87919e e0adb6 acd1bf dfd5ac afccec d2bce5 abe0e5 edf1f5".split(),
    "deep-ocean": "121e28 c48e9b 8db8a9 c3ba94 8baed0 b1a0cd 83bec8 b8c8d1 8196a5 dfaab7 a8d5c2 dfd6ae a9cbed cdbce9 a1dce6 eaf3f7".split(),
    "violet-graphite": "201e28 c494a8 99b5a4 c5bd9c 98acd2 bca1d0 91bdc7 c1bfcd 908a9e e0b0c3 b6d2bf e0d8b8 b6c8ed d8bdeb afe0e8 f0eef7".split(),
    "solarized-dark-soft": "073642 e67e78 a6b73d d2aa43 6baedc dc85b1 57b7ad eee8d5 839496 f08e89 c0d35b e5c46a 91c8eb e69dc3 83d0c5 fdf6e3".split(),
    "gruvbox-material-dark": "282828 ea6962 a9b665 d8a657 7daea3 d3869b 89b482 d4be98 928374 e78a4e b8bb80 e2bd85 9dc5b9 e0a5b7 a9caa1 ddc7a1".split(),
    "everforest-dark": "2d353b e67e80 a7c080 dbbc7f 7fbbb3 d699b6 83c092 d3c6aa 859289 e69875 b5ca95 e5cb9b 9dcfc6 e3b2ca a2d0ad e5dfc5".split(),
    "commodore-64-soft": "1c1d24 b77d83 86ad80 b49a73 8a87c4 b185b9 82b7b2 b9b8bd 82818b d49ca2 a8c99f d5cf93 aaa6df c9a2cf a2cfca e4e2e8".split(),
    "ibm-sga-soft": "1c1c20 c27d7d 83ad83 b99a7a 8585c2 b583b5 7babab b8b8c0 808087 dc9a9a a4cba4 d0d093 a7a7de d0a3d0 9fcece e4e4e8".split(),
    "ibm-5151-green": "061009 5d9866 65a970 7bbd83 72ae7a 83bf8b 8bc997 a0d9a9 47744e 9bd4a3 a9e1b1 b9eabd aee5b5 c0efc6 ccf5d0 ddffe0".split(),
    "dec-vt220-amber": "140c04 bb772d c18b37 d3a148 c08b49 d0a056 dab05e e8bf75 8b5924 e5b36b ebc17a f3ce90 eec583 f4d59e f8dda9 ffe8bc".split(),
    "amiga-workbench": "10141c bb785b 759da0 d8a36a 5988bd a58aaa 80acbb c4cbd2 747d8a e4a185 a0c4ba f0c68b 93b8df d1b4d1 b2d6df eef0f2".split(),
    "apple-ii": "0b0b15 b86a72 69aa69 c9a35e 647dc0 ad76c3 70b3b8 c3c4cd 77758b de91a1 93cc91 e7cd88 9babeb d7a1eb a3d9df f3f0f9".split(),
    "nextstep": "191b1e ad949b 96aaa0 b2ad9e 91a5b7 a79caf 95afb3 c0c3c7 818891 cbb0b7 b2c7b9 d0c9b7 aec3d5 c4b7ce b2ccd0 eef0f2".split(),
    "risc-os": "20252a bf9294 95b19c c2b596 8faac4 b1a0bb 8eb5b8 c3c8c9 87929a d9acae b0cbb3 dcd0af acc6df cbbad5 abd0d2 edf1ef".split(),
    "sgi-irix": "171e29 be929f 91b5aa beb79a 8baed0 b09fc8 87b9c4 bac6d1 8094a5 d9acb7 acd0c3 d9d2b4 a8c9e9 cbb9e2 a5d5df edf3f7".split(),
    "ibm-3279": "10191a c78f91 8ab79a c5bb89 8b9fc1 b59bbd 83bec1 b9c9c6 78948f e0aaac a5d1b0 ded3a3 a7badd cfb5d8 9fd8d9 e5f0eb".split(),
    "dec-vt340": "131b20 bb9294 8fb39a bdb795 90a9c2 af9db7 88b8bb bac6c8 809198 d6acae aaceb0 d7d0ae acc4dd c9b6d1 a4d2d4 eaf0ef".split(),
    "atari-st": "1d2026 c29596 98b29a c6b99a 92a9c9 b49fbc 8cb7bf c4c8ce 858e9b ddafb0 b3ccb1 dfd2b2 aec5e3 ceb9d6 a8d2da edf0f4".split(),
    "mac-system-7": "1b1b1d aaa0a2 a0aaa4 b0ada3 9fa8b1 aba3b0 a0adb0 c4c4c6 858588 c8bbbe bdc8c0 cdc8bc bdc6d0 c9bfce bdcbd0 f0f0f0".split(),
    "zx-spectrum": "191a20 bb8389 83ac8b b8ae80 8297c2 ac88b7 80abb8 b9bdc4 80848e dea4ab a4cdae dcd09f a3b7e2 cda8d9 a0ccd9 eef0f4".split(),
    "everforest-dark-hard": "272e33 e67e80 a7c080 dbbc7f 7fbbb3 d699b6 83c092 e5dfc5 9da99c e69875 b5ca95 e5cb9b 9dcfc6 e3b2ca a2d0ad f4f0da".split(),
    "gruvbox-material-dark-hard": "1d2021 ea6962 a9b665 d8a657 7daea3 d3869b 89b482 ddc7a1 a89984 e78a4e b8bb80 e2bd85 9dc5b9 e0a5b7 a9caa1 f2e5bc".split(),
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

    def test_adjusted_palette_visibility(self):
        def luminance(color):
            channels = [int(color[i : i + 2], 16) / 255 for i in (0, 2, 4)]
            linear = [
                value / 12.92 if value <= 0.04045 else ((value + 0.055) / 1.055) ** 2.4
                for value in channels
            ]
            return sum(
                value * weight
                for value, weight in zip(linear, (0.2126, 0.7152, 0.0722))
            )

        for name in (
            "solarized-dark-soft",
            "ibm-sga-soft",
            "commodore-64-soft",
            "everforest-dark-hard",
            "gruvbox-material-dark-hard",
        ):
            text = (ROOT / "palettes" / name / "ghostty").read_text()
            palette = re.findall(r"palette = \d+=#([0-9a-f]{6})", text)
            levels = [luminance(color) for color in palette]
            with self.subTest(palette=name):
                for index in range(1, 8):
                    with self.subTest(slot=index):
                        self.assertGreaterEqual(
                            (levels[index] + 0.05) / (levels[0] + 0.05), 4.5
                        )
                        self.assertGreater(levels[index + 8], levels[index])
                self.assertGreaterEqual(
                    (levels[8] + 0.05) / (levels[0] + 0.05), 4.0
                )
                if name in ("ibm-sga-soft", "commodore-64-soft"):
                    for color in palette[1:7] + palette[9:15]:
                        channels = [int(color[i : i + 2], 16) / 255 for i in (0, 2, 4)]
                        self.assertLessEqual(colorsys.rgb_to_hls(*channels)[2], 0.55)
                if name.endswith("-hard"):
                    base = ROOT / "palettes" / name.removesuffix("-hard") / "ghostty"
                    base_palette = re.findall(
                        r"palette = \d+=#([0-9a-f]{6})", base.read_text()
                    )
                    base_levels = [luminance(color) for color in base_palette]
                    self.assertLess(levels[0], base_levels[0])
                    for index in range(1, 16):
                        self.assertGreater(
                            (levels[index] + 0.05) / (levels[0] + 0.05),
                            (base_levels[index] + 0.05) / (base_levels[0] + 0.05),
                        )

    @unittest.skipIf(os.name == "nt", "Unix links require a Unix host.")
    def test_switch_prepare_and_reverse_links(self):
        before = {
            path: hashlib.sha256(path.read_bytes()).digest()
            for path in (ROOT / "palettes").rglob("*")
            if path.is_file()
        }
        listing = self.run_palette("list")
        self.assertIn("* charcoal-pastel", listing)
        self.assertEqual({line[2:] for line in listing.splitlines()}, set(EXPECTED))
        self.assertFalse(self.state.exists())
        self.run_palette("prepare")
        ghostty = self.state / "ghostty/themes/custom"
        self.assertEqual(
            ghostty.read_bytes(), (ROOT / "palettes/charcoal-pastel/ghostty").read_bytes()
        )
        for name in EXPECTED:
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
    def test_select_after_palette_removal(self):
        self.run_palette("prepare")
        (self.state / "selection").write_text("removed-palette\n")
        active = self.state / "active"
        active.unlink()
        active.symlink_to(ROOT / "palettes/removed-palette", target_is_directory=True)
        self.run_palette("use", "ibm-sga-soft")
        self.assertEqual(self.run_palette("current").strip(), "ibm-sga-soft")
        self.assertEqual(active.resolve(), ROOT / "palettes/ibm-sga-soft")

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
foreach ($name in (Get-ChildItem -LiteralPath (Join-Path $root 'palettes') -Directory).Name) {
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
