# Refactoring Plan

## Current Structure

- Config files scattered at root level (config.fish, .tmux.conf, starship.toml,
  .vimrc, etc.)
- Setup scripts at root (setup-macos.sh, setup-ubuntu.sh, setup.ps1)
- Some configs in subdirectories (macos/iterm2, windows/terminal, lazygit/,
  nvim/)
- Install scripts organized by OS (install/macos/, install/ubuntu/)
- Helper functions in scripts/functions/

## Improved Directory Structure

```bash
├── bin
│   ├── setup
│   ├── setup-macos
│   ├── setup-ubuntu
│   └── setup-windows.ps1
├── config
│   ├── common
│   │   ├── git
│   │   │   ├── .gitconfig
│   │   │   └── .gitignore_global
│   │   ├── vim
│   │   │   └── .vimrc
│   │   ├── tmux
│   │   │   └── .tmux.conf
│   │   └── ...
│   ├── macos
│   │   └── iterm2
│   │       └── com.googlecode.iterm2.plist
│   ├── ubuntu
│   │   └── ...
│   └── windows
│       └── terminal
│           └── settings.json
├── lib
│   ├── logging.sh
│   ├── os.sh
│   ├── prompt.sh
│   └── ui.sh
├── doc
│   ├── fish.md
│   ├── ...
│   └── tmux.md
├── install
│   ├── macos
│   │   ├── ...
│   │   ├── bat.sh
│   │   ├── fish.sh
│   │   └── ...
│   └── ubuntu
│       ├── ...
│       ├── bat.sh
│       ├── fish.sh
│       └── ...
└── ...
```

## Step-by-Step Migration Plan

**IMPORTANT:** After each step, test that your dotfiles still work. Don't
proceed to the next step if something breaks.

### Phase 1: Create New Directory Structure (Non-breaking)

#### Step 1.1: Create directories

```bash
mkdir -p bin
mkdir -p lib
mkdir -p config/common/{fish,git,vim,tmux,starship,nvim,lazygit,stylua,prettier,opencode}
mkdir -p config/macos
mkdir -p config/ubuntu
mkdir -p config/windows
```

**Test:** Run `ls -la` to verify directories created **Status:** ✅ No existing
functionality affected

---

### Phase 2: Migrate Library Functions (Low risk)

#### Step 2.1: Move function files to lib/

```bash
cp scripts/functions/print_header.sh lib/ui.sh
cp scripts/functions/prompt_yes_no.sh lib/prompt.sh
cp scripts/functions/prompt_input.sh lib/
```

**Test:** Old scripts still work (they still reference scripts/functions/)
**Status:** ✅ Old and new both exist

#### Step 2.2: Create lib/os.sh (new file)

Create `lib/os.sh` with OS detection utilities:

```bash
#!/bin/bash

detect_os() {
    case "$(uname -s)" in
        Darwin*)  echo "macos" ;;
        Linux*)   echo "linux" ;;
        MINGW*|MSYS*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

get_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}
```

**Test:** Source the file: `source lib/os.sh && detect_os` **Status:** ✅ New
functionality added, nothing broken

#### Step 2.3: Create lib/logging.sh (new file)

Create `lib/logging.sh`:

```bash
#!/bin/bash

log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

log_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}
```

**Test:** Source and test: `source lib/logging.sh && log_info "Test"`
**Status:** ✅ New functionality added

---

### Phase 3: Migrate Config Files (Critical - One at a time)

#### Step 3.1: Migrate vim config

##### 3.1.1: Copy config to new location

```bash
cp .vimrc config/common/vim/.vimrc
```

##### 3.1.2: Test new config works

```bash
vim -u config/common/vim/.vimrc --version  # Should load without errors
```

##### 3.1.3: Update symlink to point to new location

```bash
ln -sf "${PWD}/config/common/vim/.vimrc" "${HOME}/.vimrc"
```

##### 3.1.4: Test vim works

```bash
vim test.txt  # Open vim and ensure it works
```

##### 3.1.5: Once confirmed working, remove old file

```bash
git rm .vimrc  # Old file at root
```

**Status:** ✅ Vim config migrated, tested, working

---

#### Step 3.2: Migrate tmux config

##### 3.2.1: Copy config

```bash
cp .tmux.conf config/common/tmux/.tmux.conf
```

##### 3.2.2: Update symlink

```bash
ln -sf "${PWD}/config/common/tmux/.tmux.conf" "${HOME}/.tmux.conf"
```

##### 3.2.3: Test tmux

```bash
tmux source-file ~/.tmux.conf  # Reload config
tmux new-session -d -s test && tmux kill-session -t test  # Test session
```

##### 3.2.4: Remove old file

```bash
git rm .tmux.conf
```

**Status:** ✅ Tmux config migrated

---

#### Step 3.3: Migrate starship config

##### 3.3.1: Copy config

```bash
cp starship.toml config/common/starship/starship.toml
```

##### 3.3.2: Update symlink

```bash
mkdir -p "${HOME}/.config"
ln -sf "${PWD}/config/common/starship/starship.toml" "${HOME}/.config/starship.toml"
```

##### 3.3.3: Test starship

```bash
starship config  # Should show config path
starship print-config  # Should show config content
```

##### 3.3.4: Remove old file

```bash
git rm starship.toml
```

**Status:** ✅ Starship config migrated

---

#### Step 3.4: Migrate fish config

##### 3.4.1: Copy base config

```bash
cp config.fish config/common/fish/config.fish
```

##### 3.4.2: Add OS detection to common config

Edit `config/common/fish/config.fish` and add at the end:

```fish
# Load OS-specific configuration
set DOTFILES_DIR (dirname (dirname (dirname (status --current-filename))))

switch (uname)
    case Darwin
        if test -f "$DOTFILES_DIR/config/macos/fish/config.fish"
            source "$DOTFILES_DIR/config/macos/fish/config.fish"
        end
    case Linux
        if test -f "$DOTFILES_DIR/config/ubuntu/fish/config.fish"
            source "$DOTFILES_DIR/config/ubuntu/fish/config.fish"
        end
end
```

##### 3.4.3: Create OS-specific fish configs

```bash
# Create empty files for now (populate later with OS-specific settings)
touch config/macos/fish/config.fish
touch config/ubuntu/fish/config.fish
```

##### 3.4.4: Update symlink

```bash
mkdir -p "${HOME}/.config/fish"
ln -sf "${PWD}/config/common/fish/config.fish" "${HOME}/.config/fish/config.fish"
```

##### 3.4.5: Test fish

```bash
fish -c "echo 'Fish config loaded successfully'"
# Open a new fish shell and verify all aliases/functions work
```

##### 3.4.6: Remove old file

```bash
git rm config.fish
```

**Status:** ✅ Fish config migrated with OS-specific support

---

#### Step 3.5: Migrate nvim config

##### 3.5.1: Move nvim directory

```bash
mv nvim config/common/nvim
```

##### 3.5.2: Update symlink

```bash
ln -sf "${PWD}/config/common/nvim" "${HOME}/.config/nvim"
```

##### 3.5.3: Test nvim

```bash
nvim --version
nvim test.txt  # Open and verify plugins work
```

**Status:** ✅ Nvim config migrated

---

#### Step 3.6: Migrate lazygit config

##### 3.6.1: Move lazygit directory

```bash
mv lazygit config/common/lazygit
```

##### 3.6.2: Update symlink

```bash
mkdir -p "${HOME}/.config/lazygit"
ln -sf "${PWD}/config/common/lazygit/config.yml" "${HOME}/.config/lazygit/config.yml"
```

##### 3.6.3: Test lazygit

```bash
lazygit --version
# Open lazygit and verify config loaded
```

**Status:** ✅ Lazygit config migrated

---

#### Step 3.7: Migrate stylua config

##### 3.7.1: Copy config

```bash
cp .stylua.toml config/common/stylua/.stylua.toml
```

##### 3.7.2: Update symlink (if you had one)

```bash
ln -sf "${PWD}/config/common/stylua/.stylua.toml" "${HOME}/.stylua.toml"
```

##### 3.7.3: Test stylua

```bash
stylua --check config/common/nvim/  # Should use the config
```

##### 3.7.4: Remove old file

```bash
git rm .stylua.toml
```

**Status:** ✅ Stylua config migrated

---

#### Step 3.8: Migrate prettier config

##### 3.8.1: Copy config

```bash
cp .prettierrc.yaml config/common/prettier/.prettierrc.yaml
```

##### 3.8.2: Update symlink (if needed)

```bash
ln -sf "${PWD}/config/common/prettier/.prettierrc.yaml" "${HOME}/.prettierrc.yaml"
```

##### 3.8.3: Remove old file

```bash
git rm .prettierrc.yaml
```

**Status:** ✅ Prettier config migrated

---

#### Step 3.9: Migrate opencode config

##### 3.9.1: Copy config

```bash
cp opencode.json config/common/opencode/opencode.json
```

##### 3.9.2: Update symlink

```bash
ln -sf "${PWD}/config/common/opencode/opencode.json" "${HOME}/.opencode.json"
# Or wherever opencode expects the config
```

##### 3.9.3: Remove old file

```bash
git rm opencode.json
```

**Status:** ✅ Opencode config migrated

---

#### Step 3.10: Migrate OS-specific configs

##### 3.10.1: Move macOS configs

```bash
mv macos config/macos/iterm2
```

##### 3.10.2: Move Windows configs

```bash
mv windows config/windows/terminal
```

##### 3.10.3: Test OS-specific configs

- On macOS: Verify iTerm2 can load config from new location
- On Windows: Verify Terminal settings path

**Status:** ✅ OS-specific configs migrated

---

### Phase 4: Update Setup Scripts

#### Step 4.1: Update setup-macos.sh to use new paths

##### 4.1.1: Create backup

```bash
cp setup-macos.sh setup-macos.sh.backup
```

##### 4.1.2: Update symlink paths in setup-macos.sh

Change:

```bash
ln -sf "${PWD}/.vimrc" "${HOME}/.vimrc"
```

To:

```bash
ln -sf "${PWD}/config/common/vim/.vimrc" "${HOME}/.vimrc"
ln -sf "${PWD}/config/common/tmux/.tmux.conf" "${HOME}/.tmux.conf"
ln -sf "${PWD}/config/common/fish/config.fish" "${HOME}/.config/fish/config.fish"
ln -sf "${PWD}/config/common/starship/starship.toml" "${HOME}/.config/starship.toml"
# ... etc for all configs
```

##### 4.1.3: Test setup script (dry-run)

```bash
bash -x setup-macos.sh 2>&1 | grep "ln -sf"  # See what it would do
```

##### 4.1.4: Test on a clean environment or VM

**Status:** ✅ Setup script updated and tested

---

#### Step 4.2: Update setup-ubuntu.sh

##### 4.2.1: Create backup

```bash
cp setup-ubuntu.sh setup-ubuntu.sh.backup
```

##### 4.2.2: Update symlink paths

(same as macOS)

##### 4.2.3: Test setup script

**Status:** ✅ Ubuntu setup script updated

---

#### Step 4.3: Update setup.ps1

##### 4.3.1: Create backup

```bash
cp setup.ps1 setup.ps1.backup
```

##### 4.3.2: Update paths in PowerShell script

##### 4.3.3: Test on Windows

**Status:** ✅ Windows setup script updated

---

### Phase 5: Move Setup Scripts to bin/

#### Step 5.1: Copy setup scripts to bin/ (keep originals for now)

```bash
cp setup-macos.sh bin/setup-macos
cp setup-ubuntu.sh bin/setup-ubuntu
cp setup.ps1 bin/setup-windows.ps1
chmod +x bin/setup-macos bin/setup-ubuntu
```

**Status:** ✅ Scripts copied, originals still work

---

#### Step 5.2: Create main setup entry point

Create `bin/setup`:

```bash
#!/bin/bash
# Main setup script - detects OS and runs appropriate setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

case "$(uname -s)" in
    Darwin*)
        echo "Detected macOS"
        exec ./bin/setup-macos
        ;;
    Linux*)
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                ubuntu)
                    echo "Detected Ubuntu"
                    exec ./bin/setup-ubuntu
                    ;;
                *)
                    echo "Unsupported Linux distribution: $ID"
                    exit 1
                    ;;
            esac
        fi
        ;;
    MINGW*|MSYS*)
        echo "Detected Windows"
        pwsh ./bin/setup-windows.ps1
        ;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac
```

```bash
chmod +x bin/setup
```

**Test:**

```bash
./bin/setup  # Should detect OS and call correct script
```

**Status:** ✅ Main setup entry point created

---

#### Step 5.3: Test new setup scripts from bin/

```bash
# Test the new scripts work
./bin/setup-macos  # or ./bin/setup-ubuntu
```

**Status:** ✅ New scripts tested

---

#### Step 5.4: Update scripts to source lib/ instead of scripts/functions/

##### 5.4.1: Update bin/setup-macos

Change:

```bash
source scripts/functions/print_header.sh
```

To:

```bash
source lib/ui.sh
source lib/prompt.sh
source lib/logging.sh
source lib/os.sh
```

##### 5.4.2: Update bin/setup-ubuntu

(same changes)

##### 5.4.3: Test both scripts

**Status:** ✅ Scripts now use lib/

---

#### Step 5.5: Remove old setup scripts from root (only after everything works)

```bash
# Only after thorough testing!
git rm setup-macos.sh setup-ubuntu.sh setup.ps1
git rm -r scripts/functions/  # Old function files
```

**Status:** ✅ Old setup scripts removed

---

### Phase 6: Update Documentation

#### Step 6.1: Update README.md

Update installation instructions to use `./bin/setup` instead of
`./setup-macos.sh`

**Status:** ✅ README updated

---

#### Step 6.2: Update any documentation in doc/

Update paths in help.md, tips.md to reference new structure

**Status:** ✅ Documentation updated

---

### Phase 7: Final Cleanup

#### Step 7.1: Remove backup files

```bash
rm setup-macos.sh.backup setup-ubuntu.sh.backup setup.ps1.backup
```

**Status:** ✅ Backups removed

---

#### Step 7.2: Update .gitignore if needed

Add any new patterns for generated/temporary files

**Status:** ✅ .gitignore updated

---

#### Step 7.3: Final verification

```bash
# Run the main setup script
./bin/setup

# Verify all configs work:
# - Open vim
# - Open tmux
# - Open fish shell
# - Open nvim
# - Run lazygit
# - Check starship prompt
```

**Status:** ✅ Everything verified working

---

#### Step 7.4: Commit changes

```bash
git add .
git commit -m "Refactor: Reorganize dotfiles structure

- Move setup scripts to bin/
- Organize configs under config/common, config/macos, config/ubuntu
- Move helper functions to lib/
- Update all symlinks to use new paths
- Add main setup entry point with OS detection"
```

**Status:** ✅ Changes committed

---

## Migration Checklist

- [ ] Phase 1: Create directory structure
- [ ] Phase 2: Migrate lib functions
- [ ] Phase 3: Migrate configs (one by one)
  - [ ] vim
  - [ ] tmux
  - [ ] starship
  - [ ] fish (with OS-specific support)
  - [ ] nvim
  - [ ] lazygit
  - [ ] stylua
  - [ ] prettier
  - [ ] opencode
  - [ ] OS-specific configs (macos, windows)
- [ ] Phase 4: Update setup scripts
  - [ ] setup-macos.sh
  - [ ] setup-ubuntu.sh
  - [ ] setup.ps1
- [ ] Phase 5: Move setup scripts to bin/
  - [ ] Copy scripts
  - [ ] Create main entry point
  - [ ] Update lib/ references
  - [ ] Remove old scripts
- [ ] Phase 6: Update documentation
- [ ] Phase 7: Final cleanup and commit

## Rollback Plan

If anything breaks during migration:

1. **Revert symlinks:**

   ```bash
   ln -sf "${PWD}/.vimrc" "${HOME}/.vimrc"  # Point back to old location
   ```

2. **Restore from backup:**

   ```bash
   cp setup-macos.sh.backup setup-macos.sh
   ```

3. **Use git to revert:**

   ```bash
   git checkout -- <file>  # Restore specific file
   git reset --hard HEAD   # Nuclear option: restore everything
   ```

## Testing After Each Phase

After each phase, run this quick test:

```bash
# Quick smoke test
vim --version && echo "✓ Vim works"
tmux -V && echo "✓ Tmux works"
fish -c "echo '✓ Fish works'"
nvim --version && echo "✓ Nvim works"
starship --version && echo "✓ Starship works"
```
