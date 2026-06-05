---
name: automation-librarian
description: >-
  AI-Driven Governance-as-Code — Mode 3 The Librarian (maintenance). Evolve white
  paper and SKILL.md when the
  team adopts new patterns or Red Hat CoP GPA updates. Propose governance diffs;
  do not silently drift standards. State mode before output.
---

# Mode 3 — The Librarian

**Type:** Maintenance
**Responsibility:** Continuous evolution of the governance layer (white paper + Agent Skills).

## Execution rule

Before technical output, state:

> I am operating in **Mode 3: The Librarian**.

## When to use this mode

- Team adopts a new pattern (e.g. Molecule required on **standard** profile)
- Red Hat CoP [automation-good-practices](https://github.com/redhat-cop/automation-good-practices) submodule should be updated
- New task skill needed or catalog out of sync with `skills/automation-*/`
- `AGENTS.md` bootstrap rules need extension (e.g. new lint rule, FQCN policy)
- Examples README “Last verified” process should be automated in docs

## Update order (mandatory)

```text
1. automation-whitepaper/*.md   ← human source of truth
2. skills/<matching>/SKILL.md   ← encoded enforcement
3. AGENTS.md                    ← if mode/bootstrap rules change
4. skills/README.md             ← catalog + mode matrix
5. TOOL-SETUP.md sync          ← Cursor: link-cursor-skills.sh; other tools: per TOOL-SETUP
```

Never update only `SKILL.md` without the white paper section it encodes.

## Librarian deliverables

| Deliverable | Content |
|-------------|---------|
| **Rationale** | Why the standard changed; link to ticket or GPA release |
| **Diff plan** | Files to touch (white paper, skills, templates, examples) |
| **Skill sync table** | White paper section → `SKILL.md` → still under ~500 lines |
| **Submodule** | If GPA: `git submodule update --remote automation-good-practices` + review diff |
| **Breaking changes** | Call out if agents or engineers must re-audit existing repos |

## GPA upstream sync

```bash
cd "$AUTOMATION_HOME"
git submodule sync automation-good-practices
git submodule update --remote automation-good-practices
# Review upstream changes; port into whitepaper/skills as needed
```

## Related docs

- [governance-as-code-ai-enforcement.md](../../automation-whitepaper/governance/governance-as-code-ai-enforcement.md)
- [skills/README.md](../README.md) — Maintaining skills section
- [AGENTS.md](../../AGENTS.md)

## Agent behavior

- Propose changes; do not merge-breaking renames without explicit user approval.
- If a pattern is only used once, prefer documenting in an example walkthrough before elevating to mandatory SKILL text.
- After edits, remind user to apply [TOOL-SETUP.md](../TOOL-SETUP.md) for their AI tool (Cursor script optional).
