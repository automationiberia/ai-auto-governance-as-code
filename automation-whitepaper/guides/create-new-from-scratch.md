# Create new automation from scratch

Minimal path from idea to merged role. **Full checklist:** [create-new-automation-step-by-step.md](create-new-automation-step-by-step.md).
**What are gates / CAB?** See [glossary.md](glossary.md).

---

## Before you start

| Question | If no → stop |
|----------|----------------|
| Is the task repeatable? | Automate only recurring work |
| Can you describe desired state? | Clarify intake first |
| Is there a ticket or backlog item? | Required for **standard** / **heavy** |

Pick a profile:

| Profile | Use when |
|---------|----------|
| **Light** | Lab, single role, low risk |
| **Standard** | Production or shared collection |
| **Heavy** | Privileged, regulated, multi-tier |

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

---

## Step 2 — Intake (5 minutes)

Capture in the ticket or `docs/rolename/INTAKE.md`:

- **Problem** — what manual work goes away?
- **Success** — how do we know it worked?
- **Scope** — prod or lab only? Which hosts?

Details: [intake-and-prioritization.md](../lifecycle/intake-and-prioritization.md).

**AI shortcut:**

```text
I am operating in Mode 2: The Builder.
Draft docs/rolename/INTAKE.md: problem, success criteria, scope (prod vs lab), hosts.
No YAML. Profile: Light.
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

Reference: [landscape-type-function-component.md](../architecture/landscape-type-function-component.md).

**AI shortcut (no YAML yet):**

```text
I am operating in Mode 2: The Builder.
Standard profile. INTAKE + DESIGN outline for rolename. No YAML yet.
```

---

## Step 4 — Scaffold

One capability = one **function role** in the shared collection (never a new Git repo per project).

```bash
cd "$AUTOMATION_REPO"
ansible-galaxy init roles/rolename
mkdir -p playbooks inventory/sample/group_vars/all
```

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
roles/rolename/, playbooks/type_<category>.yml, docs/rolename/.
List files before editing. No task logic yet.
Profile: Light. Follow AGENTS.md and automation-new-automation skill.
```

---

## Step 5 — Implement (rules that block merge)

| Rule | Requirement |
|------|-------------|
| Modules | FQCN only (`ansible.builtin.package`, not `package`) |
| Variables | Public: `rolename_*` · Internal: `_…` · Loops: `__rolename_…` |
| Tasks | Imperative `name:` on every task |
| Templates | `.j2` + `{{ ansible_managed \| comment }}` |
| Shell | Avoid; if required, Documentation Gate comment + `changed_when` |

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
Profile: Light. Follow AGENTS.md bootstrap rules (FQCN, naming, loop_control).
Align structure to automation-whitepaper/examples/light-dev-packages/.
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

| Profile | Extra gate |
|---------|------------|
| Light | Lab run + idempotent re-run |
| Standard | Peer review + Molecule if shared |
| Heavy | Security review + CAB + Molecule required |

**AI shortcut:**

```text
Run ansible-playbook --syntax-check and pre-commit run --all-files
in deliveries/automation/. Report results.

If gates fail, switch to Mode 1: The Auditor and use automation-quality-gates.
```

Same thread as Step 5 — see [ai-prompt-examples.md § Design → implement → gate](ai-prompt-examples.md#9-other-multi-step-workflows).

---

## Step 7 — Ship

1. Commit on feature branch in `$AUTOMATION_REPO`
2. Open PR with design note + test output
3. After merge: tag version, update Controller job template (if prod)

Promotion details: [test-and-promote.md](../lifecycle/test-and-promote.md).

**AI shortcut:**

```text
Draft PR title and body for deliveries/automation/ feature branch.
Include: DESIGN.md summary, syntax-check + pre-commit results, profile gates passed.
Format: .github/PULL_REQUEST_TEMPLATE.md
Do not commit or push unless I ask.
```

---

## Quick links

| Need | Document |
|------|----------|
| Full gated checklist | [create-new-automation-step-by-step.md](create-new-automation-step-by-step.md) |
| Git / collection layout | [git-automation-repository.md](git-automation-repository.md) |
| Light walkthrough | [example-light-walkthrough-dev-packages.md](../examples/example-light-walkthrough-dev-packages.md) |
| Standard walkthrough | [example-complete-walkthrough-rsyslog-forwarding.md](../examples/example-complete-walkthrough-rsyslog-forwarding.md) |
| AI prompts | [ai-prompt-examples.md](ai-prompt-examples.md) |

---

## Related

- [getting-started.md](getting-started.md)
- [evaluate-and-update-existing.md](evaluate-and-update-existing.md)
