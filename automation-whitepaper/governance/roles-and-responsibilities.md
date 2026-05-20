# Roles and Responsibilities (RACI)

RACI: **R**esponsible, **A**ccountable, **C**onsulted, **I**nformed.

---

## 1. Automation initiative (new or major change)

| Activity | Automation dept | Business / App | Systems / Ops | Security | CAB | CMDB |
|----------|-----------------|----------------|---------------|----------|-----|------|
| Submit use case | I | R | C | I | I | I |
| Prioritize backlog | A/R | C | C | I | I | I |
| Architecture (L/T/F) | R/A | C | C | C | I | C |
| Implement roles/playbooks | R/A | C | C | C | I | I |
| CI / lint / molecule | R/A | I | I | I | I | I |
| UAT in pre-production | R | R/A | C | I | I | I |
| Security sign-off (high risk) | R | I | C | A/R | I | I |
| CAB approval (production) | R | C | C | C | A/R | C |
| Production execution | R | I | C | I | I | I |
| CMDB / To-Be update | C | I | C | I | I | R/A |
| Operations handover | R/A | I | R | I | I | I |
| Post-implementation review | R | C | C | C | I | C |

---

## 2. Ongoing operations

| Activity | Automation dept | Operations | NOC | Security |
|----------|-----------------|------------|-----|----------|
| Controller platform health | R/A | I | I | C |
| Credential rotation | R | C | I | A |
| Role/collection upgrades | R/A | C | I | C |
| Job failure triage | C | R/A | C | I |
| Standards / GPA alignment | R/A | I | I | I |

---

## 3. Inventory and data ownership

| Data type | Accountable owner | Automation role |
|-----------|-------------------|-----------------|
| Host existence (cloud/VM) | Cloud / Systems | Consume via dynamic inventory |
| IP/DNS (static DC) | Network / Systems | Model in inventory To-Be |
| Application config desired state | Application | Provide group_vars contract |
| Organizational metadata (owner, cost center) | CMDB | Sync into inventory |
| Automation-only metadata | Automation | `group_vars` not present elsewhere |

Principle: **inventory combines SSOTs**; it is not the SSOT for data owned elsewhere unless explicitly agreed.

See [../operations/inventory-ssot-integration.md](../operations/inventory-ssot-integration.md).

---

## 4. Decision rights

| Decision | Accountable |
|----------|-------------|
| Adopt breaking GPA-derived standard | Automation lead + architect |
| Exception to naming / structure rules | Automation lead (documented ADR) |
| Production job template ACL | Security + Operations |
| Use of extra vars in production | Automation lead (discouraged; debug only) |

---

## 5. Related documents

- [organizational-model-and-stakeholders.md](organizational-model-and-stakeholders.md)
- [../01-main-guide.md](../01-main-guide.md)
