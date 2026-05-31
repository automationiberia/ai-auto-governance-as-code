---
name: automation-pre-commit
description: >-
  Enforces mandatory pre-commit hooks for Ansible at automation-home repo root:
  ansible-lint, yamllint, black, pylint, YAML checks. Use when setting up dev environment,
  fixing hook failures, or before commit/PR.
---

# Pre-commit (Mandatory)

Policy: `automation-whitepaper/quality/pre-commit.md`
Config template: copy `automation-whitepaper/templates/automation-repo.pre-commit-config.yaml` to `<automation-repo>/.pre-commit-config.yaml` (not the automation-home root config — yamllint paths differ).

## Setup

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
pip install -r "$AUTOMATION_HOME/requirements-dev.txt"

export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
cd "$AUTOMATION_REPO"
pre-commit install    # after git init under deliveries/ — see git-automation-repository.md
pre-commit run --all-files
```

## Rules

- Run from each `<automation-repo>` under `deliveries/` (hooks are per delivery)
- Optionally run from `<automation-home>` for examples under `automation-whitepaper/examples/`
- No `--no-verify` without automation lead approval
- Profile: `automation-whitepaper/.ansible-lint`
- Python: `black` + `pylint` on `*.py` (see root `pyproject.toml`; skipped if no Python files)

## Examples to validate after edits

- `automation-whitepaper/examples/light-dev-packages/`
- `automation-whitepaper/examples/standard-rsyslog-forwarding/`

## Agent behavior

- Declare active mode per [AGENTS.md](../../AGENTS.md) (lint fixes often follow **Mode 1 — The Auditor**).
- Suggest `pre-commit run --all-files` after YAML changes; point to file path fixes, not pasted snippets.
