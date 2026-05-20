---
name: automation-role-development
description: >-
  Ansible role standards: naming, defaults, platform vars, idempotency,
  argument_specs. Use when writing or reviewing roles. Reference implementations
  in automation-whitepaper/examples/*/roles/.
---

# Role Development

Doc: `automation-whitepaper/development/roles.md`

## Reference roles (open files, do not paste)

| Example | Path |
|---------|------|
| Minimal (light) | `examples/light-dev-packages/roles/dev_troubleshoot_packages/` |
| Full (standard) | `examples/standard-rsyslog-forwarding/roles/rsyslog_forward/` |

Study: `tasks/set_vars.yml`, `meta/argument_specs.yml`, `templates/*.j2` in standard tree.

## Rules

- `rolename_*` public; `__rolename_*` internal
- `role_path` in includes
- No hardcoded inventory groups
- README + idempotency/check mode

Narrative only: `examples/example-role-interface.md`

## Agent behavior

Edit files under `roles/<name>/`; cite paths in review comments.
