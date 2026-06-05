---
name: automation-architect
description: >-
  AI-Driven Governance-as-Code — Mode 2 The Architect (proactive). Generate new roles,
  playbooks, and collection
  artifacts from scratch using AGENTS.md bootstrap rules (FQCN, naming, L/T/F/C).
  Use for greenfield automation. State mode before output.
---

# Mode 2 — The Architect

**Type:** Proactive  
**Responsibility:** Generate new roles and modules from scratch compliant from the first line of YAML.

## Execution rule

Before technical output, state:

> I am operating in **Mode 2: The Architect**.

## Bootstrap (read first)

1. [AGENTS.md](../../AGENTS.md) — collection model, FQCN, naming, loops, verification  
2. [automation-new-automation](../automation-new-automation/SKILL.md) — step-by-step artifacts checklist  
3. White paper: [create-new-automation-step-by-step.md](../../automation-whitepaper/guides/create-new-automation-step-by-step.md)

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

## Profile selection

| Profile | When | Extra gates |
|---------|------|-------------|
| Light | Low risk, lab-only | Pre-commit; syntax-check |
| Standard | Production config | Design review; molecule if shared |
| Heavy | Privileged / regulated | CAB, security, molecule required |

Declare the profile in the plan before generating files.

## Task skill routing

| Building | Skill |
|----------|--------|
| Phase 1 Puppet wrapper (no Puppet code change) | [automation-puppet-orchestrate](../automation-puppet-orchestrate/SKILL.md) |
| End-to-end new capability (Phase 2.3 greenfield / Phase 2.2 refactor) | [automation-new-automation](../automation-new-automation/SKILL.md) |
| L/T/F/C placement | [automation-architecture](../automation-architecture/SKILL.md) |
| Role bodies | [automation-role-development](../automation-role-development/SKILL.md) |
| Playbooks + inventory | [automation-playbook-inventory](../automation-playbook-inventory/SKILL.md) |
| Lifecycle / intake | [automation-lifecycle](../automation-lifecycle/SKILL.md) |

## Reference code (copy patterns, do not paste into chat)

| Profile | Path |
|---------|------|
| Light | `automation-whitepaper/examples/light-dev-packages/` |
| Standard | `automation-whitepaper/examples/standard-rsyslog-forwarding/` |

## First-line YAML rules (non-negotiable)

- Modules: **FQCN** (`ansible.builtin.*` or declared collection).  
- One function role per capability under `$AUTOMATION_REPO/roles/<function>/`.  
- Type playbook: `playbooks/type_<category>.yml` (roles only, thin playbook).  
- Every task has an imperative `name:`.

## Agent behavior

- Generate into `$AUTOMATION_REPO` unless the user asks for an example under `automation-whitepaper/examples/`.  
- Run or instruct verification: syntax-check + pre-commit before claiming complete.  
- Do not skip intake/design docs (`docs/<function>/INTAKE.md`, `DESIGN.md`) for **standard** / **heavy**.
