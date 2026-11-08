#!/usr/bin/env python3

import argparse
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import tempfile
import tomllib

ROOT = Path(__file__).resolve().parent
SETTING_NAMES = {
    'TIMEZONE', 'WINDOWS_TIMEZONE', 'MACHINE_NAME', 'GIT_USER_NAME',
    'GIT_USER_EMAIL', 'GIT_DEFAULT_BRANCH', 'KDE_TERMINAL_FONT',
}


def import_settings(args):
    source = args.source.expanduser()
    destination = args.output.expanduser()
    if source.resolve() == destination.resolve():
        raise ValueError('The source and destination must differ.')
    if destination.is_symlink():
        raise ValueError('The local settings file must not be a symlink.')
    text = destination.read_text() if destination.exists() else ''
    existing = tomllib.loads(text).get('env', {})
    values = {}
    for number, line in enumerate(source.read_text().splitlines(), 1):
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        match = re.fullmatch(r'\s*(?:export\s+)?([A-Z_][A-Z_0-9]*)\s*=(.*)', line)
        if match is None:
            raise ValueError(f'Unsupported assignment on line {number}.')
        name, value = match.groups()
        if name not in SETTING_NAMES:
            raise ValueError(f'Unsupported setting on line {number}: {name}')
        if any(character in value for character in ('$', '`', '\x00')):
            raise ValueError(f'Shell expansion is not supported on line {number}.')
        tokens = shlex.split(value, comments=True, posix=True)
        if len(tokens) > 1:
            raise ValueError(f'Quote the value on line {number}.')
        values[name] = tokens[0] if tokens else ''
    selected = {key: value for key, value in values.items() if key not in existing}
    if not selected:
        print('No new settings to import.')
        return
    for key in selected:
        print(f'Import setting: {key}')
    if args.dry_run:
        return
    additions = '\n'.join(f'{key} = {json.dumps(value, ensure_ascii=False)}' for key, value in selected.items())
    header = re.search(r'^\[env\][ \t]*(?:#[^\n]*)?$', text, flags=re.MULTILINE)
    if header:
        result = text[:header.end()] + '\n' + additions + text[header.end():]
    else:
        result = text.rstrip() + '\n\n[env]\n' + additions + '\n'
    if not result.endswith('\n'):
        result += '\n'
    tomllib.loads(result)
    destination.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary = tempfile.mkstemp(prefix='.settings-', dir=destination.parent)
    try:
        with os.fdopen(descriptor, 'w', encoding='utf-8', newline='\n') as handle:
            handle.write(result)
        os.replace(temporary, destination)
    finally:
        Path(temporary).unlink(missing_ok=True)
    print('Local settings import completes. Existing values stay unchanged.')


def reset_nvim(args):
    home = Path.home()
    if os.name == 'nt':
        local = Path(os.environ['LOCALAPPDATA'])
        paths = [local / 'nvim', local / 'nvim-data']
    else:
        paths = [Path(os.environ.get(variable, home / fallback)) / 'nvim' for variable, fallback in (
            ('XDG_CONFIG_HOME', '.config'), ('XDG_DATA_HOME', '.local/share'),
            ('XDG_STATE_HOME', '.local/state'), ('XDG_CACHE_HOME', '.cache'),
        )]
    for path in paths:
        if path.name not in ('nvim', 'nvim-data') or (not path.is_symlink() and (path.resolve().is_relative_to(ROOT) or ROOT.is_relative_to(path.resolve()))):
            raise ValueError(f'The reset path contains the setup source: {path}')
        print(f'Reset path: {path}')
    if args.dry_run:
        return
    if not args.yes:
        raise ValueError('Review --dry-run, then pass --yes to remove these paths.')
    for path in paths:
        if path.is_symlink() or path.is_file():
            path.unlink()
        elif path.exists():
            shutil.rmtree(path)
    print('Neovim reset completes. Run bootstrap to restore the configuration link.')


def set_git_user(args):
    repository = args.repo.expanduser().resolve()
    subprocess.run(['git', '-C', str(repository), 'rev-parse', '--git-dir'], check=True, stdout=subprocess.DEVNULL)
    name = args.name if args.name is not None else input('Git user name: ')
    email = args.email if args.email is not None else input('Git user email: ')
    if not name.strip() or not email.strip() or any(c in name + email for c in '\r\n\x00'):
        raise ValueError('Git name and email must contain nonempty single-line values.')
    for key, value in [('user.name', name), ('user.email', email)]:
        subprocess.run(['git', '-C', str(repository), 'config', '--local', '--replace-all', key, value], check=True)
    print('Repository Git identity changes. Other settings stay unchanged.')


def main():
    parser = argparse.ArgumentParser()
    commands = parser.add_subparsers(dest='command', required=True)
    importer = commands.add_parser('import-settings')
    importer.add_argument('--source', type=Path, default=ROOT / 'config.env')
    importer.add_argument('--output', type=Path, default=ROOT / 'config.local.toml')
    importer.add_argument('--dry-run', action='store_true')
    importer.set_defaults(action=import_settings)
    reset = commands.add_parser('reset-nvim')
    reset.add_argument('--yes', action='store_true')
    reset.add_argument('--dry-run', action='store_true')
    reset.set_defaults(action=reset_nvim)
    git_user = commands.add_parser('set-git-repo-user')
    git_user.add_argument('--repo', type=Path, required=True)
    git_user.add_argument('--name')
    git_user.add_argument('--email')
    git_user.set_defaults(action=set_git_user)
    args = parser.parse_args()
    try:
        args.action(args)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        parser.exit(1, f'{error}\n')


if __name__ == '__main__':
    main()
