# ADR-001: White book and Agent Skills governance model

**Status:** Accepted (example)
**Type:** STRUCTURAL
**Enforcement:** White book + skills; Auditor + Builder

## Context

The enterprise requires traceable, enforceable automation standards that work for both human engineers and optional AI assistance. Documentation alone is insufficient without a clear link to day-to-day enforcement.

## Decision

We adopt a **Guide-first white book + Agent Skills** model where:

- Enterprise standards are **human-authored** in `automation-whitepaper/` (topic guides)
- **Red Hat CoP** `automation-good-practices/` is the baseline where the white book is silent
- On conflict, the **white book wins**
- `gac/gac-*/module/skills/*/SKILL.md` operationalize the effective rule set for AI agents
- `AGENTS.md` provides mode selection and Builder bootstrap rules
- **Mode 3 — Librarian** keeps the white book and skills in sync (propose diff → human approval → merge)
- There is **no automated compile pipeline** to `.mdc` or other formats
- **ADRs are optional** — used for exceptions and major decisions in `adrs/`, not as the primary store for every rule

## Consequences

- Governance is executable via guides, skills, review policy, and pre-commit/CI
- Teams may work **manually** (guides + examples) or with AI (Auditor / Builder / Librarian) on the same rules
- Librarian owns white book ↔ skill synchronization
