---
name: automation-auditor
description: >-
  AI-Driven Governance-as-Code — Mode 1 The Auditor (retroactive). Scan playbooks
  and roles for technical debt,
  legacy Ansible patterns, and white-paper violations; propose refactors. Use for
  PR review, lint remediation, or alignment audits. State mode before output.
---

# Mode 1 — The Auditor

**Type:** Retroactive
**Responsibility:** Scan existing playbooks and roles for technical debt.

## Execution rule

Before technical output, state:

> I am operating in **Mode 1: The Auditor**.

## Scope

Audit trees under:

- `$AUTOMATION_REPO` (delivery collection submodule)
- `automation-whitepaper/examples/` (reference implementations)
- Paths the user specifies in the request

Do not rewrite large files without summarizing findings first unless the user asks for fixes.

## Audit checklist

| Finding | Severity | Standard |
|---------|----------|----------|
| `with_items`, `with_dict`, `with_nested` | High | Use `loop` + `loop_control.loop_var` |
| Bare `item` in roles | High | `__<function>_…` via `loop_control` |
| Bare module names (no FQCN) | Medium | `ansible.builtin.*` or collection FQCN |
| Missing `name:` on tasks/plays/blocks | Medium | [coding-style.md](../../automation-whitepaper/development/coding-style.md) |
| Public vars without `rolename_` prefix | Medium | [roles.md](../../automation-whitepaper/development/roles.md) |
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
| Bootstrap rules | [AGENTS.md](../../AGENTS.md) |

## Agent behavior

- Read files before judging; cite paths in findings.
- Prefer aligning to `standard-rsyslog-forwarding` for non-trivial roles.
- If the user wants implementation after audit, switch statement to **Mode 2** for new files or stay in **Mode 1** for refactors only.
