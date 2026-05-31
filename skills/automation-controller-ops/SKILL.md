---
name: automation-controller-ops
description: >-
  Ansible Automation Platform Controller: workflows, job templates, RBAC, SSOT
  inventory integration. Use when deploying to Controller or connecting CMDB/cloud
  inventory. Standard example maps type playbook to job template.
---

# Controller and Operations

Docs: `operations/controller-and-workflows.md`, `operations/inventory-ssot-integration.md`

## Map example to Controller

| GPA | Standard example |
|-----|----------------|
| Type playbook | `examples/standard-rsyslog-forwarding/playbooks/type_linux_logging.yml` |
| Sample inventory | `examples/standard-rsyslog-forwarding/inventory/sample/` |
| Prod inventory | CMDB plugin (not in example tree) |

Light example: CLI from `examples/light-dev-packages/` — no prod template required.

## Job template rules

- No desired state in prod extra vars
- Runbook in description
- Limit documented

## Agent behavior

- Declare active mode per [AGENTS.md](../../AGENTS.md).
- Reference example playbook path for template configuration; do not duplicate inventory YAML.
