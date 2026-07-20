# ADR-008: AI Mob Design

**Status:** Accepted
**Type:** GOVERNANCE_RULE
**Date:** 2026-07-10
**Enforcement:** Voluntary practice; recommended for complex design-and-implement work

## Context

Complex Ansible automation challenges — collection architecture, AAP deployment topology, migration strategies, governance model design — benefit from **multiple human perspectives** working together. No single engineer holds all domain, operational, and organizational context.

AI can **implement** solutions quickly once a design is clear, but it needs human expertise to define what to build, what constraints apply, and what trade-offs are acceptable.

**Traditional mob programming** puts multiple people at one keyboard: the group designs, one person types. **AI Mob Design** evolves that pattern:

| Traditional mob | AI Mob Design |
|-----------------|---------------|
| Multiple people, one keyboard | Multiple people + AI |
| Group designs, one person types | Group designs, **AI implements** |
| Shared understanding through watching | Shared understanding through designing together |

Without a formal practice, mob-style sessions lose attribution, skip documentation of reasoning, and blur the line between exploratory chat and authoritative design.

The human team retains **decision authority** and **final approval** on merged work. AI is an **equal participant** — question asker, alternative explorer, implementer, and documenter — not a solo decision maker.

## Decision

Adopt **AI Mob Design** as a standard practice for complex automation challenges where a team wants to **collaboratively define a solution and have AI implement it** before closing the session.

### Process

| Step | Who | Action |
|------|-----|--------|
| **1 — Assemble the mob** | Session lead | Invite domain experts, architects, stakeholders as needed |
| **2 — AI joins** | Team | AI participates as equal member and designated implementer |
| **3 — Brainstorm** | Mob + AI | Explore problem from multiple angles; AI asks clarifying questions |
| **4 — Explore alternatives** | Mob + AI | AI suggests options; group challenges assumptions |
| **5 — Decide** | Mob | Group makes decisions; AI documents reasoning and trade-offs |
| **6 — Implement** | AI (mob reviews) | AI implements the group's design; mob reviews work-in-progress |
| **7 — Ship** | Mob | PR with all mob participants credited; session notes archived |

**Typical duration:** 60–90 minutes (design + initial implementation).

### When to use

| Use AI Mob Design | Prefer something else |
|-------------------|----------------------|
| Complex architecture with implementation in scope | Simple, well-defined single-person task |
| Multi-domain problems (AAP + network + security) | Urgent hotfix (too slow for emergencies) |
| Governance model design with immediate artifacts | Single-domain problem with obvious solution |
| Migration strategies needing docs + scaffolding | Individual learning exercise (solo study) |
| New skill, role, or module design **and** first implementation | Applying an existing ADR with no design debate |
| Any problem benefiting from diverse expertise **and** same-session delivery | Manual path or solo Builder mode for well-scoped work |

### Attribution

All mob participants who materially contributed are **co-authors** on resulting work.

**Recommended format** (commit body and PR description):

```text
feat(lola): integrate Lola package manager into GaC

This design emerged from an AI Mob Design session exploring how GaC
should consume ai-forge.

AI-Mob-Design: 2026-07-10-lola-integration
Session-Participants: Alice Smith, Bob Jones, Carol White, Claude Sonnet 4.6

Co-Authored-by: Alice Smith <alice@example.com>
Co-Authored-by: Bob Jones <bob@example.com>
Co-Authored-by: Carol White <carol@example.com>
Assisted-by: Claude Sonnet 4.6
```

| Tag | Purpose |
|-----|---------|
| `AI-Mob-Design: <YYYY-MM-DD-topic-slug>` | Traceability to mob session |
| `Session-Participants:` | All humans and AI in the mob (readable list) |
| `Co-Authored-by:` | Each human mob participant (Git convention) |
| `Assisted-by:` | AI model that participated and implemented |

**Optional trailers:**

```text
Session-Notes: automation-whitepaper/mob-sessions/2026-07-10-lola-integration.md
Architecture-Decision: automation-whitepaper/adrs/ADR-005-native-first-execution.md
```

**Guidelines:**

- List **all** mob participants in `Session-Participants:` and the session notes
- Use `Co-Authored-by` for every human who participated in the mob design (unless org policy defines a narrower rule)
- Use `Assisted-by` for the AI — distinct from human co-authors
- Store session notes under `automation-whitepaper/mob-sessions/`
- Link to ADRs in `automation-whitepaper/adrs/` when the mob produced architectural decisions

See [AI Mob Design guide](../guides/ai-mob-design.md).

### Skill and guide

| Artifact | Path |
|----------|------|
| Mob facilitation skill | [gac/gac-design/module/skills/ai-mob-design/SKILL.md](../../gac/gac-design/module/skills/ai-mob-design/SKILL.md) |
| Practitioner guide | [guides/ai-mob-design.md](../guides/ai-mob-design.md) |
| Session template | [templates/ai-mob-design-session-template.md](../templates/ai-mob-design-session-template.md) |

## Consequences

### Positive

- **Better designs** from diverse perspectives applied before code is written
- **Faster delivery** — AI implements while context is fresh
- **Shared ownership** — entire mob understands the solution
- **Proper credit** — collaborative work is traceable and attributed
- **Learning** — participants see design reasoning and implementation together

### Considerations

- Requires scheduling multiple humans — not for every change
- Implementation quality depends on clear group decisions; ambiguous design produces rework
- AI must verify against white book and GPA; mob approves before merge
- Does not replace CAB, security review, or mandatory ADRs where those apply
- Long-running implementations may continue after the session — attribute the originating mob session on the PR

## Related decisions

- [ADR-002: AI modes and manual path](ADR-002-ai-modes-and-manual-path.md) — Builder mode during implementation phase
