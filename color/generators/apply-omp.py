#!/usr/bin/env python3

import json
import os
import re
import sys
import tempfile

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} <color-scheme.yaml> <theme.omp.json>", file=sys.stderr)
    sys.exit(1)

yaml_file = sys.argv[1]
omp_file = sys.argv[2]

OMP_KEYS = {
    "foreground",
    "time",
    "user",
    "host",
    "root",
    "git_clean",
    "git_dirty",
    "git_ahead",
    "git_behind",
    "duration",
    "status_ok",
    "status_error",
    "prompt",
}

TEMPLATE = r'''{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        {
          "foreground": "__time__",
          "options": {
            "time_format": "15:04:05"
          },
          "style": "plain",
          "template": "{{ .CurrentDate | date .Format }}  ",
          "type": "time"
        },
        {
          "foreground": "__foreground__",
          "style": "plain",
          "template": "{{ if ne .Env.POSH_SESSION_DEFAULT_USER .UserName }}<__user__>{{ .UserName }}</><__foreground__>@</></>{{ end }}<__host__>{{ .HostName }}</>  ",
          "type": "session"
        },
        {
          "foreground": "__root__",
          "style": "plain",
          "template": "󱐋  ",
          "type": "root"
        },
        {
          "foreground": "__foreground__",
          "options": {
            "style": "folder"
          },
          "style": "plain",
          "template": "{{ .Path }}  ",
          "type": "path"
        },
        {
          "foreground": "__git_clean__",
          "foreground_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}__git_dirty__{{ end }}",
            "{{ if gt .Ahead 0 }}__git_ahead__{{ end }}",
            "{{ if gt .Behind 0 }}__git_behind__{{ end }}"
          ],
          "options": {
            "branch_icon": "",
            "fetch_status": true,
            "fetch_upstream_icon": false
          },
          "style": "plain",
          "template": "git({{ .HEAD }}){{ if .Working.Changed }}<__git_behind__> {{ .Working.String }}</>{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }}{{ end }}{{ if .Staging.Changed }}<__git_clean__> {{ .Staging.String }}</>{{ end }}{{ if gt .StashCount 0 }} [{{ .StashCount }}] {{ end }}  ",
          "type": "git"
        },
        {
          "foreground": "__duration__",
          "options": {
            "style": "roundrock",
            "threshold": 500
          },
          "style": "plain",
          "template": "{{ .FormattedMs }}  ",
          "type": "executiontime"
        },
        {
          "foreground": "__status_ok__",
          "foreground_templates": [
            "{{ if gt .Code 0 }}__status_error__{{ end }}"
          ],
          "options": {
            "always_enabled": false
          },
          "style": "plain",
          "template": "{{ if gt .Code 0 }}exit({{ .Code }})  {{ end }}",
          "type": "status"
        }
      ],
      "type": "prompt"
    },
    {
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "foreground": "__foreground__",
          "style": "plain",
          "template": "<__prompt__>$</>",
          "type": "text"
        }
      ],
      "type": "prompt"
    }
  ],
  "console_title_template": "{{if .Root}}root :: {{end}}{{.Shell}} :: {{.Folder}}",
  "final_space": true,
  "version": 4
}'''


def normalize_hex(value):
    return "#" + value.lstrip("#").lower()


def parse_omp(path):
    values = {}
    active_section = False
    key_pattern = re.compile(
        r'^\s{2}(?:"([^"]+)"|([\w_+]+)):\s+(?:"?(#[0-9a-fA-F]{6})"?)(?:\s+#.*)?\s*$'
    )

    with open(path, encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped == "omp:":
                active_section = True
                continue
            if active_section:
                if line and not line.startswith("  "):
                    break
                match = key_pattern.match(line)
                if match:
                    key = match.group(1) or match.group(2)
                    values[key] = normalize_hex(match.group(3))

    if not values:
        raise ValueError("Omp section is required in YAML")

    missing = sorted(OMP_KEYS - set(values.keys()))
    if missing:
        raise ValueError("Omp is missing required keys: " + ", ".join(missing))

    return values


try:
    omp = parse_omp(yaml_file)
except ValueError as exc:
    print(str(exc), file=sys.stderr)
    sys.exit(1)

merged = {
    "foreground": omp["foreground"],
    "time": omp["time"],
    "user": omp["user"],
    "host": omp["host"],
    "root": omp["root"],
    "git_clean": omp["git_clean"],
    "git_dirty": omp["git_dirty"],
    "git_ahead": omp["git_ahead"],
    "git_behind": omp["git_behind"],
    "duration": omp["duration"],
    "status_ok": omp["status_ok"],
    "status_error": omp["status_error"],
    "prompt": omp["prompt"],
}

content = TEMPLATE
for name, hex_val in merged.items():
    content = content.replace(f"__{name}__", hex_val)

data = json.loads(content)

dir_ = os.path.dirname(os.path.abspath(omp_file))
with tempfile.NamedTemporaryFile(
    mode="w", dir=dir_, delete=False, suffix=".tmp", encoding="utf-8"
) as tmp:
    tmp_path = tmp.name
    json.dump(data, tmp, indent=2, ensure_ascii=False)
    tmp.write("\n")
os.replace(tmp_path, omp_file)
print(f"Updated {omp_file}")
