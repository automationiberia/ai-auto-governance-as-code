# Governance skills — Lola modules `gac-*`

> **Human rules → Agent Skills.** These modules encode [Automation White Paper](../automation-whitepaper/) standards so AI assistants enforce the same governance your engineers follow manually.

The white book (`automation-whitepaper/`) is the **source of truth**. Each `SKILL.md` here is a **translation** of those rules into instructions an agent can execute. Update the white paper first; then sync skills (Librarian). See [ADR-004](../automation-whitepaper/adrs/ADR-004-librarian-synchronization.md).

**Install:** [skills/TOOL-SETUP.md](../skills/TOOL-SETUP.md) · **Authoring:** [SKILL_GUIDELINES.md](SKILL_GUIDELINES.md) · **Lola:** [LobsterTrap/lola](https://github.com/LobsterTrap/lola) · **Pattern:** [ansible-community/ai-forge](https://github.com/ansible-community/ai-forge)

---

## Paradigm: Human as the Architect

| Role | Responsibility |
|------|----------------|
| **Human (Architect)** | Strategy, Red Lines, white book, final approval |
| **Mode 1 — Auditor** | Scan existing code against encoded rules |
| **Mode 2 — Builder** | Create automation to full compliance |
| **Mode 3 — Librarian** | Evolve white book **and** matching skills |

Manual work without AI uses the same white book — [getting-started](../automation-whitepaper/guides/getting-started.md). Entry point for agents: [AGENTS.md](../AGENTS.md).

---

## Module layout (Lola standard)

```text
gac/
  README.md                          ← this catalog
  SKILL_GUIDELINES.md                ← Librarian template for new skills
  PLATFORM_SKILLS.md                 ← live AAP (MCP) skills
  gac-governance/module/
    skills/<name>/SKILL.md           ← core governance modes
    commands/*.md                    ← slash commands for modes
  gac-design/module/
    skills/<name>/SKILL.md           ← design collaboration
    commands/*.md
  gac-architecture/module/
    skills/<name>/SKILL.md           ← architecture and lifecycle
  gac-development/module/
    skills/<name>/SKILL.md           ← role, playbook, content development
  gac-quality/module/
    skills/<name>/SKILL.md           ← quality gates and compliance
  gac-aap-platform/module/
    skills/<name>/SKILL.md           ← AAP platform administration (MCP)
  scripts/                           ← maintainer tools (not installed by Lola)
```

Canonical paths in git: `gac/gac-*/module/skills/*/SKILL.md`

Install the meta-module `gac` for everything, or individual modules for specific categories.

---

## Module catalog

### `gac-governance` — Core AI governance modes

| Mode | Skill | Command |
|------|-------|---------|
| **1 — Auditor** | [automation-auditor](gac-governance/module/skills/automation-auditor/SKILL.md) | `/audit` |
| **2 — Builder** | [automation-builder](gac-governance/module/skills/automation-builder/SKILL.md) | `/build` |
| **3 — Librarian** | [automation-librarian](gac-governance/module/skills/automation-librarian/SKILL.md) | `/librarian` |

### `gac-design` — AI Mob Design

| Skill | When |
|-------|------|
| [ai-mob-design](gac-design/module/skills/ai-mob-design/SKILL.md) | Humans mob on design; AI implements in session |

[Guide](../automation-whitepaper/guides/ai-mob-design.md) · [ADR-008](../automation-whitepaper/adrs/ADR-008-ai-mob-design.md) · `/mob-design`

### `gac-architecture` — Architecture and lifecycle

| Skill | Encodes |
|-------|---------|
| [automation-architecture](gac-architecture/module/skills/automation-architecture/SKILL.md) | L/T/F/C and collections |
| [automation-lifecycle](gac-architecture/module/skills/automation-lifecycle/SKILL.md) | Six-stage lifecycle |

### `gac-development` — Role, playbook, and content development

| Skill | Encodes |
|-------|---------|
| [automation-new-automation](gac-development/module/skills/automation-new-automation/SKILL.md) | End-to-end new capability |
| [automation-role-development](gac-development/module/skills/automation-role-development/SKILL.md) | Role structure and vars |
| [automation-playbook-inventory](gac-development/module/skills/automation-playbook-inventory/SKILL.md) | Playbooks and inventory |
| [automation-puppet-orchestrate](gac-development/module/skills/automation-puppet-orchestrate/SKILL.md) | Phase 1 Puppet wrappers |

### `gac-quality` — Quality gates and compliance

| Skill | Encodes |
|-------|---------|
| [automation-quality-gates](gac-quality/module/skills/automation-quality-gates/SKILL.md) | Review and idempotency |
| [automation-pre-commit](gac-quality/module/skills/automation-pre-commit/SKILL.md) | Hooks and lint |
| [automation-governance](gac-quality/module/skills/automation-governance/SKILL.md) | Stakeholders and CAB |

### `gac-aap-platform` — AAP platform administration (MCP)

Enterprise-adapted operations skills — [PLATFORM_SKILLS.md](PLATFORM_SKILLS.md)

| Skill | Area |
|-------|------|
| [aap-live-snapshot](gac-aap-platform/module/skills/aap-live-snapshot/SKILL.md) | Audit |
| [aap-rbac-review](gac-aap-platform/module/skills/aap-rbac-review/SKILL.md) | Audit |
| [aap-job-status](gac-aap-platform/module/skills/aap-job-status/SKILL.md) | Operate |

Router: [automation-controller-ops](gac-aap-platform/module/skills/automation-controller-ops/SKILL.md)

---

## Librarian workflow (maintaining the translation)

1. Change **white paper** markdown (`automation-whitepaper/`)
2. Update matching **`gac/gac-<category>/module/skills/<name>/SKILL.md`** ([SKILL_GUIDELINES.md](SKILL_GUIDELINES.md))
3. Update [AGENTS.md](../AGENTS.md) if modes or bootstrap rules change
4. Refresh this catalog if skills are added or renamed
5. `lola install gac -a <assistant>` or `lola sync`
6. AAPSL upstream: `git submodule update --remote skills/vendor/aap-skills-library` then `./gac/scripts/sync-aapsl-skills.sh --diff`

Vendor reference only: `skills/vendor/aap-skills-library/` — never symlink vendor skills directly into assistants.
