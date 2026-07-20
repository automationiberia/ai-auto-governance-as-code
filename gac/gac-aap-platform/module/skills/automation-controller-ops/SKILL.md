---
name: automation-controller-ops
description: >-
  Ansible Automation Platform Controller: workflows, job templates, RBAC, SSOT
  inventory integration, and routing to platform MCP skills.
  Use when deploying to Controller, connecting CMDB/cloud inventory, or operating live AAP.
user-invocable: true
metadata:
  author: gac
  version: "1.0"
---

# Controller and Operations

Docs: `operations/controller-and-workflows.md`, `operations/inventory-ssot-integration.md`, `operations/aap-platform-administration.md`

## Git-side standards

### Map example to Controller

| GPA | Standard example |
|-----|------------------|
| Type playbook | `examples/standard-rsyslog-forwarding/playbooks/type_linux_logging.yml` |
| Sample inventory | `examples/standard-rsyslog-forwarding/inventory/sample/` |
| Prod inventory | CMDB plugin (not in example tree) |

Light example: CLI from `examples/light-dev-packages/` — no prod template required.

### Job template rules

- No desired state in prod extra vars
- Runbook in description
- Limit documented
- Name pattern: `landscape_type_environment`

## Platform skill routing (live AAP via MCP)

When the user intent is **live platform** operation (not Git YAML authoring), route to `skills/aap-*`. Requires MCP — see [TOOL-SETUP.md](../../../../skills/TOOL-SETUP.md#mcp-aap-platform-skills).

| User intent | Platform skill |
|-------------|----------------|
| Full platform snapshot / pre-change baseline | [aap-live-snapshot](../aap-live-snapshot/SKILL.md) |
| RBAC / who can execute a template | [aap-rbac-review](../aap-rbac-review/SKILL.md) |
| Check job status / failed jobs | [aap-job-status](../aap-job-status/SKILL.md) |
| Launch approved job template | `aap-job-executor` (Phase 3 — planned) |
| Create job template from Git type playbook | `aap-job-template-create` (Phase 2 — planned) |
| Update template inventory/credential bundle | `aap-template-bundle-update` (Phase 2 — planned) |

**Handoff:** Mode 2 **Builder** produces Git artifacts (`type_*.yml`, roles) → Platform **Build** wires Controller (later phase).

## Agent behavior

- Declare active mode per [AGENTS.md](../../../../AGENTS.md).
- For Git content: reference example playbook paths; do not duplicate inventory YAML.
- For live AAP: declare platform area (Audit / Operate / Build / Maintain) and load the matching platform skill.
- SSOT: prod inventory via CMDB/cloud — block manual inventory curation skills in prod orgs.
