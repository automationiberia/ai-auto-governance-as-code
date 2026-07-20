# Evaluate and update existing automation

Short path to **audit**, **fix**, and **ship** changes on roles or playbooks that already exist.

For adding a new OS, inventory group, or host type to an existing capability, see [Extend existing automation](#extend-existing-automation) below.

---

## When to use this guide

- Legacy playbooks or roles need a compliance review
- A PR needs lint or standards fixes
- You want to refactor without changing behaviour
- You inherited code and need a structured gap analysis
- You need to extend an existing role (new platform, inventory, or host category)

**AI mode:** **1 — Auditor** (review) then **2 — Builder** (apply fixes or extensions). **Human:** you approve every change.

---

## Step 1 — Locate the code

```bash
export AUTOMATION_HOME=/path/to/ai-auto-governance-as-code
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
cd "$AUTOMATION_REPO"
```

Typical targets:

| What | Path |
|------|------|
| Function role | `roles/rolename/` |
| Type playbook | `playbooks/type_<category>.yml` |
| Reference example | `automation-whitepaper/examples/standard-rsyslog-forwarding/` |

Create a branch:

```bash
git checkout main && git pull
git checkout -b fix/<ticket>-short-description
```

---

## Step 2 — Evaluate (audit)

**AI shortcut:**

```text
I am operating in Mode 1: The Auditor.

Review deliveries/automation/roles/rolename/ for white book compliance.
Findings only — do not edit files yet.

Output: summary by severity, findings table, refactor plan.
```

Attach: `@AGENTS.md` `@gac/module/skills/automation-auditor/SKILL.md` `@deliveries/automation/roles/rolename/`

More prompts: [ai-prompt-examples.md § Primary workflow](ai-prompt-examples.md#3-primary-workflow--review-refactor-governance).

### Manual checklist (no AI)

| Check | Pass? |
|-------|-------|
| Every task has `name:` | |
| Modules use FQCN (`ansible.builtin.*`) | |
| No `with_items` — use `loop` + `loop_control` | |
| Role loops use `__rolename_…`, not bare `item` | |
| Public vars prefixed: `rolename_*` | |
| Internal vars use `_` prefix | |
| No `shell`/`command` without justification + `changed_when` | |
| Booleans are `true` / `false` (not `yes`/`no`) | |
| Compare structure to [standard-rsyslog-forwarding](../examples/standard-rsyslog-forwarding/) | |

Run mechanical checks:

```bash
cd "$AUTOMATION_REPO"
ansible-playbook --syntax-check playbooks/type_<category>.yml
pre-commit run --all-files
```

---

## Step 3 — Plan the update

Write down (ticket or PR description):

1. **What** fails the audit (file + rule)
2. **What** you will change (minimal diff)
3. **What** you will **not** change (scope boundary)

For **standard** / **heavy** profiles, update `docs/rolename/DESIGN.md` if behaviour or interfaces change.

**AI shortcut:**

```text
Same thread as Step 2 (Auditor).

Summarize findings into a PR plan: what to change (file + rule), what stays out of scope.
No edits yet — plan only.
```

---

## Step 4 — Apply fixes

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.

Apply the Auditor refactor plan from this conversation. Minimal diffs only.
Use skills automation-builder and automation-role-development.
Follow AGENTS.md bootstrap rules (FQCN, rolename_*, loop_control).
Fix High and Medium findings first.
```

Same chat thread as Steps 2–3. More prompts: [ai-prompt-examples.md § Step 2](ai-prompt-examples.md#step-2--apply-auditor-findings-mode-2).

### Manual fixes

Fix findings in priority order: **High → Medium → Low**.

Common fixes:

| Finding | Fix |
|---------|-----|
| Bare module name | Add FQCN |
| `with_items` | `loop:` + `loop_control.loop_var: __rolename_item` |
| Bare `item` in role | Rename loop var with `__` prefix |
| Generic var `packages` | Rename to `rolename_packages` |
| Unjustified `command` | Use module, or add comment + `changed_when` |

Extending platforms (new OS): add `tasks/platforms/<OsFamily>.yml` — do **not** clone the role. See [Extend existing automation](#extend-existing-automation).

---

## Step 5 — Verify

```bash
cd "$AUTOMATION_REPO"
ansible-playbook --syntax-check playbooks/<affected>.yml
pre-commit run --all-files
ansible-playbook playbooks/<affected>.yml -i inventory/sample/ --check   # if lab inventory exists
```

Second normal run should show **no unexpected `changed`** tasks.

**AI shortcut:**

```text
Run ansible-playbook --syntax-check and pre-commit run --all-files
in deliveries/automation/. Report results.

If gates fail, switch to Mode 1: The Auditor — diagnose remaining findings only.
Same thread as Steps 2–4.
```

---

## Step 6 — Ship

```bash
git add -A
git commit -m "fix(rolename): <what you fixed>"
git push -u origin HEAD
```

Open a PR on the **delivery collection** repo with:

- Link to audit findings or checklist
- `pre-commit` output (paste or CI link)
- Design note update if interfaces changed

Review checklist: [code-review-and-linting.md](../quality/code-review-and-linting.md).

**AI shortcut:**

```text
Draft PR title and body for deliveries/automation/ fix branch.
Include: audit findings summary, pre-commit output, scope boundary (what was not changed).
Format: .github/PULL_REQUEST_TEMPLATE.md
Do not commit or push unless I ask.
```

---

## If the audit reveals a standards gap

When the same issue appears in many roles, propose a governance update (**Mode 3 — Librarian**):

**AI shortcut:**

```text
I am operating in Mode 3: The Librarian.

Recurring gap: <describe>. Propose white paper + SKILL.md update — plan only.
Use Auditor findings from this conversation. Do not edit delivery roles.
```

---

## Extend existing automation

Changes apply inside the **shared delivery collection** `deliveries/automation/`. Extend the existing function role — do not add a new repo or a parallel role.

### Default rules

| Change | Do | Avoid |
|--------|-----|--------|
| New OS (e.g. Windows) | `roles/rolename/tasks/platforms/Windows.yml` | `roles/rolename_windows/` |
| New NTP server | `inventory/sample/group_vars/all/*.yml` | Hardcode in tasks |
| New host category | `playbooks/type_<category>.yml` + inventory group | Duplicate role logic |
| New unrelated capability | New `roles/<other>/` in **same** collection | `deliveries/<initiative>/` repo |

### One function role, multiple platforms

```text
deliveries/automation/
├── galaxy.yml
└── roles/ntp_sync/
    └── tasks/platforms/
        ├── RedHat.yml
        └── Windows.yml
```

Add `collections/requirements.yml` at collection root when a platform needs extra collections (e.g. `ansible.windows`).

### Extension workflow

1. **Branch and docs** — update `docs/rolename/DESIGN.md`, `CHANGELOG.md`, and inventory as needed.

```bash
cd "$AUTOMATION_REPO"
git checkout main && git pull
git checkout -b feature/<ticket>-description
```

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.
Use skill automation-lifecycle.

Extend existing role rolename in deliveries/automation/ — scope: [new OS | new inventory | new host category].
Update docs/rolename/DESIGN.md outline only. No YAML yet.
```

2. **Extend the role** — modify `roles/rolename/`; add platform files or inventory only; use `loop_control.loop_var` with `__rolename_…` in loops. Add type playbooks for new host categories.

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.
Use skills automation-builder, automation-role-development, automation-lifecycle.

Add [platform <OsFamily> | inventory | type playbook] to deliveries/automation/roles/rolename/.
Do not clone the role. Minimal diffs only. Follow AGENTS.md and evaluate-and-update-existing.md.
List files before editing.
```

More prompts: [ai-prompt-examples.md § Extend role to new OS](ai-prompt-examples.md#extend-role-to-new-os).

3. **Verify and ship** — same as Steps 5–6 above; include `ansible-galaxy collection install -r collections/requirements.yml` when `collections/requirements.yml` is present.

---

## Related

- [getting-started.md](getting-started.md)
- [create-new-from-scratch.md](create-new-from-scratch.md)
- [git-automation-repository.md](git-automation-repository.md)
- [quality/pre-commit.md](../quality/pre-commit.md)
- [development/coding-style.md](../development/coding-style.md)
