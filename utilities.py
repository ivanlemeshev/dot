#!/usr/bin/env python3

import argparse
import os
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent


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
