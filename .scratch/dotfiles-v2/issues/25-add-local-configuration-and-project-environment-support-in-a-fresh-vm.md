# Add Local configuration and project environment support in a fresh VM

Type: task
Status: ready-for-agent

**What to build:** A user can supply validated non-secret machine values without logging them, and use Mise plus Direnv safely for project environments on a fresh VM.

**Blocked by:** 24: Apply Fedora system settings and rootless Docker in a fresh VM.

- [ ] Document and validate the Local configuration schema for allowed machine values.
- [ ] Ensure Local configuration values and secrets do not appear in Bootstrap output or reports.
- [ ] Configure Mise `.tool-versions` compatibility and the Fish Direnv hook.
- [ ] Add command behavior tests and pass the fresh-VM check with retained evidence.
