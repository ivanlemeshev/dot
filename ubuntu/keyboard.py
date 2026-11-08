#!/usr/bin/env python3

import ast
import json
import os
from pathlib import Path
import subprocess
import sys

SCHEMA = 'org.gnome.desktop.input-sources'
KEY = 'xkb-options'
STATE = Path.home() / '.local/state/dotfiles-ubuntu/keyboard.json'


def host_keyboard():
    release = Path('/proc/sys/kernel/osrelease').read_text().lower()
    return bool(os.environ.get('WSL_DISTRO_NAME') or 'microsoft' in release or os.environ.get('container') or Path('/.dockerenv').exists() or Path('/run/.containerenv').exists())


def read():
    value = subprocess.check_output(['gsettings', 'get', SCHEMA, KEY], text=True).strip()
    return ast.literal_eval(value.removeprefix('@as '))


def write(value):
    subprocess.run(['gsettings', 'set', SCHEMA, KEY, repr(value)], check=True)
    if read() != value:
        raise RuntimeError('GNOME does not apply the requested keyboard options.')


def conflicts(option):
    return option.startswith('caps:') or (option.startswith('ctrl:') and 'caps' in option)


def main():
    action = sys.argv[1]
    if host_keyboard():
        print('WSL and containers use the host keyboard mapping.')
        return
    desktop = os.environ.get('XDG_CURRENT_DESKTOP', '').lower()
    if not desktop and not STATE.exists():
        print('No desktop session is active. Run configure:desktop from the Ubuntu desktop session.')
        return
    if not os.environ.get('DBUS_SESSION_BUS_ADDRESS') or ('gnome' not in desktop and 'ubuntu' not in desktop):
        raise RuntimeError('Run this task in the Ubuntu GNOME desktop session.')
    current = read()
    if action == 'apply':
        desired = [option for option in current if not conflicts(option)] + ['ctrl:nocaps']
        if desired == current:
            return
        if STATE.exists():
            record = json.loads(STATE.read_text())
            if current not in (record['previous'], record['applied']):
                raise RuntimeError('Keyboard options change after setup. Review keyboard.json.')
        else:
            STATE.parent.mkdir(parents=True, exist_ok=True)
            STATE.write_text(json.dumps({'previous': current, 'applied': desired}) + '\n')
        write(desired)
    elif action == 'verify':
        if current.count('ctrl:nocaps') != 1 or any(conflicts(option) and option != 'ctrl:nocaps' for option in current):
            raise RuntimeError('Caps Lock does not map to Ctrl in GNOME.')
    elif action == 'unapply' and STATE.exists():
        record = json.loads(STATE.read_text())
        if current not in (record['previous'], record['applied']):
            raise RuntimeError('Keyboard options change after setup. Review keyboard.json.')
        write(record['previous'])
        STATE.unlink()


if __name__ == '__main__':
    main()
