# ADR-005: Enforce native-first Ansible execution policy

**Status:** Accepted (example)  
**Type:** CODING_STANDARD  
**Enforcement:** Builder + Auditor

## Context

Ansible automation often degenerates into shell-script wrappers, reducing maintainability and idempotency.

## Decision

All automation **must** follow a native-first execution model:

- Use Ansible native modules whenever available
- `shell` and `command` are prohibited unless justified
- Any shell usage **must** include:
  - Documentation Gate comment
  - Explicit `changed_when` and `failed_when` conditions

**Authoritative guide:** [development/coding-style.md](../development/coding-style.md)

## Consequences

- Improves idempotency and portability
- Reduces technical debt in the automation layer
- Increases compliance enforcement burden
