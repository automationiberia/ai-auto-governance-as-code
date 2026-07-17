# ADR-007: AAP platform skills as second plane

**Status:** Proposed
**Type:** EVOLUTION_RULE
**Enforcement:** Librarian

## Context

The governance monorepo encodes **Ansible content** standards (roles, playbooks, collections) in `skills/automation-*`. [AAP Skills Library](https://github.com/automationiberia/aap-skills-library) (AAPSL) provides tested **platform administration** procedures via MCP — operate, audit, build, and maintain live AAP objects.

Without a formal integration model:

- Platform operations would remain ad-hoc prompts coupled to AAP APIs
- "Builder" and "Audit" terminology would collide between content and platform domains
- Enterprise SSOT, CAB, and JT naming rules would not apply to live platform changes

## Decision

1. Add a **second skill plane** at `skills/platform/aap-*` for enterprise-adapted platform administration skills.
2. Vendor upstream AAPSL as a **read-only submodule** at `skills/vendor/aap-skills-library/`.
3. **Never** symlink vendor skills directly to AI clients — Librarian merges upstream into `skills/platform/` with white book overrides.
4. Document platform governance in [aap-platform-administration.md](../operations/aap-platform-administration.md) before encoding in platform `SKILL.md` files.
5. Extend [automation-controller-ops](../../skills/automation-controller-ops/SKILL.md) as the **router** from content promotion to platform skills.
6. Adopt platform skills in phases: read-only Audit/Operate first; write skills gated by profile and change control.

Content modes (Auditor / Builder / Librarian) remain unchanged. Platform skills declare **platform areas** (Audit, Operate, Build, Maintain) in addition when applicable.

## Consequences

- `skills/README.md` and `AGENTS.md` catalog two planes: `automation-*` and `platform/aap-*`
- Librarian workflow gains a second upstream sync source (GPA + AAPSL)
- Engineers without MCP retain manual path via white book + Controller UI
- Phase 2+ PRs add write skills with CAB and SSOT guardrails

## Related

- [ADR-004](ADR-004-librarian-synchronization.md)
- [aap-platform-administration.md](../operations/aap-platform-administration.md)
- [SKILL-TEMPLATE.md](../../skills/SKILL-TEMPLATE.md)
