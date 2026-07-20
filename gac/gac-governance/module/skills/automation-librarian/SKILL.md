---
name: automation-librarian
description: >-
  AI-Driven Governance-as-Code — Mode 3 The Librarian (maintenance). Evolve white
  paper and SKILL.md when the
  team adopts new patterns or Red Hat CoP GPA updates. Propose governance diffs;
  do not silently drift standards. State mode before output.
user-invocable: true
metadata:
  author: gac
  version: "1.0"
---

# Mode 3 — The Librarian

**Type:** Maintenance
**Responsibility:** Continuous evolution of the governance layer (white paper + Agent Skills).

## Execution rule

Before technical output, state:

> I am operating in **Mode 3: The Librarian**. I have evaluated Red Hat COP baseline rules against white book overrides.

## When to use this mode

- Team adopts a new pattern (e.g. Molecule required on **standard** profile)
- Red Hat CoP [automation-good-practices](https://github.com/redhat-cop/automation-good-practices) submodule should be updated
- New task skill needed or catalog out of sync with `gac/module/skills/automation-*/`
- `AGENTS.md` bootstrap rules need extension (e.g. new lint rule, FQCN policy)
- Examples README “Last verified” process should be automated in docs

## Update order (mandatory)

```text
1. automation-whitepaper/*.md   ← human source of truth
2. gac/module/skills/<name>/SKILL.md   ← encoded enforcement (automation-* or aap-*)
3. AGENTS.md                    ← if mode/bootstrap rules change
4. gac/README.md             ← catalog + mode matrix
5. TOOL-SETUP.md sync          ← Lola: `lola install gac -a <assistant>`; manual fallback per TOOL-SETUP
6. AAPSL upstream (optional)   ← vendor/aap-skills-library → diff → aap-*
```

Canonical skill format is **`SKILL.md`**. There is **no automated compile pipeline** to `.mdc`. Example ADR: [ADR-004-librarian-synchronization.md](../../../../automation-whitepaper/adrs/ADR-004-librarian-synchronization.md).

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

## AAPSL upstream sync (platform skills)

Reference: [ADR-007](../../../../automation-whitepaper/adrs/ADR-007-aap-platform-skills-plane.md) · [aap-platform-administration.md](../../../../automation-whitepaper/operations/aap-platform-administration.md).

```bash
cd "$AUTOMATION_HOME"
git submodule update --remote skills/vendor/aap-skills-library
./gac/scripts/sync-aapsl-skills.sh --diff
# Librarian merges approved changes into gac/module/skills/aap-* (never symlink vendor directly)
```

## Related docs

- [governance-as-code-ai-enforcement.md](../../../../automation-whitepaper/governance/governance-as-code-ai-enforcement.md)
- [gac/README.md](../../../README.md) — Maintaining skills section
- [AGENTS.md](../../../../AGENTS.md)

## Agent behavior

- Propose changes; do not merge-breaking renames without explicit user approval.
- If a pattern is only used once, prefer documenting in an example walkthrough before elevating to mandatory SKILL text.
- After edits, remind user to apply [TOOL-SETUP.md](../../../../skills/TOOL-SETUP.md) for their AI tool (Cursor script optional).
- Do not commit unless the user explicitly asks; after completing changes, ask whether they want a commit.
- Never run `git push` or `gh pr create` automatically; only when the user explicitly asks. After a commit, show push commands and a draft PR title/body per [AGENTS.md](../../../../AGENTS.md#git-workflow-agents).
- For PR-sized governance work, use a branch from up-to-date `main` per [AGENTS.md](../../../../AGENTS.md#git-workflow-agents) and [CONTRIBUTING.md](../../../../CONTRIBUTING.md#branch-strategy).
