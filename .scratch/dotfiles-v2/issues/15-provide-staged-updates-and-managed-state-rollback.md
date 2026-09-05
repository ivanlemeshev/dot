# 15: Provide staged updates and managed-state rollback

Status: wontfix

**What to build:** A user can review, confirm, apply, verify, report, and roll back managed Dotfiles v2 updates. Package downgrades remain manual.

**Blocked by:** 14: Verify Bootstrap state and safe reruns.

- [ ] Provide one staged Update command with pauses before every change stage.
- [ ] Record prior managed state and restore it after an update failure.
- [ ] Produce a timestamped local report with revision, manifest, package, verification, and rollback information.
- [ ] Add behavior tests for cancellation, rollback, report redaction, and manual package-downgrade guidance.

## Comments

Superseded by [Provide staged updates and managed-state rollback in a fresh VM](26-provide-staged-updates-and-managed-state-rollback-in-a-fresh-vm.md).
