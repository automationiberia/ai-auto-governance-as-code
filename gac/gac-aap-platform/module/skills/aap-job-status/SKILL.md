---
name: aap-job-status
description: >-
  Tracks Ansible Automation Platform job execution status via MCP. Use when the
  user asks to check, monitor, or follow up on a running or completed job.
user-invocable: true
triggers:
  - check job status
  - job finished
  - failed jobs
  - follow up on job
metadata:
  author: gac
  version: "1.0"
  domain: platform-administration
  skill_plane: platform
  platform_areas: [operate]
  lifecycle_stages: [6]
  profile_min: light
  whitepaper: automation-whitepaper/operations/aap-platform-administration.md
  mcp_domains: [job-management]
  write_capability: "false"
  human_gate: none
---

# AAP Job Status

Enterprise-adapted from [AAP Skills Library](https://github.com/automationiberia/aap-skills-library). Upstream reference: `skills/vendor/aap-skills-library/skills/aap-job-status/`.

## Execution rule

Before output, state:

> Platform area: **Operate** (read-only). I have evaluated Red Hat CoP baseline rules against white book overrides.

## Scope

- **Does:** Retrieve job state, duration, outcome, and failure summary via MCP.
- **Does not:** Cancel, relaunch, or modify jobs unless user explicitly requests a write skill (future `aap-job-executor`).

## Enterprise constraints

- Read-only — never cancel or relaunch without explicit user request and appropriate change control.
- Never expose credentials or secrets from job extra vars in output.
- Link failed jobs to runbooks documented on the job template description when available.
- For prod failures, recommend ITSM incident if not already filed.

## MCP routing

- job-management → jobs, job events, stdout (if exposed by MCP tools)

Always inspect MCP tool schemas before calling.

## Procedure

1. Resolve job by ID or search recent jobs for template name / organization.
2. Apply optional filters: status (running, failed, successful), organization, date range.
3. Fetch job detail and relevant events.
4. Return structured status summary.

## Output format

- Job ID, name, status, started/finished timestamps
- Job template and inventory used
- Failure summary (if failed) with link to job output when available

## Cross-skill routing

| Intent | Route to |
|--------|----------|
| Launch a job | `aap-job-executor` (Phase 3 — not yet in platform/) |
| Full platform context | [aap-live-snapshot](../aap-live-snapshot/SKILL.md) |
| Operate lifecycle | [automation-lifecycle](../automation-lifecycle/SKILL.md) |

## Agent behavior

- Complements [aap-job-executor](https://github.com/automationiberia/aap-skills-library/blob/main/skills/aap-job-executor/SKILL.md) for post-launch monitoring when that skill is adopted.
- Read-only default.
