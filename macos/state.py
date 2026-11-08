#!/usr/bin/env python3

import json
import os
from pathlib import Path
import plistlib
import re
import shutil
import subprocess
import sys
import uuid

STATE = Path.home() / '.local/state/dotfiles-macos'
CAPS = 0x700000039
CONTROL = 0x7000000E0
SRC = 'HIDKeyboardModifierMappingSrc'
DST = 'HIDKeyboardModifierMappingDst'
PREFERENCES = {'LoadPrefsFromCustomFolder': False, 'Default Bookmark Guid': 'b2f196a0-9822-4f69-8ce9-73f2de6b4371'}


def run(*args):
    return subprocess.check_output(args, text=True).strip()


def save(name, value):
    STATE.mkdir(parents=True, exist_ok=True)
    path = STATE / name
    temporary = path.with_suffix('.tmp')
    temporary.write_text(json.dumps(value, indent=2) + '\n')
    temporary.replace(path)


def load(name, default):
    path = STATE / name
    return json.loads(path.read_text()) if path.exists() else default


def backup(target, directory=False):
    records = load('links.json', [])
    if any(record['target'] == str(target) for record in records):
        raise RuntimeError(f'A previous backup exists for {target}. Review {STATE}/links.json.')
    destination = STATE / 'backups' / uuid.uuid4().hex
    destination.parent.mkdir(parents=True, exist_ok=True)
    records.append({'target': str(target), 'backup': str(destination), 'directory': directory})
    save('links.json', records)
    shutil.move(str(target), destination)
    print(f'Backup: {target} -> {destination}', flush=True)


def prepare():
    profiles = Path.home() / 'Library/Application Support/iTerm2/DynamicProfiles'
    if profiles.is_symlink():
        if profiles.exists() and any(path.name not in ('custom.json', 'TomorrowNight.json') for path in profiles.iterdir()):
            raise RuntimeError('Move the iTerm2 DynamicProfiles directory link before setup. It contains other profiles.')
        backup(profiles, directory=True)
        profiles.mkdir()
    status = json.loads(run('mise', 'dot', 'status', '--json'))
    if any(entry['state'] == 'source_missing' for entry in status['files']):
        raise RuntimeError('A managed configuration source is missing.')
    for entry in status['files']:
        if entry['state'] == 'differs':
            if entry['mode'] != 'symlink':
                raise RuntimeError(f"Unexpected file mode: {entry['mode']}")
            backup(Path(entry['target']).expanduser())


def mappings():
    output = run('/usr/bin/hidutil', 'property', '--get', 'UserKeyMapping')
    if output in ('(null)', 'null', ''):
        return []
    result = subprocess.run(['/usr/bin/plutil', '-convert', 'json', '-o', '-', '-'], input=output, text=True, capture_output=True, check=True)
    values = json.loads(result.stdout)
    if not isinstance(values, list):
        raise RuntimeError('The keyboard map is not an array.')
    return [{key: int(value, 0) if isinstance(value, str) else value for key, value in mapping.items()} for mapping in values]


def set_mappings(values):
    run('/usr/bin/hidutil', 'property', '--set', json.dumps({'UserKeyMapping': values}))
    if mappings() != values:
        raise RuntimeError('The keyboard map does not match the requested map.')


def keyboard(action):
    current = mappings()
    previous_caps = [mapping for mapping in current if mapping[SRC] == CAPS]
    desired = [{SRC: CAPS, DST: CONTROL}]
    if action == 'verify':
        if previous_caps != desired:
            raise RuntimeError('Caps Lock does not map to Ctrl.')
    elif action == 'apply':
        if previous_caps != desired:
            if not (STATE / 'keyboard.json').exists():
                save('keyboard.json', previous_caps)
            set_mappings([mapping for mapping in current if mapping[SRC] != CAPS] + desired)
    elif action == 'restore' and (STATE / 'keyboard.json').exists():
        if previous_caps != desired:
            raise RuntimeError('The Caps Lock map changes after setup. Review keyboard.json before restoration.')
        set_mappings([mapping for mapping in current if mapping[SRC] != CAPS] + load('keyboard.json', []))
        (STATE / 'keyboard.json').unlink()


def preferences(restore=False):
    domain = 'com.googlecode.iterm2'
    exported = subprocess.run(['defaults', 'export', domain, '-'], capture_output=True)
    current = plistlib.loads(exported.stdout) if exported.returncode == 0 else {}
    if restore:
        previous = load('iterm2.json', None)
        if previous is None:
            return
        for key, value in PREFERENCES.items():
            if current.get(key) != value:
                raise RuntimeError(f'iTerm2 changes after setup: {key}')
        for key, value in previous.items():
            if value is None:
                run('defaults', 'delete', domain, key)
            else:
                kind = '-bool' if isinstance(value, bool) else '-string'
                run('defaults', 'write', domain, key, kind, str(value).lower() if isinstance(value, bool) else str(value))
        (STATE / 'iterm2.json').unlink()
    else:
        if not (STATE / 'iterm2.json').exists():
            save('iterm2.json', {key: current.get(key) for key in PREFERENCES})
        for key, value in PREFERENCES.items():
            kind = '-bool' if isinstance(value, bool) else '-string'
            run('defaults', 'write', domain, key, kind, str(value).lower() if isinstance(value, bool) else value)


def restore_links():
    for record in reversed(load('links.json', [])):
        source, target = Path(record['backup']), Path(record['target'])
        if not source.exists() and not source.is_symlink():
            continue
        if record['directory'] and target.is_dir() and not target.is_symlink():
            target.rmdir()
        if target.exists() or target.is_symlink():
            raise RuntimeError(f'The restore target exists: {target}')
        shutil.move(str(source), target)
    (STATE / 'links.json').unlink(missing_ok=True)


def versions(upgrade=False):
    requirements = [('nvim', 'neovim', (0, 12, 0)), ('tree-sitter', 'tree-sitter-cli', (0, 26, 1))]
    for command, package, minimum in requirements:
        def valid():
            match = re.search(r'(\d+)\.(\d+)\.(\d+)', run(command, '--version'))
            return match is not None and tuple(map(int, match.groups())) >= minimum
        if not valid():
            if upgrade:
                subprocess.run(['brew', 'upgrade', package], check=True)
            if not valid():
                raise RuntimeError(f'{command} requires version {".".join(map(str, minimum))} or later.')
    if 'GH_ACCESSIBLE_COLORS' not in run('gh', 'help', 'environment'):
        if upgrade:
            subprocess.run(['brew', 'upgrade', 'gh'], check=True)
        if 'GH_ACCESSIBLE_COLORS' not in run('gh', 'help', 'environment'):
            raise RuntimeError('GitHub CLI does not support accessible colors.')


def main():
    if sys.platform != 'darwin':
        raise RuntimeError('This adapter requires macOS.')
    action = sys.argv[1]
    if action == 'prepare':
        prepare()
    elif action in ('apply', 'verify', 'restore'):
        keyboard(action)
    elif action in ('versions', 'verify-versions'):
        versions(upgrade=action == 'versions')
    elif action == 'preferences':
        preferences()
    elif action == 'unapply':
        label = f'gui/{os.getuid()}/com.dotfiles.caps-lock'
        if subprocess.run(['launchctl', 'print', label], capture_output=True).returncode == 0:
            subprocess.run(['launchctl', 'bootout', label], check=True)
        keyboard('restore')
        preferences(restore=True)
        subprocess.run(['mise', 'dot', 'unapply', '--yes'], check=True)
        restore_links()
    else:
        raise RuntimeError(f'Unknown action: {action}')


if __name__ == '__main__':
    main()
