# 13: Add Local configuration and project environment support

Status: ready-for-agent

**What to build:** A user can supply validated non-secret machine values without logging them, and use Mise plus Direnv safely for project environments.

**Blocked by:** 11: Apply managed home-directory configuration.

- [ ] Document and validate the Local configuration schema for allowed machine values.
- [ ] Ensure Local configuration values and secrets do not appear in Bootstrap output or reports.
- [ ] Configure Mise `.tool-versions` compatibility and the Fish Direnv hook.
- [ ] Add behavior tests for validation, redaction, and project-environment setup.
