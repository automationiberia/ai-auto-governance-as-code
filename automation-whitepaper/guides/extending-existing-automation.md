# Extending Existing Automation

> **Audit or refactor first?** See [evaluate-and-update-existing.md](evaluate-and-update-existing.md).

Changes apply inside the **shared delivery collection** `deliveries/automation/`. Extend the existing function role — do not add a new repo or a parallel role.

---

## Default rules

| Change | Do | Avoid |
|--------|-----|--------|
| New OS (e.g. Windows) | `roles/rolename/tasks/platforms/Windows.yml` | `roles/rolename_windows/` |
| New NTP server | `inventory/sample/group_vars/all/*.yml` | Hardcode in tasks |
| New host category | `playbooks/type_<category>.yml` + inventory group | Duplicate role logic |
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

## Step 1 — Branch and docs

```bash
cd "$AUTOMATION_REPO"    # deliveries/automation/
git checkout main && git pull
git checkout -b feature/<ticket>-description
```

Update `docs/rolename/DESIGN.md`, `CHANGELOG.md`, and inventory as needed.

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.
Use skill automation-lifecycle.

Extend existing role rolename in deliveries/automation/ — scope: [new OS | new inventory | new host category].
Update docs/rolename/DESIGN.md outline only. No YAML yet.
```

---

## Step 2 — Extend the role

**Modify** `roles/rolename/` — add platform files or inventory only; use `loop_control.loop_var` with `__rolename_…` in loops.

Add type playbooks for new host categories. Add `collections/requirements.yml` if a platform needs extra collections.

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.
Use skills automation-builder, automation-role-development, automation-lifecycle.

Add [platform <OsFamily> | inventory | type playbook] to deliveries/automation/roles/rolename/.
Do not clone the role. Minimal diffs only. Follow AGENTS.md and extending-existing-automation.md.
List files before editing.
```

More prompts: [ai-prompt-examples.md § Extend role to new OS](ai-prompt-examples.md#extend-role-to-new-os).

---

## Step 3 — Verify

```bash
ansible-playbook --syntax-check playbooks/type_<category>.yml   # all affected playbooks
pre-commit run --all-files
ansible-galaxy collection install -r collections/requirements.yml   # if present
```

**AI shortcut:**

```text
Run ansible-playbook --syntax-check on all affected type playbooks and
pre-commit run --all-files in deliveries/automation/. Report results.

If gates fail, switch to Mode 1: The Auditor. Same thread as Step 2.
```

---

## Step 4 — Ship

Commit on feature branch; open PR on the **delivery collection** repo with design note + test output.

**AI shortcut:**

```text
Draft PR title and body for deliveries/automation/ extension.
Include: DESIGN.md changes, platforms or inventory added, syntax-check + pre-commit results.
Format: .github/PULL_REQUEST_TEMPLATE.md
Do not commit or push unless I ask.
```

---

## Related

- [create-new-automation-step-by-step.md](create-new-automation-step-by-step.md)
- [git-automation-repository.md](git-automation-repository.md)
