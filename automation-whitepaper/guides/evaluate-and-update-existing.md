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
| Function role | `roles/<function>/` |
| Type playbook | `playbooks/type_<category>.yml` |
| Reference example | `automation-whitepaper/examples/standard-rsyslog-forwarding/` |

Create a branch:

```bash
git checkout main && git pull
git checkout -b fix/<ticket>-short-description
```

---

## Step 2 — Evaluate (audit)

### Option A — With AI (fastest)

In Cursor / Claude / Copilot, attach `AGENTS.md` and `skills/automation-auditor/SKILL.md`, then:

```text
I am operating in Mode 1: The Auditor.

Review deliveries/automation/roles/<function>/ for white book compliance.
Findings only — do not edit files yet.

Output: summary by severity, findings table, refactor plan.
```

More prompts: [ai-prompt-examples.md § Primary workflow](ai-prompt-examples.md#3-primary-workflow--review-refactor-governance).

### Option B — Manual checklist (no AI)

| Check | Pass? |
|-------|-------|
| Every task has `name:` | |
| Modules use FQCN (`ansible.builtin.*`) | |
| No `with_items` — use `loop` + `loop_control` | |
| Role loops use `__<function>_…`, not bare `item` | |
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

For **standard** / **heavy** profiles, update `docs/<function>/DESIGN.md` if behaviour or interfaces change.

---

## Step 4 — Apply fixes

### Option A — With AI

Same chat thread as Step 2:

```text
I am operating in Mode 2: The Builder.

Apply the Auditor refactor plan from this conversation. Minimal diffs only.
Follow AGENTS.md bootstrap rules.
```

### Option B — Manual

Fix findings in priority order: **High → Medium → Low**.

Common fixes:

| Finding | Fix |
|---------|-----|
| Bare module name | Add FQCN |
| `with_items` | `loop:` + `loop_control.loop_var: __<fn>_item` |
| Bare `item` in role | Rename loop var with `__` prefix |
| Generic var `packages` | Rename to `<rolename>_packages` |
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

---

## Step 6 — Ship

```bash
git add -A
git commit -m "fix(<function>): <what you fixed>"
git push -u origin HEAD
```

Open a PR on the **delivery collection** repo with:

- Link to audit findings or checklist
- `pre-commit` output (paste or CI link)
- Design note update if interfaces changed

Review checklist: [code-review-and-linting.md](../quality/code-review-and-linting.md).

---

## If the audit reveals a standards gap

When the same issue appears in many roles, propose a governance update (**Mode 3 — Librarian**):

```text
I am operating in Mode 3: The Librarian.

Recurring gap: <describe>. Propose white paper + SKILL.md update — plan only.
```

---

## Related

- [getting-started.md](getting-started.md)
- [create-new-from-scratch.md](create-new-from-scratch.md)
- [quality/pre-commit.md](../quality/pre-commit.md)
- [development/coding-style.md](../development/coding-style.md)
