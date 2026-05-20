# Example: Three-Tier Landscape

Practical mapping of [landscape → type → function → component](../architecture/landscape-type-function-component.md).

---

## 1. Business context

Deploy a standard three-tier application:

- Web (Apache)
- Middleware (JBoss)
- Database (PostgreSQL)

**Stakeholders:** Application team (JBoss config), DBA (PostgreSQL), Systems (OS baseline), Network (load balancer VIP in inventory), CAB (production workflow).

---

## 2. Repository layout

```
three_tier_collection/
├── playbooks/
│   ├── landscape_three_tier.yml    # imports type playbooks
│   ├── type_web_frontend.yml
│   ├── type_middleware.yml
│   └── type_database.yml
├── roles/
│   ├── vm_provision/
│   ├── base_linux/
│   │   └── tasks/
│   │       ├── main.yml
│   │       ├── dns.yml      # component
│   │       ├── ntp.yml
│   │       └── ssh.yml
│   ├── apache/
│   ├── jboss/
│   └── postgresql/
└── README.md
```

---

## 3. Type playbook (thin)

**`playbooks/type_middleware.yml`:**

```yaml
---
- name: Deploy middleware server type
  hosts: middleware
  gather_facts: true
  become: true
  roles:
    - vm_provision
    - base_linux
    - jboss
```

---

## 4. Landscape orchestration

**Option A — Controller workflow:** three job templates (web, middleware, database) with dependencies.

**Option B — Playbook of playbooks:**

```yaml
---
- name: Landscape three-tier
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Import web tier type
      ansible.builtin.import_playbook: type_web_frontend.yml

    - name: Import middleware tier type
      ansible.builtin.import_playbook: type_middleware.yml

    - name: Import database tier type
      ansible.builtin.import_playbook: type_database.yml
```

---

## 5. Test type (reuse functions)

Integrated test server combining all functions in **one** type playbook for lab—valid exception per GPA.

---

## 6. Inventory snippet

**`inventory/groups_and_hosts`:**

```ini
[web_frontend]
web01.example.com
web02.example.com

[middleware]
mw01.example.com

[database]
db01.example.com

[three_tier:children]
web_frontend
middleware
database
```

**`group_vars/middleware/jboss.yml`:** application To-Be variables owned by Application team.

---

## 7. Checklist applied

- [x] One playbook per type
- [x] Functions as roles
- [x] Components as task files in `base_linux`
- [x] Landscape via workflow or import
- [x] Cross-team variables in inventory, not hardcoded groups in roles

---

## 8. Related documents

- [example-inventory-good-vs-bad.md](example-inventory-good-vs-bad.md)
- [example-spanish-enterprise-change-flow.md](example-spanish-enterprise-change-flow.md)
