# ADR-004: Librarian synchronization (not automated compilation)

**Status:** Accepted (example)
**Type:** EVOLUTION_RULE
**Enforcement:** Librarian

## Context

Standards must reach AI agents in a maintainable, reviewable form without introducing a fragile compile toolchain.

## Decision

Approved white book changes are synchronized to `SKILL.md` through the **Librarian workflow**:

1. Update `automation-whitepaper/*.md` (human-authored source)
2. Sync matching `skills/<name>/SKILL.md`
3. Update `AGENTS.md` if mode or bootstrap rules change
4. Update `skills/README.md` catalog if skills are added or renamed
5. Apply tool-specific sync per [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md) (e.g. Cursor skill links)

We **do not** operate an automated ADR → `.mdc` compile pipeline. Canonical skill format is **`SKILL.md`**.

## Consequences

- Pull requests review white book and skill diffs together
- Governance evolution stays human-governed and auditable via Git
- No compile-freshness CI dependency unless explicitly adopted later by separate decision
