# AI-Driven Governance-as-Code for Ansible Automation

Department program that replaces static style guides with an **active AI enforcement engine** for Ansible content. By encoding white paper standards into **Agent Skills**, AI agents act as **Senior Lead Engineers** rather than mere assistants.

**Short name:** AI-Driven Governance-as-Code (use in prose after first mention in a document).

Implementation in this monorepo:

| Layer | Location |
|-------|----------|
| Standards (source of truth) | `automation-whitepaper/` (white book) |
| Agent Skills (intelligence layer) | `skills/` + [`AGENTS.md`](../../AGENTS.md) |
| Upstream GPA reference | `automation-good-practices/` submodule |
| Production Ansible code | `deliveries/automation/` → `automationiberia/ai-auto-deliveries` (fixed submodule URL) |
| Mechanical gates | `pre-commit`, delivery collection CI |

Layout: [../architecture/monorepo-layout.md](../architecture/monorepo-layout.md).

---

## Three operating modes

| Mode | Type | Agent responsibility | Specific actions |
|------|------|----------------------|----------------|
| **1 — The Auditor** | Retroactive | Scan existing playbooks and roles for technical debt. | Identifies legacy patterns (e.g. `with_items`), missing variable prefixes, and proposes refactors to align with `SKILL.md`. |
| **2 — The Architect** | Proactive | Generate new roles and modules from scratch. | Bootstraps context using `AGENTS.md` rules to ensure FQCN usage and naming logic are compliant from the first line of YAML. |
| **3 — The Librarian** | Maintenance | Continuous evolution of the governance layer. | Proposes updates to `SKILL.md` when the team adopts new patterns (e.g. Molecule for testing) or when the Red Hat CoP upstream updates. |

### Skill mapping

| Mode | Skill |
|------|--------|
| 1 — Auditor | `skills/automation-auditor/SKILL.md` |
| 2 — Architect | `skills/automation-architect/SKILL.md` |
| 3 — Librarian | `skills/automation-librarian/SKILL.md` |

Supporting task skills (lifecycle, roles, pre-commit, etc.) are listed in [skills/README.md](../../skills/README.md).

---

## Execution rule

To ensure architectural alignment, the AI agent **must state its active mode** (e.g. *"I am operating in Mode 1: The Auditor"*) **before delivering technical output**.

Humans may request a mode explicitly:

- *"Audit this role"* → Mode 1
- *"Create a new NTP sync capability"* → Mode 2
- *"We now require Molecule on standard profile — update governance"* → Mode 3

---

## Librarian workflow (summary)

1. Change **white paper** markdown first (`automation-whitepaper/`).
2. Sync the matching **`skills/<name>/SKILL.md`** (keep each skill under ~500 lines).
3. Update [skills/README.md](../../skills/README.md) catalog if skills are added or renamed.
4. Sync skills in your AI tool per [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md) (Cursor: `link-cursor-skills.sh`; others: project knowledge / instructions).
5. Record rationale in PR description; pin `automation-good-practices` submodule when adopting GPA changes.

---

## Program scope

This program applies to **Ansible automation** managed under `<automation-home>` and the shared delivery collection `<automation-repo>`. It complements — does not replace — human governance (RACI, CAB, security sign-off).

## RACI note

Mode selection does not replace [roles-and-responsibilities.md](roles-and-responsibilities.md). **Heavy** profile changes still require human CAB, security, and operations sign-off; agents prepare evidence and diffs, humans approve production risk.

---

## Related documents

- [organizational-model-and-stakeholders.md](organizational-model-and-stakeholders.md)
- [roles-and-responsibilities.md](roles-and-responsibilities.md)
- [../quality/pre-commit.md](../quality/pre-commit.md)
- [../../AGENTS.md](../../AGENTS.md)
