# AI Forge override mapping

AI Forge **baseline** is the pinned **`skills/vendor/ai-forge/`** git submodule — auditable and version-controlled. This document records where **automation-whitepaper** supersedes ai-forge defaults and tracks enterprise activation status.

## Hierarchy

Per [ADR-003](../adrs/ADR-003-enforcement-precedence.md) and [ADR-009](../adrs/ADR-009-ai-forge-submodule-governance.md):

1. **automation-whitepaper** — primary authority
2. **`skills/vendor/ai-forge/`** — SDLC baseline where white book is silent
3. **On conflict** — white book wins

## Module activation status

| Module | Path in submodule | Status | GaC wrapper / override |
|--------|-------------------|--------|------------------------|
| `ansible-collection-sdlc` | `ansible-collection-sdlc/` | **Active** — consumed as Lola dependency | None yet — used as-is |
| `ansible-collection-standards` | `ansible-collection-standards/` | Pending evaluation | — |
| `ansible-role` | `ansible-role/` | Pending evaluation | — |
| `ansible-content-development` | `ansible-content-development/` | Pending evaluation | — |
| `ansible-documentation` | `ansible-documentation/` | Pending evaluation | — |

## Override index

| Topic | ai-forge default | White book override | Reference |
|-------|------------------|---------------------|-----------|
| CoP fetch | Dynamic fetch from GitHub at runtime | Pinned submodule `automation-good-practices/` | [ADR-003](../adrs/ADR-003-enforcement-precedence.md) |

Add organization-specific overrides as your enterprise profile requires.

## Future wrapping

GaC may wrap ai-forge skills with enterprise-specific extensions:

- `org-commit` wrapping `/commit` with JIRA / ticket integration
- `org-create-pr` wrapping `/create-pr` with mandatory reviewers or labels
- Module activation as the team evaluates `ansible-collection-standards`, `ansible-role`, etc.

Wrapping is tracked in this table and implemented in `gac/module/skills/` following the synchronization workflow ([ADR-004](../adrs/ADR-004-librarian-synchronization.md)). Use `gac/scripts/sync-ai-forge-skills.sh` to inspect upstream changes after a submodule bump.

## Related

- [cop-overrides.md](cop-overrides.md)
- [ai-forge and GaC](ai-forge-and-gac.md)
- [ADR-009](../adrs/ADR-009-ai-forge-submodule-governance.md)
