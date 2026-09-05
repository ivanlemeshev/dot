# Provide staged updates and managed-state rollback in a fresh VM

Type: task
Status: ready-for-agent

**What to build:** A user can review, confirm, apply, verify, report, and roll back managed Dotfiles v2 updates on a fresh VM. Package downgrades remain manual.

**Blocked by:** 26: Verify Bootstrap state and safe reruns in a fresh VM.

- [ ] Provide one staged Update command with pauses before every change stage.
- [ ] Record prior managed state and restore it after an update failure.
- [ ] Produce a timestamped local report with revision, manifest, package, verification, and rollback information.
- [ ] Add command behavior tests and pass the fresh-VM check with retained evidence.
