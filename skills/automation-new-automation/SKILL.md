---
name: automation-new-automation
description: >-
  New Ansible capability in the shared delivery collection under deliveries/automation/:
  galaxy.yml, one function role, type playbook, pre-commit. Not a new repo per automation.
  Use when creating automation greenfield.
---

# New Automation (Step-by-Step)

Checklist: `automation-whitepaper/guides/create-new-automation-step-by-step.md`
Git: `automation-whitepaper/guides/git-automation-repository.md`

## Paths (never hardcode workspace name)

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

**One collection, many roles.** Do not create `deliveries/<initiative-name>/` per automation.

## Collection setup

| Situation | Action |
|-----------|--------|
| `deliveries/automation/` missing | `git init`, copy `templates/delivery-collection.galaxy.yml` → `galaxy.yml`, lint templates, initial commit |
| Collection exists | Feature branch only; add new `roles/<function>/` |

## One function role per capability

Example: NTP → `roles/ntp_sync/`. Platform tasks → `tasks/platforms/<OsFamily>.yml`.
Do **not** create `ntp_sync_windows` or a second repo.

## Required artifacts (verify before done)

| Section | Files |
|---------|--------|
| Collection | `galaxy.yml`, `meta/runtime.yml`, `CHANGELOG.md`, collection `README.md` |
| Intake / design | `docs/<function>/INTAKE.md`, `docs/<function>/DESIGN.md` |
| Repo config | `ansible.cfg` (`roles_path = roles`) |
| Role | `roles/<function>/` — `defaults`, `tasks/main.yml`, `set_vars.yml` if multi-OS, `tasks/platforms/`, `handlers`, `templates` with `{{ ansible_managed \| comment }}`, `meta/argument_specs.yml`, **`README.md`**. Loops: `loop_control.loop_var` with `__<function>_…` (never bare `item`) |
| Playbook | `playbooks/type_<category>.yml` (roles only) |
| Inventory | `inventory/sample/groups_and_hosts` + `group_vars/` |
| Operate | `RUNBOOK.md` (generic `$AUTOMATION_HOME` paths) |
| Verify | `ansible-playbook --syntax-check`; `pre-commit run --all-files` **(gate)** |

## Workflow

1. Tooling: `pip install -r requirements-dev.txt`
2. Ensure `$AUTOMATION_REPO` exists (init collection if needed)
3. `git checkout -b feature/<ticket>-<function>-short-name`
4. Add role + playbook + docs + inventory
5. Verify and commit

## Agent behavior

- Declare active mode per [AGENTS.md](../../AGENTS.md) (this workflow is **Mode 2 — The Builder**).
- Generic paths only in generated docs.
- If collection model is wrong in skills/docs, fix them, **delete** `deliveries/automation/` and any legacy per-initiative dirs, restart from task 1.
