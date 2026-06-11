# Extending Existing Automation

> **Audit or refactor first?** See [evaluate-and-update-existing.md](evaluate-and-update-existing.md).

Changes apply inside the **shared delivery collection** `deliveries/automation/`. Extend the existing function role — do not add a new repo or a parallel role.

---

## Default rules

| Change | Do | Avoid |
|--------|-----|--------|
| New OS (e.g. Windows) | `roles/<fn>/tasks/platforms/Windows.yml` | `roles/<fn>_windows/` |
| New NTP server | `inventory/sample/group_vars/all/*.yml` | Hardcode in tasks |
| New host category | `playbooks/type_<new>.yml` + inventory group | Duplicate role logic |
| New unrelated capability | New `roles/<other>/` in **same** collection | `deliveries/<initiative>/` repo |

---

## One function role, multiple platforms

```
deliveries/automation/
├── galaxy.yml
└── roles/ntp_sync/
    └── tasks/platforms/
        ├── RedHat.yml
        └── Windows.yml
```

Add `collections/requirements.yml` at collection root when a platform needs extra collections (e.g. `ansible.windows`).

---

## Lifecycle workflow

1. `cd "$AUTOMATION_REPO"` (`deliveries/automation/`)
2. `git checkout -b feature/<ticket>-description`
3. Update `docs/<function>/DESIGN.md`, `CHANGELOG.md`, inventory
4. **Modify** `roles/<function>/` — add platform files only; use `loop_control.loop_var` with `__`-prefixed names in loops
5. Add type playbooks for new host categories
6. Re-run syntax-check on all affected playbooks; `pre-commit run --all-files`

---

## Related

- [create-new-automation-step-by-step.md](create-new-automation-step-by-step.md)
- [git-automation-repository.md](git-automation-repository.md)
