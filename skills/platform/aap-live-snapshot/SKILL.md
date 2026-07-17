---
name: aap-live-snapshot
description: >-
  Generates a real-time Ansible Automation Platform snapshot via MCP for
  infrastructure visibility, operational auditing, and RBAC analysis. Use when
  the user requests a platform report, AAP audit, or pre-change baseline.
domain: platform-administration
skill_plane: platform
platform_areas:
  - audit
lifecycle_stages:
  - 6
profile_min: light
whitepaper: automation-whitepaper/operations/aap-platform-administration.md
mcp_domains:
  - job-management
  - inventory-management
  - system-monitoring
  - user-management
  - security-compliance
  - platform-configuration
write_capability: false
human_gate: none
triggers:
  - aap snapshot
  - automation platform report
  - ansible controller audit
  - eda status
  - mcp aap overview
---

# AAP Live Snapshot

Enterprise-adapted from [AAP Skills Library](https://github.com/automationiberia/aap-skills-library). Upstream reference: `skills/vendor/aap-skills-library/skills/aap-live-snapshot/`.

## Execution rule

Before output, state:

> Platform area: **Audit** (read-only). I have evaluated Red Hat CoP baseline rules against white book overrides.

Content Mode 1 (YAML audit) is a separate scope — use [automation-auditor](../../automation-auditor/SKILL.md) for Git artifacts.

## Scope

- **Does:** Full live platform snapshot via MCP (Controller, Hub, EDA, RBAC, infrastructure).
- **Does not:** Modify any AAP object; replace CMDB or Git as SSOT for desired state.

## Enterprise constraints

- Read-only — never mutate platform state during snapshot.
- Cross-check job templates against type playbooks under `$AUTOMATION_REPO/playbooks/` when user requests compliance correlation.
- Flag JT names that violate `landscape_type_environment` per [controller-and-workflows.md](../../../automation-whitepaper/operations/controller-and-workflows.md).
- Recommend snapshot before prod template or RBAC changes (platform Maintain/Build skills).

## MCP routing

All data via `aap-mcp-servers`. Inspect tool schemas before calling.

| Data | Domain |
|------|--------|
| Jobs, templates, schedules | job-management |
| Inventories, hosts | inventory-management |
| Health, topology | system-monitoring |
| Users, teams, RBAC | user-management |
| Compliance | security-compliance |
| Projects, credentials, EEs | platform-configuration |

## Procedure

1. Confirm target scope (organization, full platform, or component filter).
2. Retrieve live data per MCP routing; chain calls only when correlation requires it.
3. Render structured tables (see Output format).
4. Include analysis: failures, orphaned resources, risky RBAC, capacity anomalies.
5. End with **Key Findings** — critical risks, operational issues, recommended actions.

## Output format

Use dynamic tables: derive columns from MCP data; missing values → `-`; flatten nested objects (e.g. `project.name (id)`).

Section order:

1. Platform Overview (versions, topology)
2. Automation Execution (Controller jobs, templates, workflows, schedules, projects, inventories, hosts, EEs)
3. Automation Content (Hub)
4. Automation Decisions (EDA)
5. Infrastructure
6. Access Management (orgs, teams, users, roles, credentials)
7. Settings & Configuration
8. Analytics (job trends, failure rates)
9. **Key Findings**

Truncate tables >50 rows; split >12 columns into primary + extended sections.

## Cross-skill routing

| Intent | Route to |
|--------|----------|
| Focused RBAC only | [aap-rbac-review](../aap-rbac-review/SKILL.md) |
| Job outcome detail | [aap-job-status](../aap-job-status/SKILL.md) |
| Git YAML compliance | [automation-auditor](../../automation-auditor/SKILL.md) |
| Controller standards | [automation-controller-ops](../../automation-controller-ops/SKILL.md) |

## Agent behavior

- Live data only; never fabricate platform state.
- Never expose tokens or credentials.
- Prefer structured tables over bullet lists for object lists.
