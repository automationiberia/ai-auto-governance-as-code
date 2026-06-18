# Create new automation from scratch

Greenfield path from idea to merged role. Steps apply **in order**; items marked **(gate)** block merge or production.

Mark progress with checkboxes (`- [ ]` → `- [x]`). In VS Code / Cursor, click the box in Markdown preview to toggle.

**Unfamiliar terms?** [glossary.md](glossary.md) explains **gates**, **CAB**, and related acronyms.

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

## Before you start

| Question | If no → stop |
|----------|----------------|
| Is the task repeatable? | Automate only recurring work |
| Can you describe desired state? | Clarify intake first |
| Is there a ticket or backlog item? | Required for **standard** / **heavy** |

| Profile | When | Ticket | Design review | UAT | CAB | Molecule |
|---------|------|--------|---------------|-----|-----|----------|
| **Light** | Single role, lab/low risk, existing SSOT | Backlog item OK | Self-check design note | Lab only | No | Optional |
| **Standard** | Prod or shared collection | ITSM ticket | Async review (Ops or peer) | Pre-prod sample | Yes | If reused by others |
| **Heavy** | Privileged, destructive, regulated | ITSM + Security early | Meeting with Ops + Security | Formal sign-off | Yes | Required |

- [ ] Profile chosen: **Light** / **Standard** / **Heavy** *(circle one in your ticket or PR)*
- [ ] Confirmed: not a one-off manual task — automation is justified

Default to **light** until production is confirmed.

---

## Step 1 — Setup

```bash
export AUTOMATION_HOME=/path/to/ai-auto-governance-as-code
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
cd "$AUTOMATION_REPO"
git checkout main && git pull
git checkout -b feature/<ticket>-<short-name>
```

- [ ] `<automation-home>` available (standards repo with `requirements-dev.txt`)
- [ ] `pip install -r requirements-dev.txt` (from `<automation-home>`)
- [ ] `pre-commit install` run inside `<automation-repo>` **(gate)**

Git and collection layout: [git-automation-repository.md](git-automation-repository.md).

---

## Step 2 — Intake

Capture in the ticket or `docs/rolename/INTAKE.md`:

- **Problem** — what manual work goes away?
- **Success** — how do we know it worked?
- **Scope** — prod or lab only? Which hosts?

- [ ] Ticket/backlog item created with problem statement and scope
- [ ] Triage: SSOT for hosts/vars exists or plan documented *(never skip)*
- [ ] Triage: desired state is definable (not vague "make it better")
- [ ] Stakeholders noted (Ops, App, Security) — *skip if **light** and lab-only*
- [ ] Lead/peer agrees scope fits automation — *required for **standard** / **heavy***

Details: [intake-and-prioritization.md](../lifecycle/intake-and-prioritization.md).

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.
Draft docs/rolename/INTAKE.md: problem, success criteria, scope (prod vs lab), hosts.
No YAML. Profile: [Light | Standard | Heavy].
```

---

## Step 3 — Design (half page)

Document in `docs/rolename/DESIGN.md`:

| Topic | Example |
|-------|---------|
| **L/T/F/C** | prod · rhel · webserver · nginx |
| **SSOT** | CMDB group `web_prod` or `inventory/sample/` |
| **Public vars** | `nginx_max_connections`, `nginx_packages` |
| **Risk** | `become`, restarts, secrets via Vault |

- [ ] **Structure:** landscape / type / function / component ([architecture](../architecture/landscape-type-function-component.md))
- [ ] **SSOT:** where hosts and To-Be variables live (CMDB, cloud plugin, static inventory)
- [ ] **Interface:** public `rolename_*` variables listed
- [ ] **As-Is vs To-Be:** separate names where both exist
- [ ] **Risk:** `become`, secrets, destructive tasks, production impact assessed
- [ ] Design note written (in ticket or PR)
- [ ] Reviewed with Ops or second engineer — **(gate)** for **standard** / **heavy**; *self-check OK for **light***

**AI shortcut (no YAML yet):**

```text
I am operating in Mode 2: The Builder.
Profile: [Light | Standard | Heavy]. INTAKE + DESIGN outline for rolename. No YAML yet.
L/T/F/C, SSOT, public rolename_* vars, risk. Output docs/rolename/DESIGN.md draft.
```

---

## Step 4 — Scaffold

One capability = one **function role** in the shared collection (never a new Git repo per project).

```bash
cd "$AUTOMATION_REPO"
ansible-galaxy init roles/rolename
mkdir -p playbooks inventory/sample/group_vars/all
```

- [ ] Capability added to **shared collection** (`galaxy.yml` present; new `roles/rolename/`)
- [ ] Thin type playbook created under `playbooks/`
- [ ] Sample inventory directory created (`groups_and_hosts`, `group_vars/`)

Minimum tree:

```text
deliveries/automation/
├── playbooks/type_<category>.yml
├── roles/rolename/
│   ├── defaults/main.yml      # public vars: rolename_*
│   ├── tasks/main.yml
│   ├── tasks/platforms/       # if multi-OS
│   ├── handlers/main.yml
│   ├── meta/argument_specs.yml
│   └── README.md
└── docs/rolename/
    ├── INTAKE.md
    └── DESIGN.md
```

Thin type playbook pattern:

```yaml
---
- name: Deploy <category> type
  hosts: <inventory_group>
  roles:
    - rolename
```

**AI shortcut (scaffold only):**

```text
I am operating in Mode 2: The Builder.
Scaffold rolename in deliveries/automation/ per approved DESIGN.md:
roles/rolename/, playbooks/type_<category>.yml, docs/rolename/, inventory/sample/.
List files before editing. No task logic yet.
Follow AGENTS.md and automation-new-automation skill.
```

---

## Step 5 — Implement

| Rule | Requirement |
|------|-------------|
| Modules | FQCN only (`ansible.builtin.package`, not `package`) |
| Variables | Public: `rolename_*` · Internal: `_…` · Loops: `__rolename_…` |
| Tasks | Imperative `name:` on every task |
| Templates | `.j2` + `{{ ansible_managed \| comment }}` |
| Shell | Avoid; if required, Documentation Gate comment + `changed_when` |

- [ ] `defaults/main.yml` — all public inputs with `rolename_*` prefix
- [ ] `vars/` + `tasks/set_vars.yml` — *if multi-OS or multi-provider*
- [ ] `tasks/main.yml` (+ component files with prefixed task names)
- [ ] `meta/argument_specs.yml` — *if more than one required input*
- [ ] Handlers for service restarts where needed
- [ ] Role `README.md` — purpose, variables, example, idempotency, rollback limits
- [ ] Type playbook is thin (roles only, or `import_role` only — not both)
- [ ] Inventory holds To-Be only; no host lists inside variables
- [ ] No secrets in Git (Vault or Controller credentials)

Copy patterns from:

| Profile | Example role |
|---------|----------------|
| Light | [light-dev-packages](../examples/light-dev-packages/) |
| Standard | [standard-rsyslog-forwarding](../examples/standard-rsyslog-forwarding/) |

Details: [development/roles.md](../development/roles.md) · [coding-style.md](../development/coding-style.md).

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.
Implement deliveries/automation/roles/rolename/ per approved DESIGN.md.
Use skills automation-builder and automation-role-development.
Profile: [Light | Standard | Heavy]. Follow AGENTS.md bootstrap rules (FQCN, naming, loop_control).
Align structure to automation-whitepaper/examples/[light-dev-packages | standard-rsyslog-forwarding]/.
List files before editing.
```

More prompts: [ai-prompt-examples.md § Mode 2](ai-prompt-examples.md#5-mode-2--the-builder-more-prompts).

---

## Step 6 — Verify

```bash
cd "$AUTOMATION_REPO"
ansible-playbook --syntax-check playbooks/type_<category>.yml
pre-commit run --all-files
ansible-playbook playbooks/type_<category>.yml -i inventory/sample/ --check
```

- [ ] `ansible-playbook --syntax-check playbooks/<playbook>.yml`
- [ ] `pre-commit run --all-files` in `<automation-repo>` **(gate)**
- [ ] First normal run completed successfully
- [ ] Second normal run: no unexpected `changed` **(gate)**
- [ ] Molecule or CI integration test — **(gate)** if **standard** (shared) or **heavy**; *optional for **light***

| Profile | Extra gate |
|---------|------------|
| Light | Lab run + idempotent re-run |
| Standard | Peer review + Molecule if shared |
| Heavy | Security review + CAB + Molecule required |

[pre-commit.md](../quality/pre-commit.md) · [idempotency-and-check-mode.md](../quality/idempotency-and-check-mode.md)

**AI shortcut:**

```text
Run ansible-playbook --syntax-check and pre-commit run --all-files
in deliveries/automation/. Report results.

If gates fail, switch to Mode 1: The Auditor and use automation-quality-gates.
Same thread as Step 5 — see ai-prompt-examples.md § Design → implement → gate.
```

---

## Step 7 — Ship

- [ ] Changes committed on feature branch in `<automation-repo>`
- [ ] Pull request opened on `<automation-repo>` (design note + test output in description)
- [ ] Peer review completed ([checklist](../quality/code-review-and-linting.md)) **(gate)**
- [ ] UAT on pre-prod hosts — *skip if **light** (lab verify is enough)*
- [ ] Security review — *only **heavy** or privileged production*
- [ ] CAB / change record approved — *only **production**; **skip if light***
- [ ] Version tagged; execution environment updated — *if shared collection or prod*
- [ ] Controller job template created/updated + runbook linked — *prod or team standard*
- [ ] CMDB To-Be update ticket — *only if CMDB owns that data*

Promotion details: [test-and-promote.md](../lifecycle/test-and-promote.md).

**AI shortcut:**

```text
Draft PR title and body for deliveries/automation/ feature branch.
Include: DESIGN.md summary, syntax-check + pre-commit results, profile gates passed.
Format: .github/PULL_REQUEST_TEMPLATE.md
Do not commit or push unless I ask.
```

---

## Step 8 — Operate

- [ ] Runbook or job template description documents: what, `--limit`, on failure
- [ ] Alert on job failure configured — *production only; skip if **light** lab*
- [ ] Automation retired/disabled when obsolete — *when applicable*

No mandatory PIR for **light** profile — fix forward if something breaks.

---

## Quick links

| Need | Document |
|------|----------|
| Git / collection layout | [git-automation-repository.md](git-automation-repository.md) |
| Audit or extend existing code | [evaluate-and-update-existing.md](evaluate-and-update-existing.md) |
| Light walkthrough | [example-light-walkthrough-dev-packages.md](../examples/example-light-walkthrough-dev-packages.md) |
| Standard walkthrough | [example-complete-walkthrough-rsyslog-forwarding.md](../examples/example-complete-walkthrough-rsyslog-forwarding.md) |
| AI prompts | [ai-prompt-examples.md](ai-prompt-examples.md) |

---

## Related

- [getting-started.md](getting-started.md)
- [evaluate-and-update-existing.md](evaluate-and-update-existing.md)
- [01-main-guide.md](../01-main-guide.md)
