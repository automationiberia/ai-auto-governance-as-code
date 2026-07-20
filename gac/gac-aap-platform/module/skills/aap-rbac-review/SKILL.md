---
name: aap-rbac-review
description: >-
  Reviews Ansible Automation Platform RBAC — users, teams, roles, and object
  permissions — via MCP. Use for access audits narrower than a full platform snapshot.
domain: platform-administration
skill_plane: platform
platform_areas:
  - audit
lifecycle_stages:
  - 6
profile_min: standard
whitepaper: automation-whitepaper/operations/aap-platform-administration.md
mcp_domains:
  - user-management
  - security-compliance
  - job-management
  - platform-configuration
write_capability: false
human_gate: none
triggers:
  - rbac audit
  - who can execute
  - access control review
  - team permissions
---

# AAP RBAC Review

Enterprise-adapted from [AAP Skills Library](https://github.com/automationiberia/aap-skills-library). Upstream reference: `skills/vendor/aap-skills-library/skills/aap-rbac-review/`.

## Execution rule

Before output, state:

> Platform area: **Audit** (read-only). I have evaluated Red Hat CoP baseline rules against white book overrides.

## Scope

- **Does:** Focused access-control report — organizations, teams, users, role assignments, object permissions.
- **Does not:** Modify RBAC; replace formal Information Security access review sign-off.

## Enterprise constraints

- Read-only — never modify users, teams, or role assignments.
- Align findings with [controller-and-workflows.md](../../../../../../automation-whitepaper/operations/controller-and-workflows.md) §4 RBAC tiers (Admin / Execute / Read).
- Flag admin roles outside the automation platform team; cross-org access; orphaned assignments.
- Prefer least detail necessary — confirm before dumping full user lists in shared channels.
- Schedule output supports Security access review cadence — not a substitute for signed review.

## MCP routing

- user-management → users, teams, organizations, roles
- security-compliance → audit data when available
- job-management / platform-configuration → object-level role context

Always inspect MCP tool schemas before calling.

## Procedure

1. Scope the review (organization, team, user, or specific object such as a job template).
2. Collect users, teams, roles via MCP.
3. Correlate object permissions when requested (e.g. execute on named job template).
4. Highlight risks: excessive admin, orphaned assignments, cross-org access.
5. Output **Findings** with recommended follow-ups.

## Output format

Structured tables:

- Teams → members → roles
- Object → assigned teams/roles → permission type
- **Findings** — risks and recommended follow-ups

## Cross-skill routing

| Intent | Route to |
|--------|----------|
| Full platform state | [aap-live-snapshot](../aap-live-snapshot/SKILL.md) |
| Stakeholder / CAB context | [automation-governance](../automation-governance/SKILL.md) |
| Controller RBAC standards | [automation-controller-ops](../../automation-controller-ops/SKILL.md) |

## Agent behavior

- Read-only only.
- Never expose credentials or personal data beyond what the review scope requires.
