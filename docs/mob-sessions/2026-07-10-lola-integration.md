# AI Mob Design Session: Integrating Lola into GaC

**Date:** 2026-07-10
**Duration:** ~75 min
**Session ID:** `2026-07-10-lola-integration`
**Facilitator:** Alice Smith (platform architect)

---

## Participants

| Name | Role / expertise |
|------|------------------|
| Alice Smith | Platform architect; session lead |
| Bob Jones | Automation engineering |
| Carol White | Governance / compliance |
| Claude Sonnet 4.6 | Implementation + documentation |

---

## Objective

Design and implement how Governance-as-Code (GaC) integrates Lola and ai-forge without duplicating compliance-critical CoP content.

---

## Context

- GaC is a governance platform with pinned CoP (`automation-good-practices/`)
- ai-forge provides portable AI skills including SDLC and dynamic CoP review
- Lola can install ai-forge modules for contributor workflows
- Overlap risk: unclear ownership between GaC, ai-forge, and submodule CoP

---

## Key questions explored

1. Is GaC a governance platform or general Ansible tooling?
2. Should GaC consume ai-forge for CoP compliance or keep a local submodule?
3. What must be version-controlled for audit vs dynamically installed?

---

## Options considered

### Option A: Full ai-forge consumption

- **Pros:** Single install path; community-maintained skills
- **Cons:** CoP not pinned for offline/audit; governance gap
- **Discussion:** Governance (Carol) rejected for compliance baseline

**Verdict:** Rejected

### Option B: SDLC from ai-forge, CoP local (Lola for SDLC only)

- **Pros:** Auditable CoP submodule; community SDLC skills; simple `make install`
- **Cons:** Two install mechanisms to document
- **Discussion:** Platform and automation aligned; governance approved

**Verdict:** **Selected**

### Option C: Fork ai-forge into GaC

- **Pros:** Full control
- **Cons:** Maintenance burden; drift from community
- **Discussion:** Mob rejected — unnecessary duplication

**Verdict:** Rejected

---

## Decisions made

### 1. GaC consumes ai-forge for SDLC only via Lola

- **Reasoning:** Generic commit/PR/release skills belong in community ai-forge
- **Trade-offs accepted:** Lola dependency for contributors

### 2. Retain `automation-good-practices/` submodule for CoP

- **Reasoning:** Governance requires pinned, auditable, offline-capable baseline
- **Trade-offs accepted:** Submodule update process remains

### 3. Document split in architecture guide; `make install` for setup

- **Reasoning:** Contributor experience must stay simple
- **Trade-offs accepted:** Documentation maintenance

---

## Implementation plan

| Item | Owner | Notes |
|------|-------|-------|
| `.lola-req`, `lola-market.yml` | AI (mob review) | SDLC module only |
| `Makefile` `install` target | AI (mob review) | lola sync + submodules |
| Architecture doc updates | Bob Jones | Follow-up if not in same PR |
| README quick start | AI (mob review) | Three-command flow |

---

## Work-in-progress review

- Mob reviewed Lola manifest structure — confirmed `gac` module at repo root
- Confirmed submodule **not** removed (corrected from earlier exploratory idea)
- Pre-commit validation noted for PR checklist

---

## Action items

- [ ] Complete architecture doc — Owner: Bob Jones — Due: next sprint
- [ ] Open PR with mob attribution — Owner: Alice Smith — Due: same day

---

## Follow-up

- Monitor ai-forge SDLC skill updates via Lola pin policy
- Revisit if org adopts dynamic CoP with auditable pinning elsewhere

---

## Artifacts created

| Artifact | Link |
|----------|------|
| PR | (example — link when opened) |
| ADR | [ADR-007](../adrs/ADR-007-ai-mob-design.md) (practice); feature ADR optional |

---

## Attribution

```text
AI-Mob-Design: 2026-07-10-lola-integration
Session-Participants: Alice Smith, Bob Jones, Carol White, Claude Sonnet 4.6

Co-Authored-by: Alice Smith <alice@example.com>
Co-Authored-by: Bob Jones <bob@example.com>
Co-Authored-by: Carol White <carol@example.com>
Assisted-by: Claude Sonnet 4.6
```

See [AI Mob Design guide](../../guides/ai-mob-design.md).
