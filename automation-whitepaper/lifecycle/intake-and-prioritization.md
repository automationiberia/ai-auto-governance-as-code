# Intake and Prioritization

## 1. Intake channels

Accept requests through existing enterprise channels where possible:

- ITSM tool (ServiceNow, Jira Service Management, GLPI, etc.)
- Internal automation backlog (epic in dev platform)
- Architecture or change forums

**Required fields in request:**

1. Problem statement (outcome, not "write a playbook for X")
2. Frequency and scale (hosts, environments)
3. Risk if manual process continues
4. Affected services / applications
5. Requester and business owner

---

## 2. Triage questions (automation team)

| Question | If "no" → |
|----------|-----------|
| Is the task repeated more than a few times per year? | Defer or document manual runbook only |
| Is outcome definable as desired state? | May need discovery spike |
| Is there an API/module/role path (not only shell)? | Higher cost; flag in estimate |
| Is SSOT available for required inventory data? | Plan CMDB/cloud integration first |
| Does production impact require CAB? | Plan change process early |

---

## 3. Prioritization criteria

Score initiatives (example model):

| Criterion | Weight |
|-----------|--------|
| Risk reduction (security, compliance) | High |
| Time saved (FTE hours/year) | Medium |
| Error reduction / audit evidence | Medium |
| Strategic alignment (cloud migration, standard OS) | Medium |
| Implementation cost | Negative |

**Consulted:** Business owner, Operations manager.  
**Informed:** PMO for large landscapes.

---

## 4. Outcomes of intake

| Decision | Next step |
|----------|-----------|
| **Accept** | Assign engineer; link to design template |
| **Defer** | Backlog with revisit date |
| **Reject** | Document reason; suggest alternative (manual, vendor tool) |
| **Split** | Separate infrastructure vs application automation tracks |

---

## 5. Stakeholder notification

| Stakeholder | When informed |
|-------------|---------------|
| Application team | When automation touches app tier |
| Security | When privileged access or destructive actions |
| CAB delegate | When production change expected within quarter |

---

## 6. Related documents

- [../governance/organizational-model-and-stakeholders.md](../governance/organizational-model-and-stakeholders.md)
- [design-and-build.md](design-and-build.md)
