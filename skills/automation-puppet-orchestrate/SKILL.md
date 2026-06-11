---
name: automation-puppet-orchestrate
description: >-
  AI-Driven Governance-as-Code — Phase 1 centralized orchestration. Generate AAP
  wrapper playbooks that invoke Puppet via community.general.puppet (noop/check mode,
  tags, environment, summarize). Use for short-term coexistence; not Phase 2 native refactor.
---

# Phase 1 — Puppet orchestration wrappers

**Context:** Generating **Phase 1** orchestration wrapper playbooks per [aap-puppet-coexistence-evolution.md](../../automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md).

**Mode:** **2 — The Builder** (wrappers only — do not rewrite Puppet manifests).

## Execution rule

> I am operating in **Mode 2: The Builder** (Phase 1 Puppet orchestration).

## Mandatory guardrails

1. Always use certified **`community.general.puppet`**. Raw shell (`shell: puppet agent -t`, `command: puppet …`) is **prohibited**.
2. Set **`summarize: true`** on every module invocation so Puppet run summaries appear in **AAP job logs**.
3. Map dry-run: **`noop: "{{ ansible_check_mode }}"`**.
4. Support surgical runs: **`tags`** / **`skip_tags`** when passed via `_puppet_tags` / `_puppet_skip_tags` (internal vars).
5. Respect lifecycle: **`environment: "{{ _puppet_environment }}"`** (or module-equivalent `env` per collection docs — prefer documented parameter name for installed collection version).
6. **Do not** use deprecated module **`timeout`** parameter. Use task-level **`async`** and **`poll`** when a timeout/async run is required.
7. **FQCN** only. Imperative **`name:`** on every task.
8. Wrappers live in **`$AUTOMATION_REPO`** (thin type playbooks; optional dedicated `roles/puppet_orchestrate/` if logic grows).

## Variable naming

| Variable | Prefix | Example |
|----------|--------|---------|
| Puppet environment, tags, async tuning | `_` (internal) | `_puppet_environment`, `_puppet_tags` |
| Operator-overridable extra vars | no `_` | `puppet_run_tags` (document in role README) |

## Reference task shape

```yaml
- name: Run Puppet agent via AAP orchestration
  community.general.puppet:
    noop: "{{ ansible_check_mode }}"
    tags: "{{ _puppet_tags | default(omit) }}"
    skip_tags: "{{ _puppet_skip_tags | default(omit) }}"
    environment: "{{ _puppet_environment }}"
    summarize: true
```

Add `async` / `poll` only when requirements explicitly need them.

## Out of scope

- Phase 2 native Ansible replacement of Puppet resources
- Editing Puppet manifests in the Puppet repo (orchestration only)
- New Puppet modules for greenfield (Phase 3 = native Ansible)

## Cross-references

- [strategic-proposal-aap-governance-evolution.md](../../automation-whitepaper/governance/strategic-proposal-aap-governance-evolution.md)
- [automation-builder](../automation-builder/SKILL.md)
- [AGENTS.md](../../AGENTS.md)

## Agent behavior

- Propose wrapper structure before writing files.
- Never deploy to production — branch / Dev Spaces only; human review required.
- If user asks to migrate Puppet to Ansible, switch to **automation-new-automation** (Phase 2) and confirm trigger criteria.
