# Inventories and Variables

---

## 1. Single Source of Truth (SSOT)

Identify where each fact **originates**:

| SSOT type | Examples | Provides |
|-----------|----------|----------|
| Technical | Cloud API, Satellite, monitoring | As-Is: IPs, OS, power state |
| Managed | CMDB, ITSM | To-Be: owner, desired sizing, environment |
| Inventory static | Only data with no other home | Supplemental tags, automation metadata |

Combine with **dynamic inventory plugins** into one structured inventory directory.

See [../operations/inventory-ssot-integration.md](../operations/inventory-ssot-integration.md).

---

## 2. As-Is vs To-Be

| Kind | Ansible mechanism | Use |
|------|-------------------|-----|
| **As-Is** | Facts (`ansible_*`), registered vars | Current state for decisions |
| **To-Be** | Inventory variables | Desired state automation enforces |

**Never** use discovered RAM size as desired VM size without explicit mapping—automation may ignore drift.

---

## 3. Structured inventory directory

```
inventory/
├── groups_and_hosts      # No variables in this file
├── group_vars/
│   ├── all/
│   │   └── ansible.yml
│   └── middleware/
│       └── jboss.yml
├── host_vars/
│   └── host1.example.com/
│       ├── ansible.yml
│       └── satellite/
│           └── content_views.yml
└── dynamic_inventory_plugin.yml
```

**Conventions:**

- File names match role they configure (`jboss.yml` mirrors role defaults structure)
- `ansible.yml` for connection/become vars
- Subdirectories under `host_vars` for large variable sets (e.g. Satellite)

Reference tree: `automation-good-practices/inventories/inventory_example/`.

---

## 4. Loop hosts via inventory, not lists

**Bad:** `provision_hosts: [host1, host2]` on manager; play loops list.

**Good:** hosts in groups; `hosts: managed_hosts_a`; group_vars carry manager linkage.

Benefits: `--limit`, parallelism, no duplicate host definitions.

See [../examples/example-inventory-good-vs-bad.md](../examples/example-inventory-good-vs-bad.md).

---

## 5. Variable precedence (simplified)

Think in **lanes**:

1. **Defaults** — role `defaults/main.yml`
2. **Inventory** — desired state (group then host)
3. **Facts** — current state
4. **Role vars** — constants in `vars/main.yml`
5. **Scoped** — block/task vars
6. **Registered / set_fact** — runtime
7. **Extra vars** — override all (avoid for desired state)

**Department policy:**

- Avoid play `vars` and `include_vars` for desired state
- Avoid scoped vars except loops/temporaries
- Extra vars: debugging, break-glass `no_log`, safety prompts—not RAM size or app version

---

## 6. Extra vars examples (allowed vs not)

| Use case | Allowed in prod? |
|----------|------------------|
| `are_you_really_sure: true` before destructive play | Yes (safety) |
| Override fact for scale testing | Pre-prod only |
| `no_log_in_case_of_trouble: false` | Break-glass, audited |
| VM RAM size | **No** — inventory only |

---

## 7. Related documents

- [roles.md](roles.md)
- [../operations/inventory-ssot-integration.md](../operations/inventory-ssot-integration.md)
