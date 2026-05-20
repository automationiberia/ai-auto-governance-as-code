---
name: automation-lifecycle
description: >-
  Extends an existing capability in the shared deliveries/automation collection:
  same repo, same function role, new platform tasks or inventory. Not greenfield.
---

# Automation Lifecycle (changes)

Extend: `automation-whitepaper/guides/extending-existing-automation.md`  
Checklist: `automation-whitepaper/guides/create-new-automation-step-by-step.md` (sections 5–6)

## Paths

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

## Extend — do / don't

| Change | Do | Don't |
|--------|-----|--------|
| New OS | `roles/<fn>/tasks/platforms/Windows.yml` | New role `<fn>_windows` |
| New NTP server | `inventory/sample/group_vars/all/*.yml` | Hardcode in tasks |
| New host type | `playbooks/type_<new>.yml` + inventory group | New Git repo |
| Unrelated capability | New `roles/<other>/` in **same** collection | New `deliveries/<initiative>/` repo |

## Workflow

1. `cd "$AUTOMATION_REPO"`
2. `git checkout -b feature/<ticket>-short-name`
3. Update `docs/<function>/DESIGN.md`, repo `CHANGELOG.md`, `RUNBOOK.md`, inventory
4. Modify existing role; loops use `loop_control.loop_var` + `__` prefix (never `item`); add `collections/requirements.yml` if needed
5. `ansible-galaxy collection install -r collections/requirements.yml` (if present)
6. `--syntax-check` all affected type playbooks; `pre-commit run --all-files`
7. Commit; open PR on the **collection** repo

## Required after change

- Same function role (no `*_windows` clone role)
- `CHANGELOG.md` updated
- All type playbooks pass syntax-check and pre-commit

## Agent behavior

- Fix skills/docs if wrong, delete `deliveries/automation/` and legacy dirs, restart from new-automation task 1.
