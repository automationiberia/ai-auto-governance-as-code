---
name: automation-builder
description: >-
  AI-Driven Governance-as-Code — Mode 2 The Builder (proactive). Generate new roles,
  playbooks, and collection
  artifacts from scratch using AGENTS.md bootstrap rules (FQCN, naming, L/T/F/C).
  Use for greenfield automation. State mode before output.
---

# Mode 2 — The Builder

**Type:** Proactive
**Responsibility:** Generate net-new automation assets or refactor existing content to guarantee 100% compliance from the first line of YAML.

The **human** is the Architect (strategic design and approval). This mode is an AI **execution role** under that guidance.

## Execution rule

Before technical output, state:

> I am operating in **Mode 2: The Builder**. I have evaluated Red Hat COP baseline rules against white book overrides.

## Bootstrap (read first)

1. [AGENTS.md](../../AGENTS.md) — collection model, FQCN, naming, loops, native-first, verification
2. [automation-new-automation](../automation-new-automation/SKILL.md) — step-by-step artifacts checklist
3. White paper: [create-new-from-scratch.md](../../automation-whitepaper/guides/create-new-from-scratch.md)

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

## Profile selection

| Profile | When | Extra gates |
|---------|------|-------------|
| Light | Low risk, trivial tasks, zero external deps | Pre-commit; syntax-check |
| Standard | Baseline enterprise automation | Full compliance; Molecule if shared |
| Heavy | Complex multi-tier; high business criticality | CAB, security, Molecule required |

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
| Wire type playbook to Controller (live AAP, after Git exists) | [automation-controller-ops](../automation-controller-ops/SKILL.md) → `platform/aap-job-template-create` (Phase 2) |

## Reference code (copy patterns, do not paste into chat)

| Profile | Path |
|---------|------|
| Light | `automation-whitepaper/examples/light-dev-packages/` |
| Standard | `automation-whitepaper/examples/standard-rsyslog-forwarding/` |

## First-line YAML rules (non-negotiable)

- Modules: **FQCN** (`ansible.builtin.*` or declared collection).
- One function role per capability under `$AUTOMATION_REPO/roles/rolename/`.
- Type playbook: `playbooks/type_<category>.yml` (roles only, thin playbook).
- Every task has an imperative `name:`.
- **Native-first** — refuse `shell`/`command` when a module exists; Documentation Gate if unavoidable.

## Agent behavior

- Generate into `$AUTOMATION_REPO` unless the user asks for an example under `automation-whitepaper/examples/`.
- Run or instruct verification: syntax-check + pre-commit before claiming complete.
- Do not skip intake/design docs (`docs/rolename/INTAKE.md`, `DESIGN.md`) for **standard** / **heavy**.
