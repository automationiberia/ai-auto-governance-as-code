# AI Agent Skills

> Tool-agnostic skills that encode [automation white paper](../automation-whitepaper/) standards for AI agents.

**First time?** Read [TOOL-SETUP.md](TOOL-SETUP.md) to configure your AI tool (Cursor/Claude/Copilot).

## 🎭 Operating Modes

AI agents must declare their mode before generating code — see [AGENTS.md](../AGENTS.md).

| Mode | Skill | Purpose |
|------|-------|---------|
| **1 — Auditor** | [automation-auditor](automation-auditor/SKILL.md) | Review & refactor existing code |
| **2 — Architect** | [automation-architect](automation-architect/SKILL.md) | Create new automation from scratch |
| **3 — Librarian** | [automation-librarian](automation-librarian/SKILL.md) | Maintain governance layer |

## 🛠️ Task Skills

Used within Auditor or Architect modes as needed.

| Skill | When to Use |
|-------|-------------|
| [automation-new-automation](automation-new-automation/SKILL.md) | Creating new automation end-to-end |
| [automation-role-development](automation-role-development/SKILL.md) | Developing Ansible roles |
| [automation-playbook-inventory](automation-playbook-inventory/SKILL.md) | Playbooks & inventory |
| [automation-quality-gates](automation-quality-gates/SKILL.md) | Code review & validation |
| [automation-pre-commit](automation-pre-commit/SKILL.md) | Pre-commit hooks & linting |
| [automation-architecture](automation-architecture/SKILL.md) | L/T/F/C patterns & collections |
| [automation-lifecycle](automation-lifecycle/SKILL.md) | Automation lifecycle management |
| [automation-governance](automation-governance/SKILL.md) | Stakeholder & CAB processes |
| [automation-controller-ops](automation-controller-ops/SKILL.md) | Controller operations |

## ⚙️ Setup

**Choose your AI tool:**

| Tool | Setup Guide |
|------|-------------|
| Cursor | [TOOL-SETUP.md#cursor](TOOL-SETUP.md#cursor) |
| Claude | [TOOL-SETUP.md#claude](TOOL-SETUP.md#claude) |
| GitHub Copilot | [TOOL-SETUP.md#github-copilot](TOOL-SETUP.md#github-copilot) |
| Other | [TOOL-SETUP.md#generic](TOOL-SETUP.md#generic-any-agent) |

**Prompt examples:** [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md)

## 📂 Path Variables

```bash
export AUTOMATION_HOME=/path/to/ai-auto-skills
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

| Variable | Points to |
|----------|-----------|
| `$AUTOMATION_HOME` | This governance repo |
| `$AUTOMATION_REPO` | Shared Ansible collection |

## 📚 Reference Examples

| Profile | Location | Walkthrough |
|---------|----------|-------------|
| Light | [light-dev-packages/](../automation-whitepaper/examples/light-dev-packages/) | [walkthrough](../automation-whitepaper/examples/example-light-walkthrough-dev-packages.md) |
| Standard | [standard-rsyslog-forwarding/](../automation-whitepaper/examples/standard-rsyslog-forwarding/) | [walkthrough](../automation-whitepaper/examples/example-complete-walkthrough-rsyslog-forwarding.md) |

## 🔧 Maintaining Skills

Use **Mode 3 — Librarian** when updating:

1. Update white paper markdown first
2. Sync corresponding `SKILL.md` (keep under ~500 lines)
3. Update [AGENTS.md](../AGENTS.md) if modes change
4. Run tool-specific sync per [TOOL-SETUP.md](TOOL-SETUP.md) (e.g. `link-cursor-skills.sh` **only for Cursor**)
5. Add entry to catalog above

## 📋 Complete Skill Catalog

### Mode Skills

| Skill | Mode |
|-------|------|
| [automation-auditor](automation-auditor/SKILL.md) | 1 — Auditor |
| [automation-architect](automation-architect/SKILL.md) | 2 — Architect |
| [automation-librarian](automation-librarian/SKILL.md) | 3 — Librarian |

### Task Skills

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
| [automation-puppet-orchestrate](automation-puppet-orchestrate/SKILL.md) | Phase 1 Puppet wrappers via AAP | [aap-puppet-coexistence-evolution.md](../automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md) |

## 📝 Language

English only.
