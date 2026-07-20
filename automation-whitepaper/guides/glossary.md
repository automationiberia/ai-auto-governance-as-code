# Glossary — terms used in checklists and guides

Short definitions for words that appear often in step-by-step guides. Spanish enterprise equivalents are noted where relevant.

---

## Gate (quality gate)

A **gate** is a **checkpoint you must pass before moving to the next stage**. If you fail a gate, you do not merge, promote, or run in production until it is fixed.

In this repository, gates fall into two kinds:

| Kind | Who enforces it | Examples |
|------|-----------------|----------|
| **Mechanical gate** | Tools (automatic) | `pre-commit run --all-files` green · `ansible-lint` clean · `ansible-playbook --syntax-check` · CI pipeline pass |
| **Human gate** | People (approval) | Peer review · UAT sign-off · Security review · CAB approval |

In [create-new-from-scratch.md](create-new-from-scratch.md), items marked **(gate)** are mandatory for that profile — skipping them blocks merge or production.

**Typical gate sequence before production:**

```text
Code written → syntax-check + pre-commit (mechanical)
            → peer review (human)
            → UAT on pre-prod (human)
            → security review if privileged (human)
            → CAB if production (human)
            → run on prod Controller
```

More detail: [quality/code-review-and-linting.md](../quality/code-review-and-linting.md) · [01-main-guide.md § Quality gates](../01-main-guide.md#8-quality-gates-summary).

---

## CAB (Change Advisory Board)

**CAB** = **Change Advisory Board** — in Spanish enterprises often **Comité de Cambios** or **Comité de Gestión de Cambios**.

It is a **formal meeting or approval process** where stakeholders review a proposed production change **before** it runs. CAB answers: *Is this change safe, tested, and scheduled appropriately?*

| Aspect | What it means for automation |
|--------|------------------------------|
| **When** | Before first production run or significant prod updates (**standard** / **heavy** profiles) |
| **Input** | ITSM change record (RFC), design note, test evidence (CI, Molecule, UAT) |
| **Output** | Approved maintenance window, or rejection with conditions |
| **Who** | Ops, application owners, security, automation — varies by organization |

**CAB is not Ansible-specific.** It is enterprise change management. Automation code still goes through Git PR review; CAB approves the **production execution** of that code.

**When CAB is skipped:**

| Profile | CAB |
|---------|-----|
| **Light** (lab only) | Skipped |
| **Standard** (production) | Required |
| **Heavy** (privileged / regulated) | Required + security sign-off |

Worked example: [example-enterprise-change-flow.md](../examples/example-enterprise-change-flow.md).

---

## Related terms (quick reference)

| Term | Meaning |
|------|---------|
| **Placeholder conventions** | GPA literal `rolename` + angle-bracket tokens — see table below |
| **ITSM** | IT Service Management tool (ServiceNow, Jira Service Management, etc.) — where tickets and change records live |
| **RFC** | Request for Change — the change record number CAB reviews |
| **UAT** | User Acceptance Testing — application or ops team confirms behaviour on pre-prod before prod |
| **Profile** | Risk tier: **light** (lab) · **standard** (prod) · **heavy** (regulated / privileged) |
| **Molecule** | Automated integration test framework for Ansible roles — required on **heavy**, recommended on **standard** when shared |
| **SSOT** | Single Source of Truth — one authoritative place for inventory or variables (CMDB, Controller, Git inventory) |
| **Red Lines** | Non-negotiable compliance rules the human Architect sets; agents enforce via skills and pre-commit |

### Placeholder conventions (guides and skills)

**Role paths and variables** use the literal `rolename` from [GPA roles](../../automation-good-practices/roles/README.adoc) — substitute with your actual role name (e.g. `ntp_sync` → `roles/ntp_sync/`, `ntp_sync_servers`).

Do not use alternate spellings (`<fn>`, `<function>`, `<rolename>`).

| Token | Meaning | Example |
|-------|---------|---------|
| `rolename` | Role directory and variable prefix (GPA) | `ntp_sync`, `rsyslog_forward` |
| `<category>` | Type playbook category | `monitoring`, `webserver` |
| `<ticket>` | ITSM ticket ID | `JIRA-1234` |
| `<short-name>` | Branch suffix | `ntp-windows` |
| `<OsFamily>` | Ansible `os_family` | `RedHat`, `Windows` |

| Variable pattern | Use |
|------------------|-----|
| `rolename_*` | Public vars in `defaults/main.yml` (GPA) |
| `__rolename_*` | `loop_control.loop_var` in roles (GPA) |
| `_…` | Other internal vars — registers, tuning (white book) |

---

## Where to read more

| Topic | Document |
|-------|----------|
| Stakeholders and RACI | [governance/roles-and-responsibilities.md](../governance/roles-and-responsibilities.md) |
| Promotion stage (incl. CAB) | [lifecycle/test-and-promote.md](../lifecycle/test-and-promote.md) |
| Governance by profile | [gac/module/skills/automation-governance/SKILL.md](../../gac/module/skills/automation-governance/SKILL.md) |
| Light vs standard (CAB contrast) | [example-light-walkthrough-dev-packages.md](../examples/example-light-walkthrough-dev-packages.md) |
