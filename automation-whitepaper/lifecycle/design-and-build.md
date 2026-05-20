# Design and Build

## 1. Design activities

### 1.1 Map to structure

Assign the initiative to:

- **Landscape** (e.g. "ERP three-tier production")
- **Type(s)** (web, app, database)
- **Function roles** (reused across types)
- **Components** (task files inside roles)

Reference: [../architecture/landscape-type-function-component.md](../architecture/landscape-type-function-component.md).

### 1.2 Define interfaces

- Public variables in `defaults/main.yml` with role prefix (`myrole_`)
- `meta/argument_specs.yml` for validation (ansible-core 2.11+)
- Document replaced vs modified config files in role README

### 1.3 Inventory and SSOT

| Data needed | SSOT | Inventory representation |
|-------------|------|--------------------------|
| VM name, IP (cloud) | Cloud API | Dynamic inventory plugin |
| OS baseline | Systems standard | `group_vars/all` |
| App version To-Be | CMDB or app team | `group_vars/<app>/` |
| Connection/bastion | Network | `host_vars/<host>/ansible.yml` |

Never mix As-Is discovery values with To-Be desired state under the same variable name.

### 1.4 Cross-team design review

Minimum attendees:

- Automation engineer (author)
- Operations or Systems representative
- Application representative (if type is application-specific)
- Security (if elevation, secrets, or data handling)

**Output:** design note (1–3 pages) attached to ticket.

---

## 2. Build standards

### 2.1 Repository layout

```
collection_or_project/
├── playbooks/          # Type playbooks (thin)
├── roles/              # Functions
├── inventory/          # Structured directory (or separate repo)
├── collections/        # If using ansible-builder EE
└── .ansible-lint       # Department profile
```

### 2.2 Implementation order

1. Scaffold role(s) with standard skeleton
2. `defaults/` + `vars/` platform files before tasks
3. Tasks with idempotency and check mode
4. Thin type playbook
5. Inventory sample for CI
6. README and examples

### 2.3 Coding rules (summary)

Full detail: [../development/](../development/).

- Functionality-focused roles, not product marketing names only
- No host group names hardcoded in roles—use variables
- Prefix sub-task file names in task `name:` (e.g. `dns | Ensure zone configured`)
- Prefer `include_role` entry points for collections exposing multiple capabilities

---

## 3. Build phase exit checklist

- [ ] Design note approved by consulted teams
- [ ] Code in Git with PR
- [ ] `ansible-lint` passes
- [ ] Syntax check passes
- [ ] README describes inputs, outcome, rollback limits
- [ ] No secrets in Git (Vault or Controller credentials)

---

## 4. Related documents

- [test-and-promote.md](test-and-promote.md)
- [../development/roles.md](../development/roles.md)
- [../examples/example-three-tier-landscape.md](../examples/example-three-tier-landscape.md)
