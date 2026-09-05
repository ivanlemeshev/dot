# Verify Bootstrap state and safe reruns in a fresh VM

Type: task
Status: ready-for-agent

**What to build:** The Bootstrap verifies its result, produces machine-readable evidence, handles network failure clearly, and completes a safe rerun without unexpected managed changes on a fresh VM.

**Blocked by:** 25: Add Local configuration and project environment support in a fresh VM.

- [ ] Verify required tools, configuration ownership, hooks, fonts, services, permissions, and allow-listed settings.
- [ ] Record machine-readable results without Local configuration values or secrets.
- [ ] Stop clearly on unavailable network resources and remain safe to rerun after recovery.
- [ ] Add command behavior tests and pass the fresh-VM check with retained evidence.
