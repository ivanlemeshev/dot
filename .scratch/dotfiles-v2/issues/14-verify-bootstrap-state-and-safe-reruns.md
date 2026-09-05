# 14: Verify Bootstrap state and safe reruns

Status: wontfix

**What to build:** The Bootstrap verifies its result, produces machine-readable evidence, handles network failure clearly, and completes a safe rerun without unexpected managed changes.

**Blocked by:** 11: Apply managed home-directory configuration; 12: Apply Fedora system settings and rootless Docker; 13: Add Local configuration and project environment support.

- [ ] Verify required tools, configuration ownership, hooks, fonts, services, permissions, and allow-listed settings.
- [ ] Record machine-readable results without Local configuration values or secrets.
- [ ] Stop clearly on unavailable network resources and remain safe to rerun after recovery.
- [ ] Add behavior tests for verification failures, evidence redaction, and idempotent reruns.

## Comments

Superseded by [Verify Bootstrap state and safe reruns in a fresh VM](25-verify-bootstrap-state-and-safe-reruns-in-a-fresh-vm.md).
