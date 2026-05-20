# Playbooks — Development Standards

Type playbooks should be **thin orchestrators** of roles.

---

## 1. Keep playbooks simple

**Preferred:** list of roles only.

```yaml
---
- name: Deploy middleware server type
  hosts: middleware
  gather_facts: false
  become: true
  roles:
    - vm_provision
    - base_linux
    - jboss
```

Put logic in roles for reuse and testing.

---

## 2. `roles` section vs `tasks` section

| Use | When |
|-----|------|
| `roles:` | Static role list; order is clear |
| `tasks:` + `import_role` / `include_role` | Dynamic order, tags, or conditional inclusion |

**Do not mix** `roles:` and `tasks:` with roles in the same play—execution order is confusing.

---

## 3. Tags

Use tags for:

1. Role name (enable/disable one role in dev), or
2. **Meaningful purposes** (`deploy`, `configure`) that work **standalone**

**Do not** require tag sequences (`step1` then `step2`) for a valid run.

Document tags in playbook header or README.

**Example with `import_role`:**

```yaml
- name: Import base_linux
  ansible.builtin.import_role:
    name: base_linux
  tags:
    - base_linux
    - deploy
```

For `include_role`, duplicate tags on the task and use `apply:` for role tasks (more verbose—prefer `import_role` when static).

Reference implementation: `automation-good-practices/playbooks/playbook_role_tags/`.

---

## 4. Debug output

```yaml
- name: Verbose diagnostic (development only)
  ansible.builtin.debug:
    msg: "Detail for troubleshooting"
    verbosity: 2
```

Do not flood production logs with unscoped `debug` tasks.

---

## 5. Playbook anti-patterns

| Anti-pattern | Alternative |
|--------------|-------------|
| 50+ tasks in playbook | Move to roles |
| `vars:` in play for desired state | Inventory `group_vars` |
| `meta: end_play` | `meta: end_host` if needed |
| Variables in play name | Static play names |

---

## 6. Related documents

- [../architecture/landscape-type-function-component.md](../architecture/landscape-type-function-component.md)
- [roles.md](roles.md)
- [coding-style.md](coding-style.md)
