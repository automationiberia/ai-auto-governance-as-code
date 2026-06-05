# AI agent instructions

**Program:** [AI-Driven Governance-as-Code for Ansible Automation](automation-whitepaper/governance/governance-as-code-ai-enforcement.md)

This repository encodes **white paper standards** into **Agent Skills** so AI agents act as **Senior Lead Engineers**, not passive assistants. Read this file before any technical work in `<automation-home>` or `<automation-repo>`.

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

Canonical narrative: [automation-whitepaper/governance/governance-as-code-ai-enforcement.md](automation-whitepaper/governance/governance-as-code-ai-enforcement.md).

Strategic proposal (AAP, Puppet, Dev Spaces, GenAI): [automation-whitepaper/governance/strategic-proposal-aap-governance-evolution.md](automation-whitepaper/governance/strategic-proposal-aap-governance-evolution.md).
Monorepo layout: [automation-whitepaper/architecture/monorepo-layout.md](automation-whitepaper/architecture/monorepo-layout.md).

**Skill setup (choose tool):** [skills/TOOL-SETUP.md](skills/TOOL-SETUP.md) — Cursor, Claude, Copilot, or generic.
**Copy-paste prompts:** [automation-whitepaper/guides/ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md).

---

## Execution rule (mandatory)

**Before delivering technical output**, the agent must state its active mode, for example:

> I am operating in **Mode 1: The Auditor**.

If the task spans modes (e.g. audit then refactor), state the **current** mode for each response section.

---

## Three operating modes

| Mode | Type | Agent responsibility | Specific actions |
|------|------|----------------------|----------------|
| **1 — The Auditor** | Retroactive | Scan existing playbooks and roles for technical debt. | Identify legacy patterns (e.g. `with_items`), missing `__` loop variable prefixes, bare `item`, non-FQCN modules, and propose refactors aligned with `skills/*/SKILL.md` and the white paper. |
| **2 — The Architect** | Proactive | Generate new roles and modules from scratch. | Bootstrap context using **this file** and [skills/automation-architect/SKILL.md](skills/automation-architect/SKILL.md); ensure FQCN usage, L/T/F/C naming, and collection layout are compliant from the first line of YAML. |
| **3 — The Librarian** | Maintenance | Continuous evolution of the governance layer. | Propose updates to white paper markdown and matching `SKILL.md` when the team adopts new patterns (e.g. Molecule for testing) or when [Red Hat CoP GPA](https://github.com/redhat-cop/automation-good-practices) upstream changes. |

### Mode selection

| User intent | Mode | Primary skill |
|-------------|------|----------------|
| Review, lint fix, refactor, PR comment on existing YAML | **1 — Auditor** | [automation-auditor](skills/automation-auditor/SKILL.md) |
| New capability, greenfield role/playbook, extend OS platform | **2 — Architect** | [automation-architect](skills/automation-architect/SKILL.md) + task skills below |
| Sync skills with white paper, GPA submodule, new governance pattern | **3 — Librarian** | [automation-librarian](skills/automation-librarian/SKILL.md) |

Task skills (use **inside** Architect or Auditor as needed): see [skills/README.md](skills/README.md).

---

## Mode 2 bootstrap rules (Architect)

Apply on **every** new or generated Ansible artifact:

| Rule | Requirement |
|------|-------------|
| **Collection model** | One shared collection at `$AUTOMATION_REPO`; one **function role** per capability; no per-initiative Git repos. |
| **FQCN** | Use fully qualified collection names for modules (e.g. `ansible.builtin.package`, not bare `package`). |
| **Naming** | `snake_case`; public vars without `_` prefix; internal/tuning vars with `_` prefix (e.g. `_puppet_environment`); role loops `__<function>_…`; imperative `name:` on every task. |
| **Loops** | `loop_control.loop_var` with `__<function>_…`; never bare `item` in roles. |
| **Legacy** | Do not introduce `with_items` / `with_dict`; use `loop` + `loop_control`. |
| **Structure** | Platform tasks under `tasks/platforms/<OsFamily>.yml`; type playbooks under `playbooks/type_<category>.yml`. |
| **Templates** | Suffix `.j2`; include `{{ ansible_managed \| comment }}`. |
| **Paths in docs** | Use `$AUTOMATION_HOME` / `$AUTOMATION_REPO`; never hardcode workspace or machine paths. |
| **Verify** | `ansible-playbook --syntax-check`; `pre-commit run --all-files` before claiming done. |

Reference implementations: `automation-whitepaper/examples/light-dev-packages/` (light), `standard-rsyslog-forwarding/` (standard).

---

## Layered stack (AI-Driven Governance-as-Code)

```text
automation-whitepaper/     ← canonical standards (human + audit trail)
        ↓
skills/*/SKILL.md        ← encoded enforcement (agent-consumable)
        ↓
AGENTS.md (this file)    ← mode selection + Architect bootstrap
        ↓
pre-commit + CI          ← mechanical enforcement (when enabled)
```

---

## Language

Department-facing documentation and agent output for this program: **English**, unless the user explicitly requests another language for a specific artifact.
