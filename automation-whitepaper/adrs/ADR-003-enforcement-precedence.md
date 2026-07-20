# ADR-003: Establish enforcement precedence hierarchy

**Status:** Accepted (example)
**Type:** GOVERNANCE_RULE
**Enforcement:** Auditor (strict); all modes

## Context

Conflicts may arise between upstream Red Hat CoP guidance, enterprise white book rules, and AI skill text.

## Decision

Enforcement precedence is:

1. **Red Hat CoP** `automation-good-practices/` — default baseline where the white book is **silent**
1b. **AI Forge SDLC** `skills/vendor/ai-forge/` — SDLC baseline where the white book is **silent** ([ADR-009](ADR-009-ai-forge-submodule-governance.md))
2. **Enterprise white book** `automation-whitepaper/` — on conflict, **white book wins**
3. **Agent Skills + `AGENTS.md`** — operationalize 1–2 for AI; must not contradict the white book
4. **Mechanical gates** — pre-commit, ansible-lint, CI validate **code artifacts**
5. **Default Ansible behavior** — only where none of the above applies

**Note:**

- Optional ADRs in `adrs/` document *why* a rule or exception exists; they do not sit above the white book as a separate enforcement tier
- All automation — **manual or AI-generated** — must conform to the white book before secondary alignment to CoP

## Consequences

- Enterprise sovereignty is expressed through the **white book**, not a parallel ADR hierarchy
- Skills must be re-synced when white book overrides change
- Deterministic conflict resolution without a compile pipeline
