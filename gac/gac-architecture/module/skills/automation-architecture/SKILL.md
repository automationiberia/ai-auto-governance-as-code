---
name: automation-architecture
description: >-
  Applies landscape, type, function, component structure and collection packaging
  for Ansible. Use when structuring repos, splitting playbooks/roles, or Controller
  workflows. Points to runnable standard example tree.
---

# Automation Architecture

Docs: `automation-whitepaper/architecture/landscape-type-function-component.md`
Puppet → AAP evolution (three phases): `architecture/aap-puppet-coexistence-evolution.md`

## Hierarchy

Landscape (workflow) → Type (one playbook/host) → Function (role) → Component (`tasks/*.yml`)

## Reference implementation

Browse: `automation-whitepaper/examples/standard-rsyslog-forwarding/`

| Level | File |
|-------|------|
| Type | `playbooks/type_linux_logging.yml` |
| Function | `roles/rsyslog_forward/` |
| Components | `tasks/install.yml`, `configure.yml`, … |

Collections: `automation-whitepaper/architecture/collections-and-execution-environments.md`

## Agent behavior

- Declare active mode per [AGENTS.md](../../../../AGENTS.md) (design work is **Mode 2 — The Builder**).
- Propose L/T/F/C mapping; point to example paths for copy — do not embed full role in chat.
