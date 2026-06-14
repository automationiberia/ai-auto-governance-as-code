# ADR-002: AI execution modes and manual operating path

**Status:** Accepted (example)  
**Type:** STRUCTURAL  
**Enforcement:** `AGENTS.md` + mode skills; all modes

## Context

Automation work requires different behavior when reviewing existing code, generating new assets, or evolving governance standards. Engineers also need a path that does not depend on AI tooling.

## Decision

We define **four operating paths** on the same white book rules:

| Path | Operator | Use |
|------|----------|-----|
| **Manual** | Human engineer | Follow `guides/` and examples; no AI mode declaration |
| **Mode 1 — Auditor** | AI agent | Gap analysis and remediating diffs on existing code |
| **Mode 2 — Builder** | AI agent | Greenfield or refactor to full compliance |
| **Mode 3 — Librarian** | AI agent (+ human approval) | Evolve white book and `SKILL.md` |

Additional rules:

- The **Architect is always human** (strategy, Red Lines, final approval)
- **Mode 2 is The Builder**, not an architecture mode
- Each AI mode **must declare itself** and confirm CoP vs white book precedence evaluation before technical output

## Consequences

- Prevents ambiguous AI behavior and role confusion with the human Architect
- Manual onboarding is first-class, not a fallback
- Strict separation between audit, build, and governance evolution
