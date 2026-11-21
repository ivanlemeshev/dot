import configparser
import json
import plistlib
import subprocess
import sys
from pathlib import Path
from xml.parsers.expat import ExpatError

ROOT = Path(__file__).resolve().parents[1]


def files():
    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=ROOT,
        check=True,
        capture_output=True,
    )
    return sorted(
        {
            ROOT / name.decode()
            for name in result.stdout.split(b"\0")
            if name and (ROOT / name.decode()).is_file()
        }
    )


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def main():
    mode = sys.argv[1]
    failed = False
    for path in files():
        relative = path.relative_to(ROOT)
        data = path.read_bytes()
        if path.suffix == ".png":
            continue
        try:
            text = data.decode("utf-8")
            formatted = None
            if path.suffix in (".plist", ".tmTheme"):
                value = plistlib.loads(data)
                formatted = plistlib.dumps(value, sort_keys=False)
            elif path.suffix in (".colorscheme", ".profile"):
                parser = configparser.ConfigParser(interpolation=None, strict=True)
                parser.optionxform = str
                parser.read_string(text)
            elif mode == "lint" and path.suffix == ".json":
                json.loads(text, object_pairs_hook=unique_object)
            elif mode == "lint" and relative.as_posix() in ("git/config", "git/colors"):
                subprocess.run(
                    ["git", "config", "--file", str(path), "--no-includes", "--list"],
                    check=True,
                    stdout=subprocess.DEVNULL,
                )
            if mode == "format" and formatted is None:
                formatted = (
                    text.replace("\r\n", "\n").replace("\r", "\n").rstrip("\n") + "\n"
                ).encode("utf-8")
            if mode == "format" and formatted is not None and formatted != data:
                path.write_bytes(formatted)
                print(f"Formatted {relative}")
            elif mode == "format:check" and formatted is not None and formatted != data:
                raise ValueError("Formatting differs")
            if mode != "format" and (b"\r" in data or not data.endswith(b"\n")):
                raise ValueError("Use LF line endings and a final newline")
        except (
            ValueError,
            UnicodeError,
            configparser.Error,
            subprocess.CalledProcessError,
            ExpatError,
        ) as error:
            print(f"{relative}: {error}", file=sys.stderr)
            failed = True
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())
