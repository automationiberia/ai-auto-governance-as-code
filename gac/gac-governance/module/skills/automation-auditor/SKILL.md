---
name: automation-auditor
description: >-
  AI-Driven Governance-as-Code — Mode 1 The Auditor (retroactive). Scan playbooks
  and roles for technical debt,
  legacy Ansible patterns, and white-paper violations; propose refactors. Use for
  PR review, lint remediation, or alignment audits. State mode before output.
user-invocable: true
metadata:
  author: gac
  version: "1.0"
---

# Mode 1 — The Auditor

**Type:** Retroactive
**Responsibility:** Scan legacy or incoming codebases for technical debt; output gap analysis and remediating diffs.

## Execution rule

Before technical output, state:

> I am operating in **Mode 1: The Auditor**. I have evaluated Red Hat COP baseline rules against white book overrides.

## Scope

**Content audit** (this skill) — YAML and Git artifacts:

- `$AUTOMATION_REPO` (delivery collection submodule)
- `automation-whitepaper/examples/` (reference implementations)
- Paths the user specifies in the request

**Platform audit** (separate plane) — live AAP state via MCP:

- [aap-live-snapshot](../aap-live-snapshot/SKILL.md) — full snapshot
- [aap-rbac-review](../aap-rbac-review/SKILL.md) — focused RBAC

Declare platform area when using platform skills; do not conflate with content Mode 1 findings.

Do not rewrite large files without summarizing findings first unless the user asks for fixes.

## Audit checklist

| Finding | Severity | Standard |
|---------|----------|----------|
| `with_items`, `with_dict`, `with_nested` | High | Use `loop` + `loop_control.loop_var` |
| Bare `item` in roles | High | `__rolename_…` via `loop_control` |
| Bare module names (no FQCN) | Medium | `ansible.builtin.*` or collection FQCN |
| Missing `name:` on tasks/plays/blocks | Medium | [coding-style.md](../../../../automation-whitepaper/development/coding-style.md) |
| Public vars without `rolename_` prefix | Medium | [roles.md](../../../../automation-whitepaper/development/roles.md) |
| `command`/`shell` without `changed_when` / justification | Medium | Idempotency |
| Hardcoded inventory groups in roles | High | SSOT / inventory docs |
| `yes`/`no` booleans | Low | Use `true`/`false` |
| `.yaml` extension | Low | Use `.yml` |
| Per-initiative repo or duplicate `role_*_windows` clones | High | One collection, one function role |

## Output format

1. **Summary** — counts by severity
2. **Findings table** — file path, line (if known), rule, suggested fix
3. **Refactor plan** — ordered steps; link to example roles under `automation-whitepaper/examples/`
4. **Verification** — `pre-commit run --all-files`, `ansible-playbook --syntax-check`

## Cross-skill references

| Topic | Skill / doc |
|-------|-------------|
| Lint hooks | [automation-pre-commit](../automation-pre-commit/SKILL.md) |
| Role structure | [automation-role-development](../automation-role-development/SKILL.md) |
| Quality gates | [automation-quality-gates](../automation-quality-gates/SKILL.md) |
| Bootstrap rules | [AGENTS.md](../../../../AGENTS.md) |

## Agent behavior

- Read files before judging; cite paths in findings.
- Prefer aligning to `standard-rsyslog-forwarding` for non-trivial roles.
- If the user wants implementation after audit, switch statement to **Mode 2 — Builder** for new files or stay in **Mode 1** for refactors only.
