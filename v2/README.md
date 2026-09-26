# Dotfiles v2

V2 builds a small terminal-first setup from scratch.
It supports macOS, Ubuntu 26.04, Fedora KDE Plasma, Arch, and Windows.
It does not configure desktop UI in the first version.

Chezmoi manages user files.
Native package managers install packages.

Run the automated Linux container checks:

```sh
v2/bin/test
```

Run the checks and open a shell in each container:

```sh
v2/bin/test --interactive
```

Add one or more platform names to inspect only these containers:

```sh
v2/bin/test --interactive ubuntu fedora
```

The command uses Docker when both container engines are installed.
Set `CONTAINER_ENGINE=podman` to use Podman.
Exit each shell to continue to the next container.

The bootstrap shows a short banner when its output is a terminal.
Set `DOTFILES_BANNER=1` to show it without a terminal.
Set `NO_COLOR=1` to remove its color.

- [Requirements](requirements.md)
- [Work plan](work-plan.md)

Use these skills only when needed, in this order:

1. `/grilling`: clarify the next task with one question at a time.
2. `/tdd`: test script behavior before implementation. For simple config edits, check the result directly.
3. `/lem-review`: review the diff before a commit.

Use `/diagnosing-bugs` when something breaks.
Use `/prototype` to try an uncertain approach.
