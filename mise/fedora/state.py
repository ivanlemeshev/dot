#!/usr/bin/env python3

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import uuid

ROOT = Path(__file__).resolve().parent
STATE = Path.home() / '.local/state/dotfiles-fedora'
PROFILE = Path.home() / '.local/share/konsole'
LINKS = {'dot.profile': ROOT / 'konsole/dot.profile', 'custom.colorscheme': ROOT / 'konsole/custom.colorscheme'}
UNSET = '__DOTFILES_UNSET__'


def save(value):
    STATE.mkdir(parents=True, exist_ok=True)
    temporary = STATE / 'state.tmp'
    temporary.write_text(json.dumps(value, indent=2) + '\n')
    temporary.replace(STATE / 'state.json')


def load():
    path = STATE / 'state.json'
    return json.loads(path.read_text()) if path.exists() else {'links': [], 'preferences': []}


def read(file, group, key):
    return subprocess.check_output(['kreadconfig6', '--file', file, '--group', group, '--key', key, '--default', UNSET], text=True).strip()


def write(file, group, key, value):
    args = ['kwriteconfig6', '--file', file, '--group', group, '--key', key]
    if value == UNSET:
        args.append('--delete')
    else:
        args.append(value)
    subprocess.run(args, check=True)
    if read(file, group, key) != value:
        raise RuntimeError(f'KDE does not apply {file}/{group}/{key}.')


def set_preference(state, file, group, key, value):
    previous = read(file, group, key)
    if previous == value:
        return
    if not any((record['file'], record['group'], record['key']) == (file, group, key) for record in state['preferences']):
        state['preferences'].append({'file': file, 'group': group, 'key': key, 'previous': previous, 'applied': value})
        save(state)
    write(file, group, key, value)


def deploy(state):
    PROFILE.mkdir(parents=True, exist_ok=True)
    for name, source in LINKS.items():
        target = PROFILE / name
        record = next((entry for entry in state['links'] if entry['target'] == str(target)), None)
        if target.is_symlink() and target.resolve() == source:
            continue
        if record is not None:
            backup = Path(record['backup']) if record['backup'] else None
            if target.exists() or target.is_symlink():
                if backup is None or backup.exists() or backup.is_symlink():
                    raise RuntimeError(f'The Konsole link changes after setup: {target}')
                shutil.move(str(target), backup)
            target.symlink_to(source)
            continue
        backup = None
        if target.exists() or target.is_symlink():
            backup = STATE / 'backups' / uuid.uuid4().hex
            backup.parent.mkdir(parents=True, exist_ok=True)
        record = {'target': str(target), 'source': str(source), 'backup': str(backup) if backup else None}
        state['links'].append(record)
        save(state)
        if backup:
            shutil.move(str(target), backup)
            print(f'Backup: {target} -> {backup}', flush=True)
        target.symlink_to(source)


def reload_keyboard():
    if os.environ.get('DBUS_SESSION_BUS_ADDRESS'):
        result = subprocess.run(['dbus-send', '--session', '--type=signal', '/Layouts', 'org.kde.KeyboardLayouts.reloadConfig'], capture_output=True)
        if result.returncode == 0:
            return
    print('Log out and back in to apply the keyboard settings.')


def keyboard_options():
    value = read('kxkbrc', 'Layout', 'Options')
    options = [] if value == UNSET else value.split(',')
    return [option for option in options if option]


def conflicts(option):
    return option.startswith('caps:') or (option.startswith('ctrl:') and 'caps' in option)


def apply():
    state = load()
    deploy(state)
    options = [option for option in keyboard_options() if not conflicts(option)] + ['ctrl:nocaps']
    set_preference(state, 'kxkbrc', 'Layout', 'Options', ','.join(options))
    set_preference(state, 'kxkbrc', 'Layout', 'Use', 'true')
    set_preference(state, 'kxkbrc', 'Layout', 'ResetOldOptions', 'true')
    set_preference(state, 'plasmakeyboardrc', 'General', 'diacriticsPopupEnabled', 'false')
    set_preference(state, 'konsolerc', 'Desktop Entry', 'DefaultProfile', 'dot.profile')
    reload_keyboard()
    verify()


def verify():
    for name, source in LINKS.items():
        target = PROFILE / name
        if not target.is_symlink() or target.resolve() != source:
            raise RuntimeError(f'The Konsole link is missing or differs: {target}')
    options = keyboard_options()
    if options.count('ctrl:nocaps') != 1 or any(conflicts(option) and option != 'ctrl:nocaps' for option in options):
        raise RuntimeError('Caps Lock does not map to Ctrl in KDE.')
    for file, group, key, value in [
        ('kxkbrc', 'Layout', 'Use', 'true'),
        ('kxkbrc', 'Layout', 'ResetOldOptions', 'true'),
        ('plasmakeyboardrc', 'General', 'diacriticsPopupEnabled', 'false'),
        ('konsolerc', 'Desktop Entry', 'DefaultProfile', 'dot.profile'),
    ]:
        if read(file, group, key) != value:
            raise RuntimeError(f'The KDE preference differs: {file}/{group}/{key}')


def unapply():
    state = load()
    for record in state['preferences']:
        current = read(record['file'], record['group'], record['key'])
        if current not in (record['applied'], record['previous']):
            raise RuntimeError(f"A KDE preference changes after setup: {record['file']}/{record['key']}. Review {STATE}/state.json.")
    for record in list(state['links']):
        target = Path(record['target'])
        if target.is_symlink() and target.resolve() == Path(record['source']):
            target.unlink()
        elif target.exists() or target.is_symlink():
            raise RuntimeError(f'The Konsole link changes after setup: {target}')
        if record['backup']:
            backup = Path(record['backup'])
            if backup.exists() or backup.is_symlink():
                shutil.move(str(backup), target)
        state['links'].remove(record)
        save(state)
    for record in reversed(list(state['preferences'])):
        write(record['file'], record['group'], record['key'], record['previous'])
        state['preferences'].remove(record)
        save(state)
    (STATE / 'state.json').unlink(missing_ok=True)
    reload_keyboard()


def main():
    if sys.platform != 'linux' or 'fedora' != dict(line.split('=', 1) for line in Path('/etc/os-release').read_text().splitlines() if '=' in line).get('ID', '').strip('"'):
        raise RuntimeError('This adapter requires Fedora KDE.')
    for command in ('konsole', 'kwriteconfig6', 'kreadconfig6', 'dbus-send'):
        if shutil.which(command) is None:
            raise RuntimeError(f'Required Fedora KDE command is missing: {command}')
    actions = {'apply': apply, 'verify': verify, 'unapply': unapply}
    actions[sys.argv[1]]()


if __name__ == '__main__':
    main()
