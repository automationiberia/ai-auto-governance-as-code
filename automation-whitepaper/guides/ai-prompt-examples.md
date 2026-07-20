# AI prompt examples — using ai-auto-governance-as-code and Agent Skills

Copy-paste prompts for **any** AI agent (Cursor, Claude, Copilot, or other) in the **`ai-auto-governance-as-code`** monorepo.

Every prompt assumes the agent reads [AGENTS.md](../../AGENTS.md), **declares its mode** before technical output, and follows the linked skill.

| Before you start | Document |
|------------------|----------|
| Tool setup (Cursor · Claude · Copilot · generic) | [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md) |
| Operating modes (Auditor / Builder / Librarian); human = Architect | [AGENTS.md](../../AGENTS.md) |

---

## Table of contents

1. [One-time setup](#1-one-time-setup)
2. [How to invoke skills](#2-how-to-invoke-skills)
3. [Primary workflow — review, refactor, governance](#3-primary-workflow--review-refactor-governance) ← start here for role work
4. [Mode 1 — The Auditor (more prompts)](#4-mode-1--the-auditor-more-prompts)
5. [Mode 2 — The Builder (more prompts)](#5-mode-2--the-builder-more-prompts)
6. [Mode 3 — The Librarian (more prompts)](#6-mode-3--the-librarian-more-prompts)
7. [Strategic proposal — AAP & Puppet](#7-strategic-proposal--aap--puppet)
8. [Quick reference — task skills](#8-quick-reference--task-skills)
9. [Other multi-step workflows](#9-other-multi-step-workflows)
10. [Prompts to avoid](#10-prompts-to-avoid)
11. [Tool-specific notes](#11-tool-specific-notes)
12. [Platform administration (AAP MCP)](#12-platform-administration-aap-mcp)

---

## 1. One-time setup

### Repository (all tools)

```bash
cd /path/to/ai-auto-governance-as-code
git submodule update --init --recursive
pip install -r requirements-dev.txt
pre-commit install   # optional
export AUTOMATION_HOME="$(pwd)"
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

### AI tool (pick one)

| Tool | Next step |
|------|-----------|
| **Cursor** | [TOOL-SETUP.md → Cursor](../../skills/TOOL-SETUP.md#cursor) |
| **Claude** | [TOOL-SETUP.md → Claude](../../skills/TOOL-SETUP.md#claude) |
| **GitHub Copilot** | [TOOL-SETUP.md → Copilot](../../skills/TOOL-SETUP.md#github-copilot) |
| **Other** | [TOOL-SETUP.md → Generic](../../skills/TOOL-SETUP.md#generic-any-agent) |

---

## 2. How to invoke skills

| Technique | Example |
|-----------|---------|
| **Name the skill** | `Use skill automation-auditor` |
| **Name the mode** | `Operate in Mode 1: The Auditor` |
| **Point to files** | `Read AGENTS.md and gac/module/skills/automation-auditor/SKILL.md` |
| **IDE attachment** | `@AGENTS.md` `@gac/module/skills/automation-auditor/SKILL.md` `@deliveries/automation/roles/rolename/` |
| **Reference example** | `Align with standard-rsyslog-forwarding example role` |

Expected reply prefix: *I am operating in Mode N: The …*

---

## 3. Primary workflow — review, refactor, governance

Use this **same chat thread** for delivery roles in `deliveries/automation/`.

| Step | Mode | Skill(s) | Outcome |
|------|------|----------|---------|
| **1** | Auditor | `automation-auditor`, `automation-role-development` | Findings table + refactor plan (no edits) |
| **2** | Builder | `automation-builder`, `automation-role-development` | Apply plan — minimal diffs |
| **3** | — | — | syntax-check + pre-commit |
| **4** (optional) | Librarian | `automation-librarian` | Governance diff plan if standards gap |

### Step 1 — Role compliance review (Mode 1)

Attach: `@AGENTS.md` `@gac/module/skills/automation-auditor/SKILL.md` `@gac/module/skills/automation-role-development/SKILL.md` `@deliveries/automation/roles/rolename/`

```text
Read AGENTS.md and use skills automation-auditor and automation-role-development.
I am operating in Mode 1: The Auditor.

Review the role at deliveries/automation/roles/rolename/ for compliance with
this repository's standards. Do not rewrite files — findings only.

Check against:
- AGENTS.md bootstrap rules (FQCN, no with_items, task name on every task)
- automation-whitepaper/development/roles.md and coding-style.md
- _ prefix for internal vars; __rolename_… for loop_control.loop_var (no bare item)
- `rolename_*` public vars; tasks/platforms/ for multi-OS; meta/argument_specs.yml; role README.md
- Idempotency, handlers vs when-changed, templates with ansible_managed
- Compare structure to automation-whitepaper/examples/standard-rsyslog-forwarding/roles/rsyslog_forward/

Output:
1. Summary (High / Medium / Low counts)
2. Findings table: file, rule violated, suggested fix
3. Gap list vs reference role
4. Refactor plan (ordered steps)
5. pre-commit / syntax-check commands to run after fixes
```

Example: substitute `rolename` → `ntp_sync`.

### Step 2 — Apply Auditor findings (Mode 2)

Same thread — use the findings table and refactor plan **already in context**.

Attach: `@AGENTS.md` `@gac/module/skills/automation-builder/SKILL.md` `@gac/module/skills/automation-role-development/SKILL.md` `@deliveries/automation/roles/rolename/`

```text
Read AGENTS.md. Use skills automation-builder and automation-role-development.
I am operating in Mode 2: The Builder. I have evaluated Red Hat COP baseline rules against white book overrides.

I have Auditor findings for deliveries/automation/roles/rolename/ from Step 1
in this conversation. Use the Auditor findings table and refactor plan that
already exists in the context. Implement the refactor plan — minimal diffs only.

Rules:
- Follow AGENTS.md bootstrap (FQCN, loop_control, _ / __ variable naming)
- Align structure to automation-whitepaper/examples/standard-rsyslog-forwarding/roles/rsyslog_forward/
- Fix High and Medium findings first; Low only if trivial
- Do not change unrelated files

When done:
1. List files changed
2. Summarize what each finding resolution did
3. Give commands: ansible-playbook --syntax-check and pre-commit run --all-files in deliveries/automation/
```

### Step 3 — Verify

```text
Run or instruct: ansible-playbook --syntax-check and pre-commit run --all-files
in deliveries/automation/. Report results.
```

### Step 4 — After Auditor + Builder — update governance (Mode 3)

Use **only** when Steps 1–2 exposed a **recurring gap** or **new pattern** that should become a standard — **not** for routine role fixes.

Same thread — use Auditor findings and Builder summary **already in context**.

Attach: `@AGENTS.md` `@gac/module/skills/automation-librarian/SKILL.md`

```text
Read AGENTS.md. Use skill automation-librarian.
I am operating in Mode 3: The Librarian.

Context: I completed Step 1 (Auditor) and Step 2 (Builder) for
deliveries/automation/roles/rolename/ in this conversation.

Use the Auditor findings and Builder refactor summary already in the context
(recurring gaps or new pattern worth standardizing).

Propose a governance update only — do not edit delivery role files.

Deliver:
1. Rationale (why this belongs in standards, not only in one role)
2. Diff plan: white paper → matching SKILL.md → AGENTS.md (if needed) → gac/README.md
3. Skill sync table (section → file → under 500 lines)
4. New rows for automation-auditor or automation-role-development checklists (if any)
5. Breaking changes for existing repos (if any)

Do not apply edits until I approve the plan.
```

---

## 4. Mode 1 — The Auditor (more prompts)

For existing YAML in `$AUTOMATION_REPO` or `automation-whitepaper/examples/`.

### PR / diff review

```text
Mode 1 — The Auditor. Use automation-quality-gates and automation-role-development.

Review my staged changes under deliveries/automation/ for:
- bare item / with_items
- missing FQCN
- missing task names
- loop_control and __ prefixes in roles

Suggest fixes with paths; run pre-commit if I ask you to apply fixes.
```

### Compare to reference example

```text
Use automation-auditor.

Compare deliveries/automation/roles/rolename/ to
automation-whitepaper/examples/standard-rsyslog-forwarding/roles/rsyslog_forward/.
What structural gaps exist? Cite paths only, no pasted YAML blocks.
```

### Fix pre-commit failures

```text
Use automation-pre-commit in Auditor mode.

I ran pre-commit and got failures. Diagnose each hook failure and propose minimal fixes.
Scope: automation-whitepaper/examples/ unless I specify deliveries/automation/.
```

---

## 5. Mode 2 — The Builder (more prompts)

For greenfield or extending capabilities in **`ai-auto-deliveries`** (`deliveries/automation/`).

### New capability (standard profile)

```text
Use skill automation-builder and automation-new-automation. Read AGENTS.md.

Profile: Standard.
Create a new capability rolename in $AUTOMATION_REPO:
- one function role under roles/rolename/
- type playbook playbooks/type_<category>.yml
- docs/rolename/INTAKE.md and DESIGN.md
- inventory sample under inventory/sample/

Follow standard-rsyslog-forwarding patterns. FQCN only. List files before editing.
```

### Light profile (lab / low risk)

```text
Mode 2 — Builder. Use automation-new-automation. Profile: Light.

Add a capability for <scenario> in the delivery collection.
Mirror automation-whitepaper/examples/light-dev-packages/. List files before editing.
```

### Extend role to new OS

```text
Use automation-builder, automation-role-development, and
automation-whitepaper/guides/evaluate-and-update-existing.md (section Extend existing automation).

Add platform support for <OsFamily> to deliveries/automation/roles/rolename/
using tasks/platforms/<OsFamily>.yml — do not clone the role.
```

### Architecture placement only (no code)

```text
Use automation-architecture in Builder mode.

Propose Landscape / Type / Function / Component for <need> and type playbook name.
No YAML — design note only.
```

### Playbook and inventory only

```text
Use automation-playbook-inventory in Mode 2.

Add inventory sample and thin type playbook for role rolename in deliveries/automation/.
Roles only in playbook — no business logic in playbook.
```

---

## 6. Mode 3 — The Librarian (more prompts)

For **white book** and **skills** maintenance outside the [primary workflow](#3-primary-workflow--review-refactor-governance). The usual end-of-thread case is **Step 4** above.

### Adopt a new mandatory pattern

```text
Use skill automation-librarian. Mode 3 — The Librarian.

We now require Molecule on Standard profile. Propose a diff plan:
white paper → skills → AGENTS.md (if needed) → gac/README.md.
Do not edit files until I approve.
```

### Sync skill after white book edit

```text
Mode 3 — Librarian.

I updated automation-whitepaper/quality/pre-commit.md. Sync
gac/module/skills/automation-pre-commit/SKILL.md (under 500 lines) and check gac/README.md catalog.
```

### GPA submodule review

```text
Use automation-librarian. Mode 3 — The Librarian.

Summarize automation-good-practices submodule changes vs last pin.
Which white paper sections and skills need updates? No submodule bump yet.
```

---

## 7. Strategic proposal — AAP & Puppet

References: [strategic-proposal-aap-governance-evolution.md](../governance/strategic-proposal-aap-governance-evolution.md) · [aap-puppet-coexistence-evolution.md](../architecture/aap-puppet-coexistence-evolution.md).

### Phase 2.1 — Centralized orchestration (wrapper)

```text
Use automation-puppet-orchestrate. Mode 2 — Builder. Read AGENTS.md.

Create a Phase 1 wrapper in deliveries/automation/ for Puppet class `<class>` via
community.general.puppet: noop/check mode, summarize: true, _puppet_environment, tags.
No shell puppet agent. No native refactor.
```

### Phase 2.2 — On-demand refactor (trigger required)

```text
Use automation-builder and automation-new-automation. Profile: Standard.

Trigger: <major functional change | architectural rewrite | scope expansion>.
Refactor Puppet `<module>` to native role `rolename`. Design before YAML.
```

### Phase 2.3 — Greenfield (native Ansible only)

```text
Mode 2 — Builder. Phase 2.3. New capability `rolename` — native Ansible only.
Do not create Puppet modules. Follow AGENTS.md.
```

### Phase assessment

```text
Read strategic-proposal-aap-governance-evolution.md §2.

Scenario: <describe>. Which phase (2.1 / 2.2 / 2.3)? Triggers, exit criteria, human gates. No YAML.
```

### Auditor — Puppet wrapper compliance

```text
Mode 1 — Auditor. Use automation-puppet-orchestrate guardrails.

Review deliveries/automation/ playbooks that invoke Puppet.
Flag: shell puppet, missing summarize, deprecated timeout param, non-FQCN.
```

---

## 8. Quick reference — task skills

| Goal | Prompt snippet |
|------|----------------|
| Lifecycle / intake | `Use automation-lifecycle — which phase checklist for <ticket>?` |
| Governance / CAB | `Use automation-governance — stakeholders for Standard prod change?` |
| Controller / SSOT | `Use automation-controller-ops — inventory integration for <source>?` |
| Enterprise change flow | `Walk through example-enterprise-change-flow.md for <deploy>.` |
| Platform snapshot (MCP) | `Platform area: Audit. Use aap-live-snapshot for org <name>.` |
| RBAC review (MCP) | `Platform area: Audit. Use aap-rbac-review — who can execute <template>?` |
| Job status (MCP) | `Platform area: Operate (read-only). Use aap-job-status for job <id>.` |
| AAP + Puppet strategy | `Read strategic-proposal-aap-governance-evolution.md — phase for <scenario>` |

---

## 9. Other multi-step workflows

### Design → implement → gate (greenfield)

```text
Step 1 (Builder): Standard profile — INTAKE + DESIGN outline for rolename. No YAML.
```

```text
Step 2 (Builder): Implement in deliveries/automation/ per approved design.
```

```text
Step 3 (Auditor): automation-quality-gates checklist before PR.
```

---

## 10. Prompts to avoid

| Weak prompt | Why | Better |
|-------------|-----|--------|
| `Fix my Ansible` | No path, no mode | §3 Step 1 with role path |
| `Create a new repo for NTP` | Violates collection model | §5 new capability |
| `Ignore AGENTS.md` | Breaks governance | `@AGENTS.md` |
| `Change .gitmodules delivery URL` | Breaks submodule | Fix credentials instead |
| Paste 200 lines of YAML | Wastes context | `@path/to/file` |

---

## 11. Tool-specific notes

| Tool | Tip |
|------|-----|
| **Cursor** | `automation-home.code-workspace`; `lola install gac -a cursor` after new skills |
| **Claude** | `AGENTS.md` in project knowledge; no symlink script |
| **Copilot** | `.github/copilot-instructions.md` → `AGENTS.md` |
| **Generic** | File paths in prompt; same-thread context for Steps 2–4 |

---

## 12. Platform administration (AAP MCP)

Requires MCP — see [TOOL-SETUP.md](../../skills/TOOL-SETUP.md#mcp-aap-platform-skills) and [aap-platform-administration.md](../operations/aap-platform-administration.md).

### Full platform snapshot

```text
Platform area: Audit (read-only).
I have evaluated Red Hat CoP baseline rules against white book overrides.
Use skill aap-live-snapshot for organization "Lab".
Cross-check job templates against playbooks under $AUTOMATION_REPO/playbooks/.
```

### RBAC review

```text
Platform area: Audit (read-only).
Use skill aap-rbac-review.
Who has execute permission on job template "Deploy Application" in organization Default?
```

### Job status

```text
Platform area: Operate (read-only).
Use skill aap-job-status.
What is the status of job 456? If failed, summarize failure and link to output.
```

### Content audit + platform correlation

```text
Step 1 (Mode 1): Audit deliveries/automation/roles/motd/ for white book compliance.
Step 2 (Platform Audit): aap-live-snapshot — list job templates referencing playbooks/type_linux_motd.yml.
```

---

## Related documents

- [AGENTS.md](../../AGENTS.md)
- [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md)
- [gac/README.md](../../gac/README.md)
- [governance-as-code-ai-enforcement.md](../governance/governance-as-code-ai-enforcement.md)
- [create-new-from-scratch.md](create-new-from-scratch.md)
