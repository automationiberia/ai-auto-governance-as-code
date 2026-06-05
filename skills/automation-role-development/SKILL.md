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
- **No redundant variables:** do not copy a public var into an internal fact
  when the value is identical (e.g. `set_fact: __foo_mode: "{{ foo_mode }}"`).
  Resolve once in a single task, or use the source variable directly in
  `when:` / templates. Internal facts are for *derived* state only.
- **Consolidate derived state:** related computed values (report fields, parsed
  lines, exit-code checks) belong in one `set_fact` with a `vars:` block, not
  spread across several tasks.
- **Lists for repeated semantics:** when a condition uses the same set of codes,
  states, or tags in multiple tasks (e.g. `changed_when`, `failed_when`, report
  fields), define one `rolename_*` list in `defaults/main.yml` and reference it
  everywhere — never hardcode the same list in several files.
- **Facts via `ansible_facts['name']`:** never use injected `ansible_*` shortcuts
  (`ansible_distribution`, `ansible_date_time`, …). Use bracket notation, e.g.
  `ansible_facts['date_time']['iso8601']`. Requires `gather_facts: true` when
  using setup facts. See `automation-good-practices/roles/README.adoc`.

Narrative only: `examples/example-role-interface.md`

## Agent behavior

- Declare active mode per [AGENTS.md](../../AGENTS.md) (review → **Auditor**; new role → **Architect**).
- Edit files under `roles/<name>/`; cite paths in review comments.
