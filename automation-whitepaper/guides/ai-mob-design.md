# AI Mob Design

> **Evolution of mob programming for the AI era:** multiple humans design together; AI implements what the group decides. Everyone — humans and AI — receives proper credit.

**Normative record:** [ADR-008](../adrs/ADR-008-ai-mob-design.md)
**AI facilitation:** [gac/module/skills/ai-mob-design/SKILL.md](../../gac/module/skills/ai-mob-design/SKILL.md)
**Template:** [templates/ai-mob-design-session-template.md](../templates/ai-mob-design-session-template.md)

---

## What is AI Mob Design?

| Traditional mob programming | AI Mob Design |
|----------------------------|---------------|
| Multiple people, one keyboard | Multiple people + AI |
| Group designs, one person types | Group designs, **AI implements** |
| Shared understanding by watching | Shared understanding by designing together |

**Key principles:**

1. **Multiple humans + AI** produce better designs than any individual alone
2. **The group designs; AI implements** — humans retain decision authority
3. **Everyone is a co-author** — humans via `Co-Authored-by`, AI via `Assisted-by`
4. **Formalized process** ensures quality, traceability, and attribution

---

## When to use

| Use AI Mob Design | When NOT to use |
|-------------------|-----------------|
| Complex problems requiring multiple perspectives | Simple, well-defined tasks one person can do |
| Cross-domain challenges (network + AAP + security) | Single-domain problems with a clear solution |
| Architecture decisions with many trade-offs **and** implementation today | Urgent fixes (too slow for emergencies) |
| Migration strategies needing docs + scaffolding | Individual learning exercises (solo study) |
| New skill, role, or module — design **and** first cut | Applying an existing ADR with no debate |

---

## Who should attend

| Role | Responsibility |
|------|----------------|
| **Session lead / facilitator** | Objective, time-boxing, keeps mob focused |
| **Domain experts** | Facts, constraints, implementation reality |
| **Stakeholders** | Requirements, risk, organizational priorities (when needed) |
| **AI assistant** | Questions, alternatives, **implementation**, documentation |

**Minimum mob:** session lead + one other human + AI.

---

## Running a session

### Before (5–10 min prep)

1. **Define objective clearly** — what will be designed **and** implemented
2. **Identify required participants** — who has the expertise this problem needs?
3. **Share context with everyone** — including AI (pre-reads, ADRs, diagrams)
4. **Prepare 2–3 key questions** to explore
5. **Assign session ID:** `YYYY-MM-DD-<topic-slug>`

### During (60–90 min typical)

#### 1. Kickoff (5 min)

- Restate objective and success criteria
- Confirm participants (humans + AI)
- Set ground rules: one conversation, challenge respectfully, mob decides

#### 2. Explore (30–45 min)

- Discuss the problem from multiple angles
- AI asks clarifying questions and suggests alternatives
- Capture options on shared doc or whiteboard
- Challenge assumptions — humans and AI

#### 3. Decide (15–20 min)

- Review options and trade-offs
- Make decisions **as a group**
- Document reasoning and rejected paths
- Confirm consensus before implementation

#### 4. Implement (20–30 min)

- AI implements based on the mob's approved design
- Mob reviews work-in-progress
- Adjust design or implementation as needed

### After

1. AI generates **session summary** and saves notes under `automation-whitepaper/mob-sessions/`
2. Create **PR** with all participants as co-authors
3. Document key decisions (**ADR** in `automation-whitepaper/adrs/` if architectural)
4. Schedule follow-up if implementation continues beyond the session

---

## Example session: Integrating Lola into GaC

**Topic:** How should GaC consume ai-forge and Lola?

**Participants:** 3 humans + Claude Sonnet 4.6

**Flow:**

1. Discussed overlap between GaC and ai-forge
2. Explored: Should GaC keep CoP submodule or use ai-forge for compliance?
3. AI asked: *"Is GaC a governance platform or general tooling?"*
4. Group decided: GaC = governance platform; consume ai-forge for **SDLC only**
5. AI clarified trade-off: governance needs version-controlled CoP → **keep submodule**
6. Mob designed: `.lola-req`, `lola-market.yml`, updated `Makefile`
7. AI implemented based on the group's design

**Result:** PR with all four participants as co-authors.

See [mob-sessions/2026-07-10-lola-integration.md](../mob-sessions/2026-07-10-lola-integration.md).

---

## Commit and PR attribution

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

### Optional trailers

```text
Session-Notes: automation-whitepaper/mob-sessions/2026-07-10-lola-integration.md
Architecture-Decision: automation-whitepaper/adrs/ADR-008-ai-mob-design.md
```

### Tag reference

| Tag | Purpose |
|-----|---------|
| `AI-Mob-Design: <id>` | Links PR/commit to mob session |
| `Session-Participants:` | All humans and AI in the mob |
| `Co-Authored-by:` | Each human mob participant |
| `Assisted-by:` | AI model that participated and implemented |
| `Session-Notes:` | Path to archived session summary |
| `Architecture-Decision:` | Path to ADR if created |

### Guidelines

- Include narrative in PR body explaining the mob session origin
- List **all** human participants in `Session-Participants:` and session notes
- Every human mob participant should appear in `Co-Authored-by` on the resulting PR
- Use actual model name in `Assisted-by`
- Archive session notes before or with the PR

---

## Tips for success

### For facilitators

- Keep discussion focused on the objective
- Ensure all voices are heard before deciding
- Time-box explore vs decide vs implement
- Capture decisions clearly before AI codes
- Confirm mob approval on WIP before closing

### For participants

- Read pre-session materials
- Share expertise openly
- Listen to other perspectives
- Challenge ideas respectfully
- Review AI implementation — you own approval to merge

### For AI

- Ask "why" questions for the whole mob
- Suggest alternatives when the group anchors early
- Synthesize viewpoints before deciding
- Implement the **group's** design, not your preference
- Document clearly and generate complete attribution

---

## Where artifacts live

| Artifact | Location |
|----------|----------|
| Practice ADR | `automation-whitepaper/adrs/ADR-008-ai-mob-design.md` |
| Session notes | `automation-whitepaper/mob-sessions/` |
| Session template | `automation-whitepaper/templates/ai-mob-design-session-template.md` |
| Facilitation skill | `gac/module/skills/ai-mob-design/SKILL.md` |
| Resulting ADRs | `automation-whitepaper/adrs/` |

---

## Related

- [AGENTS.md](../../AGENTS.md) — Operating paths and AI modes
- [automation-builder skill](../../gac/module/skills/automation-builder/SKILL.md) — Implementation standards during mob coding phase
