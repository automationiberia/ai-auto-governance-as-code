# Step-by-Step Guide: Create New Automation

Practical checklist for new Ansible automation. Steps apply **in order**; items marked **(gate)** block merge or production.

Mark progress with the checkboxes (`- [ ]` → `- [x]`). In VS Code / Cursor, click the box in Markdown preview to toggle.

**Examples:**

| Profile | Walkthrough |
|---------|-------------|
| **Light** | [Walkthrough](../examples/example-light-walkthrough-dev-packages.md) · [Code](../examples/light-dev-packages/) |
| **Standard** | [Walkthrough](../examples/example-complete-walkthrough-rsyslog-forwarding.md) · [Code](../examples/standard-rsyslog-forwarding/) |

Path conventions ([details](../examples/README.md)):

| Symbol | Meaning |
|--------|---------|
| `<automation-home>` | Department standards repo (white paper, shared `pre-commit` config) |
| `<automation-repo>` | **Shared collection** `deliveries/automation/` — one repo for all capabilities ([deliveries/README.md](../../deliveries/README.md)) |

---

## Before you start: pick a profile

| Profile | When | Ticket | Design review | UAT | CAB | Molecule |
|---------|------|--------|---------------|-----|-----|----------|
| **Light** | Single role, lab/low risk, existing SSOT | Backlog item OK | Self-check design note | Lab only | No | Optional |
| **Standard** | Prod or shared collection | ITSM ticket | Async review (Ops or peer) | Pre-prod sample | Yes | If reused by others |
| **Heavy** | Privileged, destructive, regulated | ITSM + Security early | Meeting with Ops + Security | Formal sign-off | Yes | Required |

- [ ] Profile chosen: **Light** / **Standard** / **Heavy** *(circle one in your ticket or PR)*
- [ ] Confirmed: not a one-off manual task — automation is justified

Default to **light** when unsure; escalate to **standard** before production.

---

## 1. Confirm and set up (tooling)

- [ ] Problem is repeatable and expressible as desired state
- [ ] `<automation-home>` available (standards repo with `requirements-dev.txt`)
- [ ] `pip install -r requirements-dev.txt` (from `<automation-home>`)

---

## 2. Delivery collection (Git) **(gate)**

**Default:** all automations live in **one** Ansible collection at `deliveries/automation/`. Each new capability adds a **role** — not a new Git repo.  
Detail: [git-automation-repository.md](git-automation-repository.md).

- [ ] `<automation-repo>` = `deliveries/automation/` (shared collection)
- [ ] If collection is new: `git init`, `galaxy.yml` ([template](../templates/delivery-collection.galaxy.yml)), `meta/runtime.yml`, `CHANGELOG.md`, lint templates, initial commit
- [ ] If collection exists: `git pull` on `main`, then feature branch only
- [ ] `pre-commit install` run inside `<automation-repo>` **(gate)**
- [ ] Remote `origin` configured *(once per collection)*

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
# full script: git-automation-repository.md
```

---

## 3. Capture intent (intake)

One ticket or backlog item with: **problem**, **who cares**, **approx. scale**, **prod or lab only**.

- [ ] Ticket/backlog item created with problem statement and scope
- [ ] Triage: SSOT for hosts/vars exists or plan documented *(never skip)*
- [ ] Triage: desired state is definable (not vague "make it better")
- [ ] Stakeholders noted (Ops, App, Security) — *skip if **light** and lab-only*
- [ ] Lead/peer agrees scope fits automation — *required for **standard** / **heavy***

Details: [intake-and-prioritization.md](../lifecycle/intake-and-prioritization.md).

---

## 4. Design (keep it short)

**One design note** (half page) in the ticket or PR — check off each topic covered:

- [ ] **Structure:** landscape / type / function / component ([architecture](../architecture/landscape-type-function-component.md))
- [ ] **SSOT:** where hosts and To-Be variables live (CMDB, cloud plugin, static inventory)
- [ ] **Interface:** public `rolename_*` variables listed
- [ ] **As-Is vs To-Be:** separate names where both exist
- [ ] **Risk:** `become`, secrets, destructive tasks, production impact assessed

**Review:**

- [ ] Design note written (in ticket or PR)
- [ ] Reviewed with Ops or second engineer — **(gate)** for **standard** / **heavy**; *self-check OK for **light***

---

## 5. Build

Work **inside `<automation-repo>`** (not only on a local folder outside Git).

### 5.1 Scaffold

- [ ] Feature branch created: `feature/<ticket>-short-name`
- [ ] Capability added to **shared collection** (`galaxy.yml` present; new `roles/<function>/`)
- [ ] Role scaffolded (`ansible-galaxy init roles/<rolename>` or team template)
- [ ] Thin type playbook created under `playbooks/`
- [ ] Sample inventory directory created (`groups_and_hosts`, `group_vars/`)

```bash
cd "$AUTOMATION_REPO"
git checkout -b feature/<ticket>-short-name
ansible-galaxy init roles/<rolename>
```

Minimum tree:

```
├── playbooks/type_<name>.yml
├── roles/<rolename>/
│   ├── defaults/main.yml
│   ├── vars/                    # if multi-OS
│   ├── tasks/main.yml
│   ├── tasks/platforms/         # per OS family (extend same role)
│   ├── templates/
│   ├── handlers/main.yml
│   ├── meta/argument_specs.yml  # if more than one required input
│   └── README.md
└── inventory/sample/
    ├── groups_and_hosts
    └── group_vars/
```

### 5.2 Implement

- [ ] `defaults/main.yml` — all public inputs with `rolename_*` prefix
- [ ] `vars/` + `tasks/set_vars.yml` — *if multi-OS or multi-provider*
- [ ] `tasks/main.yml` (+ component files with prefixed task names)
- [ ] `meta/argument_specs.yml` — *if more than one required input*
- [ ] Templates use `.j2` and `{{ ansible_managed | comment }}` (no dynamic dates)
- [ ] Handlers for service restarts where needed
- [ ] Role `README.md` — purpose, variables, example, idempotency, rollback limits
- [ ] Type playbook is thin (roles only, or `import_role` only — not both)
- [ ] Inventory holds To-Be only; no host lists inside variables
- [ ] No secrets in Git (Vault or Controller credentials)

Details: [development/roles.md](../development/roles.md), [development/playbooks.md](../development/playbooks.md).

---

## 6. Verify locally

Run from `<automation-repo>`:

- [ ] `ansible-playbook --syntax-check playbooks/<playbook>.yml`
- [ ] `pre-commit run --all-files` in `<automation-repo>` **(gate)**
- [ ] `ansible-playbook ... --check` against lab/pre-prod inventory
- [ ] First normal run completed successfully
- [ ] Second normal run: no unexpected `changed` **(gate)**
- [ ] Molecule or CI integration test — **(gate)** if **standard** (shared) or **heavy**; *optional for **light***

[pre-commit.md](../quality/pre-commit.md) · [idempotency-and-check-mode.md](../quality/idempotency-and-check-mode.md)

---

## 7. Ship

- [ ] Changes committed on feature branch in `<automation-repo>`
- [ ] Pull request opened on `<automation-repo>` (design note + test output in description)
- [ ] Peer review completed ([checklist](../quality/code-review-and-linting.md)) **(gate)**
- [ ] UAT on pre-prod hosts — *skip if **light** (lab verify is enough)*
- [ ] Security review — *only **heavy** or privileged production*
- [ ] CAB / change record approved — *only **production**; **skip if light***
- [ ] Version tagged; execution environment updated — *if shared collection or prod*
- [ ] Controller job template created/updated + runbook linked — *prod or team standard*
- [ ] CMDB To-Be update ticket — *only if CMDB owns that data*

---

## 8. Operate

- [ ] Runbook or job template description documents: what, `--limit`, on failure
- [ ] Alert on job failure configured — *production only; skip if **light** lab*
- [ ] Automation retired/disabled when obsolete — *when applicable*

No mandatory PIR for **light** profile — fix forward if something breaks.

---

## Quick reference

| Topic | Document |
|-------|----------|
| Stakeholders / CAB | [governance/](../governance/) |
| Git / `<automation-repo>` | [git-automation-repository.md](git-automation-repository.md) |
| Extend existing delivery | [extending-existing-automation.md](extending-existing-automation.md) |
| Lint | [quality/pre-commit.md](../quality/pre-commit.md) |
| Light | [walkthrough](../examples/example-light-walkthrough-dev-packages.md) · [code](../examples/light-dev-packages/) |
| Standard | [walkthrough](../examples/example-complete-walkthrough-rsyslog-forwarding.md) · [code](../examples/standard-rsyslog-forwarding/) |
| Cursor skills | [skills/README.md](../../skills/README.md) |

---

## Related

- [01-main-guide.md](../01-main-guide.md)
- [lifecycle/](../lifecycle/) — background, not a duplicate checklist
