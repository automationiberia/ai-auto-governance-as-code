---
name: automation-playbook-inventory
description: >-
  Thin playbooks, inventory structure, SSOT, As-Is vs To-Be, variable precedence.
  Use for playbooks, inventory directories, or variable debugging. Examples in
  automation-whitepaper/examples/*/playbooks and inventory/.
---

# Playbooks and Inventory

Docs: `development/playbooks.md`, `development/inventories-and-variables.md`

## Example inventory (real files)

| Profile | Playbook | Inventory |
|---------|----------|-----------|
| Light | `examples/light-dev-packages/playbooks/type_dev_linux.yml` | `examples/light-dev-packages/inventory/lab/` |
| Standard | `examples/standard-rsyslog-forwarding/playbooks/type_linux_logging.yml` | `examples/standard-rsyslog-forwarding/inventory/sample/` |

Run from `<example-root>` with `ANSIBLE_ROLES_PATH=roles`.

## Rules

- To-Be in inventory; not prod extra vars
- No host lists in variables
- Thin playbook

Bad vs good narrative: `examples/example-inventory-good-vs-bad.md` (GPA reference code in `automation-good-practices/`)

## Agent behavior

- Declare active mode per [AGENTS.md](../../../../AGENTS.md).
- Fix inventory/playbook files in repo; link paths instead of duplicating YAML.
