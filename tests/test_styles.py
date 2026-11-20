import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class StyleTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="dot-styles-")
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.state = self.directory / ".local/state/dotfiles-palette"
        self.state.mkdir(parents=True)
        self.env = dict(
            os.environ,
            DOTFILES_PALETTE_STATE=str(self.state),
            BAT_CONFIG_DIR=str(ROOT / "bat"),
            BAT_CACHE_PATH=str(self.directory / "bat-cache"),
            BAT_CONFIG_PATH=str(self.state / "style/bat/config"),
            XDG_STATE_HOME=str(self.directory / "xdg-state"),
        )
        self.env.pop("BAT_THEME", None)

    def run_command(self, arguments, env=None, success=True, cwd=None):
        result = subprocess.run(
            arguments,
            cwd=cwd or ROOT,
            env=env or self.env,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result.stdout

    def select(self, name):
        (self.state / "selection").write_text(name + "\n")
        self.run_command(
            [
                "pwsh",
                "-NoProfile",
                "-File",
                str(ROOT / "scripts/palette.ps1"),
                "prepare",
            ]
        )

    @unittest.skipUnless(shutil.which("nvim"), "Neovim is unavailable.")
    def test_neovim_roles_and_round_trip(self):
        script = self.directory / "check.lua"
        script.write_text(
            "vim.opt.runtimepath:prepend(vim.env.STYLE_TEST_ROOT .. '/nvim')\n"
            "local theme = require('lem.theme')\n"
            "theme.setup()\n"
            "local result = { minimal = theme.minimal, icon = theme.icon_color('#ff0000'), highlights = {} }\n"
            "for _, name in ipairs({'Keyword','Number','String','Comment','Function','@function.call','@lsp.type.function','@lsp.typemod.function.declaration','NvimTreeExecFile','Visual','DiagnosticError','GitSignsDelete'}) do\n"
            "  result.highlights[name] = vim.api.nvim_get_hl(0, { name = name, link = false })\n"
            "end\n"
            "io.write(vim.json.encode(result))\n"
        )
        env = dict(self.env, STYLE_TEST_ROOT=str(ROOT))
        results = []
        for name in (
            "charcoal-pastel",
            "min-gruvbox-dark",
            "min-kanagawa-light",
            "charcoal-pastel",
        ):
            self.select(name)
            results.append(
                json.loads(
                    self.run_command(
                        [
                            "nvim",
                            "--headless",
                            "-u",
                            "NONE",
                            "-i",
                            "NONE",
                            "-l",
                            str(script),
                        ],
                        env,
                    )
                )
            )
        self.assertEqual(results[0], results[-1])
        self.assertFalse(results[0]["minimal"])
        for result in results[1:3]:
            self.assertTrue(result["minimal"])
            self.assertEqual(result["icon"], 7)
            for group, color in {
                "Keyword": 7,
                "Number": 7,
                "String": 3,
                "Comment": 6,
                "Function": 1,
                "@function.call": 7,
                "@lsp.type.function": 7,
                "@lsp.typemod.function.declaration": 1,
                "NvimTreeExecFile": 7,
                "DiagnosticError": 9,
                "GitSignsDelete": 1,
            }.items():
                self.assertEqual(result["highlights"][group]["ctermfg"], color, group)
            self.assertEqual(result["highlights"]["Visual"]["ctermfg"], 0)
            self.assertEqual(result["highlights"]["Visual"]["ctermbg"], 4)
            for highlight in result["highlights"].values():
                self.assertNotIn("fg", highlight)
                self.assertNotIn("bg", highlight)

    @unittest.skipUnless(shutil.which("vim"), "Vim is unavailable.")
    def test_vim_minimal_roles(self):
        self.select("min-gruvbox-light")
        output = self.directory / "vim-output"
        script = self.directory / "check.vim"
        script.write_text(
            "execute 'source ' . fnameescape($STYLE_TEST_ROOT . '/vim/.vimrc')\n"
            "call writefile([execute('hi Keyword'), execute('hi Comment'), execute('hi String'), execute('hi Function'), execute('hi Visual')], $STYLE_TEST_OUTPUT)\n"
            "qa!\n"
        )
        self.run_command(
            ["vim", "-Nu", "NONE", "-i", "NONE", "-n", "-es", "-S", str(script)],
            dict(self.env, STYLE_TEST_ROOT=str(ROOT), STYLE_TEST_OUTPUT=str(output)),
        )
        text = output.read_text()
        for group, color in {
            "Keyword": 7,
            "Comment": 6,
            "String": 3,
            "Function": 1,
            "Visual": 0,
        }.items():
            self.assertRegex(text, group + r"[^\n]*ctermfg=" + str(color))
        self.assertIn("ctermbg=4", text)

    @unittest.skipUnless(shutil.which("fish"), "Fish is unavailable.")
    def test_fish_roles_and_round_trip(self):
        script = "\n".join(
            f"source {ROOT}/fish/conf.d/{name}.fish"
            for name in ("fzf_colors", "ls_colors", "zz_custom_theme")
        )
        script += "\n" + "\n".join(
            f"printf '{key}=%s\\n' \"${variable}\""
            for key, variable in {
                "style": "DOTFILES_COLOR_STYLE",
                "keyword": "fish_color_keyword",
                "comment": "fish_color_comment",
                "string": "fish_color_quote",
                "command": "fish_color_command",
                "error": "fish_color_error",
                "selection": "fish_color_selection",
                "files": "LS_COLORS",
                "fzf": "FZF_DEFAULT_OPTS",
            }.items()
        )
        results = []
        for name in ("charcoal-pastel", "min-kanagawa-dark", "charcoal-pastel"):
            self.select(name)
            results.append(
                dict(
                    line.split("=", 1)
                    for line in self.run_command(
                        ["fish", "--no-config", "-c", script]
                    ).splitlines()
                )
            )
        self.assertEqual(results[0], results[-1])
        minimal = results[1]
        self.assertEqual(minimal["style"], "minimal")
        self.assertEqual(minimal["keyword"], "white")
        self.assertEqual(minimal["comment"], "cyan")
        self.assertEqual(minimal["string"], "yellow")
        self.assertEqual(minimal["command"], "white")
        self.assertEqual(minimal["error"], "brred")
        self.assertEqual(minimal["selection"], "black --background=blue")
        self.assertIn("di=0;37", minimal["files"])
        self.assertIn("prompt:7", minimal["fzf"])
        self.assertIn("bg+:4", minimal["fzf"])

    def test_git_and_search_configuration(self):
        results = []
        env = dict(self.env, HOME=str(self.directory), USERPROFILE=str(self.directory))
        for name in ("charcoal-pastel", "min-gruvbox-dark", "charcoal-pastel"):
            self.select(name)
            values = {}
            for key in (
                "color.diff.old",
                "color.diff.new",
                "color.decorate.branch",
                "log.graphColors",
            ):
                values[key] = self.run_command(
                    [
                        "git",
                        "config",
                        "--file",
                        str(ROOT / "git/colors"),
                        "--includes",
                        "--get",
                        key,
                    ],
                    env,
                ).strip()
            values["search"] = (self.state / "style/ripgrep/config").read_text()
            values["bat"] = (self.state / "style/bat/config").read_text()
            results.append(values)
        self.assertEqual(results[0], results[-1])
        self.assertEqual(results[1]["color.diff.old"], "red")
        self.assertEqual(results[1]["color.diff.new"], "green")
        self.assertEqual(results[1]["color.decorate.branch"], "white")
        self.assertEqual(results[1]["log.graphColors"], "white")
        self.assertIn("path:fg:7", results[1]["search"])
        self.assertIn("--theme=custom-minimal", results[1]["bat"])

    def test_mise_style_environment(self):
        config = self.directory / "mise"
        config.mkdir()
        source = (ROOT / "config.toml").read_text()
        variables = source.split("[vars]\n", 1)[1].split("[dotfiles]", 1)[0]
        environment = source.split("[env]\n", 1)[1].split("[task_config]", 1)[0]
        windows = (ROOT / "config.windows.toml").read_text()
        fzf = next(
            line
            for line in windows.splitlines()
            if line.startswith("FZF_DEFAULT_OPTS =")
        )
        (config / "config.toml").write_text(
            "[vars]\n" + variables + "[env]\n" + environment + fzf + "\n"
        )
        env = dict(
            self.env,
            MISE_CONFIG_DIR=str(config),
            MISE_STATE_DIR=str(self.directory / "mise-state"),
            MISE_CACHE_DIR=str(self.directory / "mise-cache"),
            MISE_TRUSTED_CONFIG_PATHS=str(config),
        )
        for name, style in (
            ("charcoal-pastel", "standard"),
            ("min-kanagawa-light", "minimal"),
        ):
            self.select(name)
            values = json.loads(
                self.run_command(["mise", "env", "--json"], env, cwd=self.directory)
            )
            self.assertEqual(values["DOTFILES_COLOR_STYLE"], style)
            self.assertEqual(
                values["BAT_CONFIG_PATH"], str(self.state / "style/bat/config")
            )
            self.assertNotIn("BAT_THEME", values)
            self.assertIn(
                "prompt:" + ("7" if style == "minimal" else "3"),
                values["FZF_DEFAULT_OPTS"],
            )

    @unittest.skipUnless(
        shutil.which("bat") or shutil.which("batcat"), "bat is unavailable."
    )
    def test_bat_minimal_cache_and_ansi_output(self):
        self.select("min-gruvbox-dark")
        bat = shutil.which("bat") or shutil.which("batcat")
        self.run_command([bat, "cache", "--build"])
        sample = self.directory / "sample.py"
        sample.write_text(
            '# note\nif count == 42:\n    text = "hello"\ndef greet():\n    return True\ngreet()\n'
        )
        output = self.run_command(
            [
                bat,
                "--color=always",
                "--paging=never",
                "--style=plain",
                "--language=Python",
                "--italic-text=never",
                str(sample),
            ]
        )
        self.assertRegex(output, r"\x1b\[(?:36|38;5;6)m")
        self.assertRegex(output, r"\x1b\[37mif")
        self.assertRegex(output, r"\x1b\[37m42")
        self.assertRegex(output, r"\x1b\[33mhello")
        self.assertRegex(output, r"\x1b\[31mgreet")
        self.assertRegex(output, r"\x1b\[37mgreet")
        self.assertNotRegex(output, r"\x1b\[[^m]*(?:38|48);2;")
        self.assertIn("custom-minimal", self.run_command([bat, "--list-themes"]))

    def test_powershell_roles_and_round_trip(self):
        script = self.directory / "profile-test.ps1"
        script.write_text(r"""
$ErrorActionPreference = 'Stop'
Import-Module PSReadLine
function Get-Command {
    [CmdletBinding()]
    param([string[]]$Name, [object]$CommandType)
    if ($Name -in @('mise', 'git-wt', 'oh-my-posh')) { return }
    Microsoft.PowerShell.Core\Get-Command @PSBoundParameters
}
function Set-PSReadLineOption {
    [CmdletBinding()]
    param([hashtable]$Colors)
    $script:capturedColors = $Colors
}
. (Join-Path $env:STYLE_TEST_ROOT 'windows/powershell/profile.ps1')
@{
    style = $env:DOTFILES_COLOR_STYLE
    keyword = [string]$capturedColors.Keyword
    number = [string]$capturedColors.Number
    comment = [string]$capturedColors.Comment
    string = [string]$capturedColors.String
    command = [string]$capturedColors.Command
    error = [string]$capturedColors.Error
    selection = $capturedColors.Selection
    directory = $PSStyle.FileInfo.Directory
    files = $env:LS_COLORS
} | ConvertTo-Json -Compress
""")
        env = dict(
            self.env,
            STYLE_TEST_ROOT=str(ROOT),
            LOCALAPPDATA=str(self.directory / "local"),
            USERPROFILE=str(self.directory),
        )
        results = []
        for name in ("charcoal-pastel", "min-kanagawa-light", "charcoal-pastel"):
            self.select(name)
            results.append(
                json.loads(
                    self.run_command(["pwsh", "-NoProfile", "-File", str(script)], env)
                )
            )
        self.assertEqual(results[0], results[-1])
        minimal = results[1]
        self.assertEqual(minimal["style"], "minimal")
        for role in ("keyword", "number"):
            self.assertEqual(minimal[role], "Gray")
        self.assertEqual(minimal["comment"], "DarkCyan")
        self.assertEqual(minimal["string"], "DarkYellow")
        self.assertEqual(minimal["command"], "Gray")
        self.assertEqual(minimal["error"], "Red")
        self.assertEqual(minimal["selection"], "\x1b[30;44m")
        self.assertIn("di=37", minimal["files"])

    @unittest.skipUnless(shutil.which("oh-my-posh"), "Oh My Posh is unavailable.")
    def test_prompt_renders_both_styles(self):
        for style in ("standard", "minimal"):
            env = dict(
                self.env,
                DOTFILES_COLOR_STYLE=style,
                POSH_CACHE_DIR=str(self.directory / "posh-cache"),
                XDG_CACHE_HOME=str(self.directory / "cache"),
            )
            output = self.run_command(
                [
                    "oh-my-posh",
                    "print",
                    "primary",
                    "--config",
                    str(ROOT / "oh-my-posh/theme.omp.json"),
                    "--shell",
                    "bash",
                    "--escape=false",
                    "--pwd",
                    str(self.directory),
                    "--status",
                    "1",
                ],
                env,
                cwd=self.directory,
            )
            self.assertNotIn("invalid template", output.lower())
            self.assertNotIn("error rendering", output.lower())
            self.assertIn("exit(1)", output)
            self.assertRegex(output, r"\x1b\[[^m]*m")

    @unittest.skipUnless(os.name == "nt", "Directory junctions require Windows.")
    def test_windows_style_junction(self):
        script = self.directory / "junction-test.ps1"
        script.write_text(r"""
$ErrorActionPreference = 'Stop'
$style = Join-Path $env:DOTFILES_PALETTE_STATE 'style'
if ((Get-Item -LiteralPath $style).LinkType -ne 'Junction') { throw 'The style junction is missing.' }
Remove-Item -LiteralPath $style -Force
if (-not (Test-Path -LiteralPath (Join-Path $env:STYLE_TEST_ROOT 'config.toml'))) { throw 'Removing the junction changes the source.' }
""")
        for name in ("min-gruvbox-dark", "charcoal-pastel"):
            self.select(name)
            self.run_command(
                ["pwsh", "-NoProfile", "-File", str(script)],
                dict(self.env, STYLE_TEST_ROOT=str(ROOT)),
            )
