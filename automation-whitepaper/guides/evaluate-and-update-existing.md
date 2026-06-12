# Evaluate and update existing automation

Short path to **audit**, **fix**, and **ship** changes on roles or playbooks that already exist.

For adding a new OS or host type to an existing capability, also see [extending-existing-automation.md](extending-existing-automation.md).

---

## When to use this guide

- Legacy playbooks or roles need a compliance review
- A PR needs lint or standards fixes
- You want to refactor without changing behaviour
- You inherited code and need a structured gap analysis

**AI mode:** **1 — Auditor** (review) then **2 — Builder** (apply fixes). **Human:** you approve every change.

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

Attach: `@AGENTS.md` `@skills/automation-auditor/SKILL.md` `@deliveries/automation/roles/rolename/`

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

Extending platforms (new OS): add `tasks/platforms/<OsFamily>.yml` — do **not** clone the role. See [extending-existing-automation.md](extending-existing-automation.md).

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

## Related

- [getting-started.md](getting-started.md)
- [create-new-from-scratch.md](create-new-from-scratch.md)
- [quality/pre-commit.md](../quality/pre-commit.md)
- [development/coding-style.md](../development/coding-style.md)
