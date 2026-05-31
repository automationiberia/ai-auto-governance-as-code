---
name: automation-quality-gates
description: >-
  Quality gates: mandatory pre-commit at automation-home, idempotency, check mode,
  PR review checklists. Use before merge or when tests fail. Validates example
  trees under automation-whitepaper/examples/.
---

# Quality Gates

## Mandatory

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
cd "$AUTOMATION_HOME"
pre-commit run --all-files
```

Plus: syntax-check, check mode, second run `changed=0`, peer review.

Docs: `quality/pre-commit.md`, `quality/idempotency-and-check-mode.md`, `quality/code-review-and-linting.md`

## After editing examples

Lint covers `automation-whitepaper/examples/light-dev-packages/` and `standard-rsyslog-forwarding/`.

## Profile extras

| | Light | Standard | Heavy |
|-|-------|----------|-------|
| Molecule | Optional | If shared | Required |
| Security review | No | If privileged | Yes |

## Agent behavior

- Declare active mode per [AGENTS.md](../../AGENTS.md) (reviews are typically **Mode 1 — The Auditor**).
- Run or suggest pre-commit; checklist findings with links to files to fix.
