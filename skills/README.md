# Automation White Paper — Agent Skills

Tool-agnostic skills encoding the [automation white paper](../automation-whitepaper/README.md). **Canonical source:** `skills/` — maintain only here.

## Path conventions

| Symbol | Meaning |
|--------|---------|
| `<automation-home>` | Department standards repo (white paper, lint templates) |
| `<automation-repo>` | **`deliveries/automation/`** — shared Ansible collection (Git submodule; new capabilities = new roles) |
| `<example-root>` | Reference under `automation-whitepaper/examples/<name>/` — copy into `<automation-repo>` |

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
```

## Cursor IDE

Linked under [`.cursor/skills/`](../.cursor/skills/README.md). After clone:

```bash
./skills/scripts/link-cursor-skills.sh
```

Mention a skill in chat (e.g. *use automation-new-automation*) or rely on descriptions.

## Skill catalog

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

## Maintaining skills

1. Update white paper markdown first.
2. Sync matching `SKILL.md` (keep under ~500 lines).
3. Run `link-cursor-skills.sh` when adding a skill.
4. Add catalog row above.

## Language

English only.
