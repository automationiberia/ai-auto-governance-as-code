# Automation White Paper — Agent Skills

Tool-agnostic skills encoding the [automation white paper](../automation-whitepaper/README.md). **Canonical source:** `skills/` — maintain only here.

Skills implement **[AI-Driven Governance-as-Code for Ansible Automation](../automation-whitepaper/governance/governance-as-code-ai-enforcement.md)** together with [AGENTS.md](../AGENTS.md). They are the **intelligence layer** of the governance monorepo — see [monorepo layout](../automation-whitepaper/architecture/monorepo-layout.md). Agents must **state their active mode** before technical output.

Skills are stored as **`SKILL.md`** (markdown). Some agent environments accept **`.mdc`** or other skill file formats; maintain canonical content under `skills/` here.

## Operating modes

| Mode | Skill | When |
|------|-------|------|
| **1 — Auditor** (retroactive) | [automation-auditor](automation-auditor/SKILL.md) | Review, refactor, debt scan on existing YAML |
| **2 — Architect** (proactive) | [automation-architect](automation-architect/SKILL.md) | New roles, playbooks, greenfield capabilities |
| **3 — Librarian** (maintenance) | [automation-librarian](automation-librarian/SKILL.md) | Update white paper ↔ skills; GPA upstream sync |

Task skills below are used **inside** Mode 1 or 2 as needed.

## Path conventions

| Symbol | Meaning |
|--------|---------|
| `<automation-home>` | Governance monorepo root (`ai-auto-skills`; white paper, lint templates) |
| `<automation-repo>` | **`deliveries/automation/`** — shared Ansible collection (Git submodule; new capabilities = new roles) |
| `<example-root>` | Reference under `automation-whitepaper/examples/<name>/` — copy into `<automation-repo>` |

```bash
export AUTOMATION_HOME=/path/to/this/repository
```

## Setup — which AI tool?

Skills are **tool-agnostic** (`SKILL.md` under `skills/`). Configuration depends on your environment:

| If you use… | Read |
|-------------|------|
| **Cursor** | [TOOL-SETUP.md → Cursor](TOOL-SETUP.md#cursor) |
| **Claude** (Desktop, Code, Projects, API) | [TOOL-SETUP.md → Claude](TOOL-SETUP.md#claude) |
| **GitHub Copilot** | [TOOL-SETUP.md → Copilot](TOOL-SETUP.md#github-copilot) |
| **Other / any agent** | [TOOL-SETUP.md → Generic](TOOL-SETUP.md#generic-any-agent) |

**Start here:** [TOOL-SETUP.md](TOOL-SETUP.md) — pick one row, then follow only that section.

**Prompt examples (all tools):** [../automation-whitepaper/guides/ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md).

## Skill catalog

### Mode skills

| Skill | Mode |
|-------|------|
| [automation-auditor](automation-auditor/SKILL.md) | 1 — Auditor |
| [automation-architect](automation-architect/SKILL.md) | 2 — Architect |
| [automation-librarian](automation-librarian/SKILL.md) | 3 — Librarian |

### Task skills

| Skill | Use when | White paper |
|-------|----------|-------------|
| [automation-new-automation](automation-new-automation/SKILL.md) | New automation end-to-end | [step-by-step guide](../automation-whitepaper/guides/create-new-automation-step-by-step.md) |
| [automation-pre-commit](automation-pre-commit/SKILL.md) | Hooks, lint failures | [pre-commit.md](../automation-whitepaper/quality/pre-commit.md) |
| [automation-lifecycle](automation-lifecycle/SKILL.md) | Intake → retire | [lifecycle/](../automation-whitepaper/lifecycle/) |
| [automation-architecture](automation-architecture/SKILL.md) | L/T/F/C, collections | [architecture/](../automation-whitepaper/architecture/) |
| [automation-role-development](automation-role-development/SKILL.md) | Roles | [development/roles.md](../automation-whitepaper/development/roles.md) |
| [automation-playbook-inventory](automation-playbook-inventory/SKILL.md) | Playbooks, inventory | [development/](../automation-whitepaper/development/) |
| [automation-quality-gates](automation-quality-gates/SKILL.md) | Review, idempotency | [quality/](../automation-whitepaper/quality/) |
| [automation-governance](automation-governance/SKILL.md) | Stakeholders, CAB | [governance/](../automation-whitepaper/governance/) |
| [automation-controller-ops](automation-controller-ops/SKILL.md) | Controller, SSOT | [operations/](../automation-whitepaper/operations/) |

## Runnable examples (prefer over duplicating code)

| Profile | Code directory | Walkthrough |
|---------|----------------|-------------|
| Light | `automation-whitepaper/examples/light-dev-packages/` | `example-light-walkthrough-dev-packages.md` |
| Standard | `automation-whitepaper/examples/standard-rsyslog-forwarding/` | `example-complete-walkthrough-rsyslog-forwarding.md` |

When implementing or reviewing: **read and edit files in `<example-root>`**; link from docs, do not paste large blocks into markdown.

## Maintaining skills (Librarian mode)

Use **Mode 3 — The Librarian** ([automation-librarian](automation-librarian/SKILL.md)):

1. Update white paper markdown first.
2. Sync matching `SKILL.md` (keep under ~500 lines).
3. Update [AGENTS.md](../AGENTS.md) if bootstrap or mode rules change.
4. Run tool-specific sync per [TOOL-SETUP.md](TOOL-SETUP.md) (e.g. `link-cursor-skills.sh` **only for Cursor**).
5. Add catalog row above.

## Language

English only.
