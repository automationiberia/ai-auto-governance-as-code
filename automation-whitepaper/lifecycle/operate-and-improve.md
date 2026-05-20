# Operate and Improve

## 1. Operations handover

Before declaring an automation "production ready," deliver to **Systems / Operations**:

| Deliverable | Content |
|-------------|---------|
| **Runbook** | When job runs, who approves, expected duration, failure contacts |
| **Job template doc** | Inventory, credentials, limits, tags, extra vars policy |
| **Monitoring** | Controller webhook or export to monitoring stack; alert on failure |
| **Known limitations** | Non-idempotent steps, no check mode, manual rollback steps |

Operations is **accountable** for executing or scheduling approved templates; automation team remains **responsible** for code defects.

---

## 2. Day-2 operations

| Activity | Frequency | Owner |
|----------|-----------|-------|
| Review failed jobs | Daily (NOC) / weekly (automation) | Operations + automation |
| Credential expiry check | Monthly | Platform engineer |
| Collection CVE / updates | As announced | Automation team |
| Inventory drift vs CMDB | Monthly | CMDB owner with automation support |
| Access review (Controller RBAC) | Annual | Security |

---

## 3. Incident linkage

When automation contributes to an incident:

1. Preserve Controller job output and version (collection commit, EE image digest)
2. Post-incident: was idempotency violated? wrong inventory? missing CAB?
3. Backlog item if code fix; process fix if governance gap

**Service Desk** communicates to users; automation team provides technical timeline.

---

## 4. Continuous improvement

### 4.1 Metrics (examples)

- Job success rate by template
- Mean duration trend (regression detection)
- Manual toil hours avoided (estimate from intake)
- Lint violations open per repository

### 4.2 Tech debt types

| Debt | Remediation |
|------|-------------|
| Legacy shell tasks | Replace with modules or documented `changed_when` |
| Numbered playbooks (`01_`, `02_`) | Consolidate to type playbook + workflow |
| Host lists in variables | Refactor to inventory groups |
| Unpinned collections | Pin in `requirements.yml` / EE |

### 4.3 GPA alignment

When [Automation Good Practices](https://github.com/redhat-cop/automation-good-practices) updates:

1. Diff relevant sections
2. Raise standards PR for department lint/profile
3. Schedule hygiene stories in quarterly sprint

---

## 5. Retirement

Retire automation when:

- Target platform decommissioned
- Replaced by new role/workflow
- Superseded by SaaS native automation

**Steps:**

1. Disable schedules and remove execute permissions
2. Archive Git repo or tag final version
3. Update CMDB / documentation
4. Inform CAB delegate and Operations

---

## 6. Related documents

- [../operations/controller-and-workflows.md](../operations/controller-and-workflows.md)
- [../governance/organizational-model-and-stakeholders.md](../governance/organizational-model-and-stakeholders.md)
