# GaC Lola module — governance skills

> Lola module `gac` — skills that encode [automation white paper](../automation-whitepaper/) standards for AI agents.

**Install:** [skills/TOOL-SETUP.md](../skills/TOOL-SETUP.md) · **Layout:** [LobsterTrap/lola](https://github.com/LobsterTrap/lola) · **Reference:** [ansible-community/ai-forge](https://github.com/ansible-community/ai-forge)

## Module layout (Lola standard)

```text
gac/
  README.md                 ← this catalog
  SKILL_GUIDELINES.md       ← Librarian template
  module/
    skills/<name>/SKILL.md  ← auto-discovered skills
    commands/*.md           ← slash commands (modes)
  scripts/                  ← maintainer helpers (not installed by Lola)
```

**Canonical skill source:** `gac/module/skills/*/SKILL.md`

## Paradigm

The **human is the Architect** (strategy, Red Lines, approval). AI agents operate in three **execution modes** — or work **manually** via white book guides. See [AGENTS.md](../AGENTS.md).

| Path | When |
|------|------|
| **Manual** | [getting-started](../automation-whitepaper/guides/getting-started.md) without AI |
| **Mode 1 — Auditor** | Review and fix existing code |
| **Mode 2 — Builder** | Create new automation |
| **Mode 3 — Librarian** | Update white book + skills |

## Mode skills

| Mode | Skill | Command |
|------|-------|---------|
| **1 — Auditor** | [automation-auditor](module/skills/automation-auditor/SKILL.md) | `/audit` |
| **2 — Builder** | [automation-builder](module/skills/automation-builder/SKILL.md) | `/build` |
| **3 — Librarian** | [automation-librarian](module/skills/automation-librarian/SKILL.md) | `/librarian` |

## AI Mob Design

| Skill | When |
|-------|------|
| [ai-mob-design](module/skills/ai-mob-design/SKILL.md) | Complex design + same-session implementation |

Guide: [ai-mob-design.md](../automation-whitepaper/guides/ai-mob-design.md) · ADR: [ADR-008](../automation-whitepaper/adrs/ADR-008-ai-mob-design.md) · Command: `/mob-design`

## Task skills

| Skill | When to Use |
|-------|-------------|
| [automation-new-automation](module/skills/automation-new-automation/SKILL.md) | New automation end-to-end |
| [automation-role-development](module/skills/automation-role-development/SKILL.md) | Ansible roles |
| [automation-playbook-inventory](module/skills/automation-playbook-inventory/SKILL.md) | Playbooks & inventory |
| [automation-quality-gates](module/skills/automation-quality-gates/SKILL.md) | Code review & validation |
| [automation-pre-commit](module/skills/automation-pre-commit/SKILL.md) | Pre-commit hooks |
| [automation-architecture](module/skills/automation-architecture/SKILL.md) | L/T/F/C patterns |
| [automation-lifecycle](module/skills/automation-lifecycle/SKILL.md) | Six-stage lifecycle |
| [automation-governance](module/skills/automation-governance/SKILL.md) | Stakeholder & CAB |
| [automation-controller-ops](module/skills/automation-controller-ops/SKILL.md) | Controller operations |
| [automation-puppet-orchestrate](module/skills/automation-puppet-orchestrate/SKILL.md) | Phase 1 Puppet wrappers |

## Platform skills (live AAP via MCP)

Phase 1 catalog — detail: [PLATFORM_SKILLS.md](PLATFORM_SKILLS.md)

| Skill | Area |
|-------|------|
| [aap-live-snapshot](module/skills/aap-live-snapshot/SKILL.md) | Audit |
| [aap-rbac-review](module/skills/aap-rbac-review/SKILL.md) | Audit |
| [aap-job-status](module/skills/aap-job-status/SKILL.md) | Operate |

## Maintaining skills (Librarian)

1. Update white paper markdown first
2. Sync `gac/module/skills/<name>/SKILL.md` (see [SKILL_GUIDELINES.md](SKILL_GUIDELINES.md))
3. Update [AGENTS.md](../AGENTS.md) and this catalog if modes change
4. `lola install gac -a <assistant>` or `lola sync`
5. AAPSL upstream: `git submodule update --remote skills/vendor/aap-skills-library` then `./gac/scripts/sync-aapsl-skills.sh --diff`

Vendor submodule stays at `skills/vendor/aap-skills-library/` (not part of the Lola module tree).
