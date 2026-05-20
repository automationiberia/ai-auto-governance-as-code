# Roles — Development Standards

Consolidated from GPA **Roles** section. Roles host most automation logic.

---

## 1. Design

### 1.1 Functionality, not implementation

Design for **outcome** (e.g. "time synchronization configured"), not only a specific daemon—unless implementations diverge too much (postfix vs sendmail → separate roles).

### 1.2 Consumer-facing interface

Prefer a facade role (e.g. `mycollection.run`) with an `actions` list over exposing many internal roles:

```yaml
- hosts: all
  gather_facts: false
  tasks:
    - name: Perform several actions
      ansible.builtin.include_role:
        name: mycollection.run
      vars:
        actions:
          - name: thing_1
            vars:
              thing_1_var_1: 1
          - name: thing_2
            vars:
              thing_2_var_1: 1
```

### 1.3 Coupling

- Avoid hard dependencies on fixed group names or undeclared variables
- Extract shared content to a `common` role within the collection when appropriate

---

## 2. Naming

| Element | Rule |
|---------|------|
| Role name | No dashes (collections compatibility) |
| Public variables | Prefix with role name: `foo_packages` not `packages` |
| Custom modules in role | `foo_module` prefix |
| Internal variables | `__foo_internal` (double underscore) |
| Loop variables in roles | `loop_control.loop_var: __foo_*` — never bare `item` |
| Tags | Prefix with role name or unique prefix |
| `set_fact` / `register` | Treated as global—prefix like variables |

---

## 3. Variables: defaults vs vars

| File | Use |
|------|-----|
| `defaults/main.yml` | Every user-facing input with default; document here |
| `vars/main.yml` | Constants, package lists, "magic values" not meant to override |
| Commented defaults | Required vars with no safe default—comment in defaults |

Do not embed large lists in tasks. Do not use `vars/main.yml` for overridable defaults (precedence too high).

---

## 4. Platforms and providers

### 4.1 Platform variables

Load most specific `vars/` file via loop (least → most specific):

- `RedHat.yml`, `RedHat_8.yml`, etc.
- Use `{{ role_path }}/vars/...` in paths
- Use `loop_control.loop_var` with an internal name (`__rolename_vars_candidate`), not `item`
- Optional: `tasks/set_vars.yml` for tests with `tasks_from: set_vars.yml`

```yaml
- name: Set platform/version specific variables
  ansible.builtin.include_vars: "{{ __foo_vars_file }}"
  loop:
    - "{{ ansible_facts['os_family'] }}.yml"
  loop_control:
    loop_var: __foo_vars_candidate
  vars:
    __foo_vars_file: "{{ role_path }}/vars/{{ __foo_vars_candidate }}"
  when: __foo_vars_file is file
```

### 4.2 Platform tasks

Use `lookup('first_found')` for **one** task file per host (most specific wins), with `tasks/setup/default.yml` fallback.

### 4.3 Providers

Variable: `rolename_provider`. If unset, detect running provider; respect existing install. Export `rolename_provider_os_default` for OS-wide consistency.

---

## 5. Quality attributes

| Attribute | Expectation |
|-----------|-------------|
| **Idempotency** | Second run: no spurious changes |
| **Check mode** | Supported or documented exception |
| **Argument validation** | `meta/argument_specs.yml` when using ansible-core 2.11+ |
| **Templates** | `{{ ansible_managed | comment }}` header; no `Last modified: {{ date }}` |
| **Backups** | `backup: true` on template/file modules unless requested configurable |

---

## 6. Structure and maintainability

- Scaffold with `ansible-galaxy init` / department skeleton
- Prefix sub-task names: `sub | Some task` in `tasks/sub.yml`
- Do not use inventory group names in roles—use host variables (lists)
- Meaningful README: purpose, variables, examples, idempotency, rollback limits

---

## 7. Host groups anti-pattern

**Do not** hardcode `groups['my_cluster']` in roles.

**Do** accept `cluster_members: [...]` from inventory.

See [../examples/example-inventory-good-vs-bad.md](../examples/example-inventory-good-vs-bad.md).

---

## 8. Related documents

- [playbooks.md](playbooks.md)
- [inventories-and-variables.md](inventories-and-variables.md)
- [../quality/idempotency-and-check-mode.md](../quality/idempotency-and-check-mode.md)
- [../examples/example-role-interface.md](../examples/example-role-interface.md)
