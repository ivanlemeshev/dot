#!/usr/bin/env python3

import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent


def remove_link(path):
    if path.is_junction():
        path.rmdir()
    else:
        path.unlink()


def migrate():
    status = json.loads(subprocess.check_output(['mise', 'dot', 'status', '--json'], text=True))
    if any(entry['state'] == 'source_missing' for entry in status['files']):
        raise RuntimeError('A managed configuration source is missing.')
    for entry in status['files']:
        if entry['mode'] != 'symlink':
            continue
        target = Path(entry['target']).expanduser()
        if not (target.is_symlink() or target.is_junction()):
            continue
        source = Path(entry['origin']['source']).resolve()
        if not source.is_relative_to(ROOT):
            continue
        relative = source.relative_to(ROOT)
        previous = (ROOT / 'mise' / relative, ROOT / '.config' / relative)
        if target.resolve() in previous:
            remove_link(target)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.symlink_to(source, target_is_directory=source.is_dir())
            print(f'Migrate link: {target} -> {source}', flush=True)

    home = Path.home()
    old_roots = (ROOT, home / 'code/dot', home / 'code/github.com/ivanlemeshev/dot')
    candidates = [home / '.codex/skills', home / '.claude/skills/lem', home / '.claude/skills/ub-mode']
    skills = home / '.codex/skills'
    if skills.is_dir() and not skills.is_symlink() and not skills.is_junction():
        candidates.extend(skills / name for name in (
            'lem-review', 'lem-pdf-summary', 'lem-simplify', 'lem-software-design-review',
        ))
    for target in candidates:
        if not (target.is_symlink() or target.is_junction()):
            continue
        relative = target.relative_to(home)
        if target.resolve() in {old / relative for old in old_roots}:
            remove_link(target)
            print(f'Remove legacy skill link: {target}', flush=True)


if __name__ == '__main__':
    migrate()
