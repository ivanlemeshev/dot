# Define the migration and replacement gate

Type: grilling
Status: resolved
Blocked by: 04

## Question

What backup, comparison, acceptance, and rollback conditions must be met before the current dotfiles are replaced by Dotfiles v2 from its separate repository directory?

## Answer

Migration is a manual, user-controlled decision. It has no automatic authorization gate. Before migration, create a timestamped archive outside the active configuration paths. It contains the current dotfiles source and every file that the user will replace. Encryption is not required by this gate.

The user decides when Dotfiles v2 is ready. The decision must have the Fedora virtual-machine acceptance evidence, a reviewed difference list, and a written rollback procedure available. Dotfiles v2 files are applied manually. The migration must not overwrite unmanaged files. Record each intentionally replaced path.

Immediately stop and roll back for a required-tool failure, KDE Plasma usability failure, a security or permission change outside the allow-list, data loss, or an unexpected managed-file change. Restore from the archive and verify the restored state.
