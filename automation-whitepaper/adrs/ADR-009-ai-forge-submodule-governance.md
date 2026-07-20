# ADR-009: AI Forge as governed submodule

**Status:** Proposed
**Type:** GOVERNANCE_RULE
**Enforcement:** Librarian

## Context

GaC consumed [ai-forge](https://github.com/ansible-community/ai-forge) SDLC skills as a **remote Lola dependency** (`@ansible-content/ansible-collection-sdlc`). This created a dual-marketplace model with no unified governance:

- Skills fetched from a remote `lola-market.yml` on GitHub — version can drift between runs
- No audit trail of which ai-forge version was used when
- Requires internet to resolve the dependency
- Two independent marketplaces (`ansible-content` + `gac`) with separate lifecycle
- Governance precedence did not formally cover ai-forge content

This is the same problem GaC already solved for Red Hat CoP with the `automation-good-practices/` pinned submodule ([ADR-003](ADR-003-enforcement-precedence.md)).

## Decision

1. Add `ai-forge` as a **git submodule** at `skills/vendor/ai-forge/`, pinned to a specific commit — same pattern as `automation-good-practices/` and `skills/vendor/aap-skills-library/`.
2. Point the Lola `ansible-content` marketplace to the **local submodule** `lola-market.yml` instead of the remote GitHub URL.
3. Extend the **rule of precedence** to include ai-forge SDLC baseline alongside CoP baseline at the foundation tier.
4. Track ai-forge overrides and enterprise adaptations in [ai-forge-overrides.md](../governance/ai-forge-overrides.md), parallel to [cop-overrides.md](../governance/cop-overrides.md).
5. Provide an inspection script (`gac/scripts/sync-ai-forge-skills.sh`) for comparing upstream changes after a submodule bump — report only, never auto-overwrite. Run by a human engineer, not by the Librarian agent.
6. Submodule updates are **deliberate**: bump the pinned commit via PR when the team is ready to adopt upstream changes.

## Consequences

- Single governance model: GaC is the sole source of truth for all consumed content (CoP, AI Forge, AAPSL)
- One marketplace origin (local submodule) instead of two (local + remote GitHub)
- Offline access to ai-forge skills — no network dependency at install time
- Audit trail: exact ai-forge version recorded in git history per commit
- Librarian workflow gains a third upstream sync source (CoP + AAPSL + AI Forge)
- All five ai-forge modules are available; enterprise activation and override status tracked in `ai-forge-overrides.md`

## Related

- [ADR-003](ADR-003-enforcement-precedence.md) — Enforcement precedence hierarchy
- [ADR-004](ADR-004-librarian-synchronization.md) — Librarian synchronization
- [ADR-007](ADR-007-aap-platform-skills-plane.md) — AAPSL vendor submodule pattern
- [ai-forge-overrides.md](../governance/ai-forge-overrides.md)
- [ai-forge-gac-integration.md](../architecture/ai-forge-gac-integration.md)
