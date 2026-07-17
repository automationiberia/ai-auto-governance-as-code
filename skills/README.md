# AI Agent Skills

> Tool-agnostic skills that encode [automation white paper](../automation-whitepaper/) standards for AI agents.

**First time?** Read [TOOL-SETUP.md](TOOL-SETUP.md) to configure your AI tool (Cursor/Claude/Copilot).

## Paradigm

The **human is the Architect** (strategy, Red Lines, approval). AI agents operate in three **execution modes** below — or work **manually** via white book guides (no mode declaration). See [AGENTS.md](../AGENTS.md).

## Operating paths

| Path | When |
|------|------|
| **Manual** | Onboarding; follow [getting-started](../automation-whitepaper/guides/getting-started.md) without AI |
| **Mode 1 — Auditor** | Review and fix existing code |
| **Mode 2 — Builder** | Create new automation |
| **Mode 3 — Librarian** | Update white book + skills |

## 🎭 AI operating modes

AI agents must declare their mode and precedence evaluation before generating code — see [AGENTS.md](../AGENTS.md).

| Mode | Skill | Purpose |
|------|-------|---------|
| **1 — Auditor** | [automation-auditor](automation-auditor/SKILL.md) | Review & refactor existing code; gap analysis |
| **2 — Builder** | [automation-builder](automation-builder/SKILL.md) | Create new automation from scratch |
| **3 — Librarian** | [automation-librarian](automation-librarian/SKILL.md) | Maintain governance layer |

## AI Mob Design

Mob programming evolved: **group designs, AI implements** — all participants co-author the PR:

| Skill | When |
|-------|------|
| [ai-mob-design](ai-mob-design/SKILL.md) | Complex design + same-session implementation with a human mob |

Guide: [guides/ai-mob-design.md](../guides/ai-mob-design.md) · ADR: [docs/adrs/ADR-007](../docs/adrs/ADR-007-ai-mob-design.md)

## 🛠️ Task Skills

Used within Auditor or Builder modes as needed.

| Skill | When to Use |
|-------|-------------|
| [automation-new-automation](automation-new-automation/SKILL.md) | Creating new automation end-to-end |
| [automation-role-development](automation-role-development/SKILL.md) | Developing Ansible roles |
| [automation-playbook-inventory](automation-playbook-inventory/SKILL.md) | Playbooks & inventory |
| [automation-quality-gates](automation-quality-gates/SKILL.md) | Code review & validation |
| [automation-pre-commit](automation-pre-commit/SKILL.md) | Pre-commit hooks & linting |
| [automation-architecture](automation-architecture/SKILL.md) | L/T/F/C patterns & collections |
| [automation-lifecycle](automation-lifecycle/SKILL.md) | Six-stage automation lifecycle |
| [automation-governance](automation-governance/SKILL.md) | Stakeholder & CAB processes |
| [automation-controller-ops](automation-controller-ops/SKILL.md) | Controller operations |

## Platform skills (live AAP via MCP)

Used for stage 6 operations and platform audit. Declare **platform area** per [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md).

| Skill | When to Use |
|-------|-------------|
| [aap-live-snapshot](platform/aap-live-snapshot/SKILL.md) | Full platform snapshot (read-only) |
| [aap-rbac-review](platform/aap-rbac-review/SKILL.md) | RBAC and access review (read-only) |
| [aap-job-status](platform/aap-job-status/SKILL.md) | Job status and failed-job lookup (read-only) |

Catalog: [platform/README.md](platform/README.md) · Template: [SKILL-TEMPLATE.md](SKILL-TEMPLATE.md)

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
export AUTOMATION_HOME=/path/to/ai-auto-governance-as-code
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
2. Sync corresponding `SKILL.md` (keep under ~500 lines) — `automation-*` or `platform/aap-*`
3. Update [AGENTS.md](../AGENTS.md) if modes or skill planes change
4. Run tool-specific sync per [TOOL-SETUP.md](TOOL-SETUP.md) (e.g. `link-cursor-skills.sh` **only for Cursor**)
5. Add entry to catalog above (content and/or platform tables)
6. For AAPSL upstream: `git submodule update --remote skills/vendor/aap-skills-library` then `sync-aapsl-skills.sh --diff`
6. Ask the user before committing; never push or open PRs automatically — after a commit, show push commands and a draft PR body per [AGENTS.md](../AGENTS.md#git-workflow-agents). Use a branch from up-to-date `main`.

## 📋 Complete Skill Catalog

### Mode Skills

| Skill | Mode |
|-------|------|
| [automation-auditor](automation-auditor/SKILL.md) | 1 — Auditor |
| [automation-builder](automation-builder/SKILL.md) | 2 — Builder |
| [automation-librarian](automation-librarian/SKILL.md) | 3 — Librarian |

### Task Skills

| Skill | Use when | White paper |
|-------|----------|-------------|
| [automation-new-automation](automation-new-automation/SKILL.md) | New automation end-to-end | [create-new-from-scratch guide](../automation-whitepaper/guides/create-new-from-scratch.md) |
| [automation-pre-commit](automation-pre-commit/SKILL.md) | Hooks, lint failures | [pre-commit.md](../automation-whitepaper/quality/pre-commit.md) |
| [automation-lifecycle](automation-lifecycle/SKILL.md) | Six-stage lifecycle | [lifecycle/](../automation-whitepaper/lifecycle/) |
| [automation-architecture](automation-architecture/SKILL.md) | L/T/F/C, collections | [architecture/](../automation-whitepaper/architecture/) |
| [automation-role-development](automation-role-development/SKILL.md) | Roles | [development/roles.md](../automation-whitepaper/development/roles.md) |
| [automation-playbook-inventory](automation-playbook-inventory/SKILL.md) | Playbooks, inventory | [development/](../automation-whitepaper/development/) |
| [automation-quality-gates](automation-quality-gates/SKILL.md) | Review, idempotency | [quality/](../automation-whitepaper/quality/) |
| [automation-governance](automation-governance/SKILL.md) | Stakeholders, CAB | [governance/](../automation-whitepaper/governance/) |
| [automation-controller-ops](automation-controller-ops/SKILL.md) | Controller, SSOT | [operations/](../automation-whitepaper/operations/) |
| [automation-puppet-orchestrate](automation-puppet-orchestrate/SKILL.md) | Phase 1 Puppet wrappers via AAP | [aap-puppet-coexistence-evolution.md](../automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md) |
| [ai-mob-design](ai-mob-design/SKILL.md) | AI Mob Design | [guides/ai-mob-design.md](../guides/ai-mob-design.md) |

### Platform skills (Phase 1)

| Skill | Area | White paper |
|-------|------|-------------|
| [aap-live-snapshot](platform/aap-live-snapshot/SKILL.md) | Audit | [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md) |
| [aap-rbac-review](platform/aap-rbac-review/SKILL.md) | Audit | [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md) |
| [aap-job-status](platform/aap-job-status/SKILL.md) | Operate | [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md) |

## 📝 Language

English only.
