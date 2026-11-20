import contextlib
import io
import plistlib
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from scripts import check_data


class DataCheckTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="dot-checks-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

    def run_check(self, mode, path):
        output = io.StringIO()
        with (
            patch.object(check_data, "ROOT", self.root),
            patch.object(check_data, "files", return_value=[path]),
            patch("sys.argv", ["check_data.py", mode]),
            contextlib.redirect_stdout(output),
            contextlib.redirect_stderr(output),
        ):
            result = check_data.main()
        return result, output.getvalue()

    def test_reject_invalid_structured_files(self):
        for name, content in (
            ("settings.json", '{"key": 1, "key": 2}\n'),
            ("settings.colorscheme", "[Color0]\nColor=0,0,0\nColor=1,1,1\n"),
            ("settings.plist", "<plist><dict></plist>\n"),
        ):
            with self.subTest(name=name):
                path = self.root / name
                path.write_text(content)
                result, output = self.run_check("lint", path)
                self.assertEqual(result, 1)
                self.assertIn(name, output)
                self.assertEqual(path.read_text(), content)

    def test_check_preserves_unformatted_plist(self):
        path = self.root / "settings.plist"
        original = b'<plist version="1.0"><dict><key>Label</key><string>test</string></dict></plist>\n'
        path.write_bytes(original)
        result, output = self.run_check("format:check", path)
        self.assertEqual(result, 1)
        self.assertIn("Formatting differs", output)
        self.assertEqual(path.read_bytes(), original)

    def test_plist_format_preserves_values_and_is_idempotent(self):
        path = self.root / "settings.plist"
        value = {
            "Command": "first\n    second",
            "Arguments": ["a", "b"],
            "Enabled": True,
        }
        path.write_bytes(plistlib.dumps(value, sort_keys=False).replace(b"\n", b"\r\n"))
        self.assertEqual(self.run_check("format", path)[0], 0)
        formatted = path.read_bytes()
        self.assertEqual(plistlib.loads(formatted), value)
        self.assertNotIn(b"\r", formatted)
        self.assertEqual(self.run_check("format:check", path)[0], 0)
        self.assertEqual(self.run_check("format", path)[0], 0)
        self.assertEqual(path.read_bytes(), formatted)

    def test_native_text_line_endings(self):
        path = self.root / "settings.conf"
        path.write_bytes(b'set -g status-left "text "\r\n')
        self.assertEqual(self.run_check("lint", path)[0], 1)
        self.assertEqual(self.run_check("format", path)[0], 0)
        self.assertEqual(path.read_bytes(), b'set -g status-left "text "\n')
        self.assertEqual(self.run_check("lint", path)[0], 0)
