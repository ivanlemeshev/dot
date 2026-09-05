# 17: Document the manual Migration gate

Status: ready-for-agent

**What to build:** A user has a complete archive, difference review, manual application, and rollback procedure for choosing Migration without overwriting unmanaged files.

**Blocked by:** 16: Run the Fedora VM acceptance protocol.

- [ ] Define the timestamped archive content and location outside active configuration paths.
- [ ] Provide the reviewed-difference, manual-application, replaced-path-record, and rollback procedure.
- [ ] Require immediate rollback for required-tool, desktop, security, permission, data-loss, or unexpected managed-file failures.
- [ ] Verify the procedure preserves unmanaged files and can restore the archived state.
