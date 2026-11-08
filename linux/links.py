#!/usr/bin/env python3

import json
from pathlib import Path
import shutil
import subprocess
import sys
import uuid

STATE = Path.home() / '.local/state/dotfiles-linux'
RECORDS = STATE / 'links.json'


def save(records):
    STATE.mkdir(parents=True, exist_ok=True)
    temporary = STATE / 'links.tmp'
    temporary.write_text(json.dumps(records, indent=2) + '\n')
    temporary.replace(RECORDS)


def prepare():
    records = json.loads(RECORDS.read_text()) if RECORDS.exists() else []
    status = json.loads(subprocess.check_output(['mise', 'dot', 'status', '--json'], text=True))
    if any(entry['state'] == 'source_missing' for entry in status['files']):
        raise RuntimeError('A managed configuration source is missing.')
    for entry in status['files']:
        if entry['state'] != 'differs' or entry['mode'] != 'symlink':
            continue
        target = Path(entry['target']).expanduser()
        if any(record['target'] == str(target) for record in records):
            raise RuntimeError(f'A backup already exists for {target}. Review {RECORDS}.')
        backup = STATE / 'backups' / uuid.uuid4().hex
        backup.parent.mkdir(parents=True, exist_ok=True)
        records.append({'target': str(target), 'backup': str(backup)})
        save(records)
        shutil.move(str(target), backup)
        print(f'Backup: {target} -> {backup}', flush=True)


def restore():
    records = json.loads(RECORDS.read_text()) if RECORDS.exists() else []
    for record in reversed(list(records)):
        target, backup = Path(record['target']), Path(record['backup'])
        if not backup.exists() and not backup.is_symlink():
            raise RuntimeError(f'The configuration backup is missing: {backup}')
        if target.exists() or target.is_symlink():
            raise RuntimeError(f'The restore target exists: {target}')
        shutil.move(str(backup), target)
        records.remove(record)
        save(records)
    RECORDS.unlink(missing_ok=True)


if __name__ == '__main__':
    {'prepare': prepare, 'restore': restore}[sys.argv[1]]()
