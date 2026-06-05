# AI prompt examples — using ai-auto-skills and Agent Skills

Copy-paste prompts for **any** AI agent (Cursor, Claude, Copilot, or other) working in the **`ai-auto-skills`** monorepo. The agent should read [AGENTS.md](../../AGENTS.md), declare its **mode** before technical output, and follow the linked skill.

**Setup is tool-specific** — choose your environment first: **[skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md)** (Cursor · Claude · Copilot · generic).

---

## 1. One-time setup

### Repository (all tools)

```bash
cd /path/to/ai-auto-skills
git submodule update --init --recursive
pip install -r requirements-dev.txt
pre-commit install   # optional
export AUTOMATION_HOME="$(pwd)"
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

### AI tool (pick one)

| Tool | Next step |
|------|-----------|
| **Cursor** | [TOOL-SETUP.md → Cursor](../../skills/TOOL-SETUP.md#cursor) — run `link-cursor-skills.sh`, open workspace |
| **Claude** | [TOOL-SETUP.md → Claude](../../skills/TOOL-SETUP.md#claude) — project knowledge or `CLAUDE.md` + read `AGENTS.md` |
| **GitHub Copilot** | [TOOL-SETUP.md → Copilot](../../skills/TOOL-SETUP.md#github-copilot) — `copilot-instructions.md` |
| **Other** | [TOOL-SETUP.md → Generic](../../skills/TOOL-SETUP.md#generic-any-agent) — no extra scripts |

---

## 2. How to invoke skills (all tools)

| Technique | Example |
|-----------|---------|
| **Name the skill** | `Use skill automation-auditor` |
| **Name the mode** | `Operate in Mode 1: The Auditor` |
| **Point to files** | `Read AGENTS.md and skills/automation-auditor/SKILL.md` |
| **IDE attachment** (Cursor, Copilot, etc.) | `@AGENTS.md` `@skills/automation-auditor/SKILL.md` `@deliveries/automation/roles/...` |
| **Reference example** | `Align with standard-rsyslog-forwarding example role` |

The agent should respond with a line such as: *I am operating in Mode 1: The Auditor.*

---

## 3. Mode 1 — The Auditor (review / refactor)

Use for existing YAML in `$AUTOMATION_REPO` or under `automation-whitepaper/examples/`.

### Full role audit

```text
Use skill automation-auditor. Read AGENTS.md.

Audit the role at deliveries/automation/roles/<function>/ against the white book.
List findings by severity (High/Medium/Low) with file paths.
Do not rewrite files yet — findings table and refactor plan only.
```

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

Compare deliveries/automation/roles/<function>/ to
automation-whitepaper/examples/standard-rsyslog-forwarding/roles/rsyslog_forward/.
What structural gaps exist? Cite paths only, no pasted YAML blocks.
```

### Fix pre-commit failures

```text
Use automation-pre-commit in Auditor mode.

I ran pre-commit in ai-auto-skills and got failures. Diagnose each hook failure
and propose minimal fixes. Paths under automation-whitepaper/examples/ only unless I say delivery repo.
```

---

## 4. Mode 2 — The Architect (new / extend automation)

Use for greenfield capabilities in **`ai-auto-deliveries`** (`deliveries/automation/`).

### New capability (standard profile)

```text
Use skill automation-architect and automation-new-automation. Read AGENTS.md.

Profile: Standard.
Create a new capability <function> (e.g. ntp_sync) in $AUTOMATION_REPO:
- one function role under roles/<function>/
- type playbook playbooks/type_<category>.yml
- docs/<function>/INTAKE.md and DESIGN.md
- inventory sample under inventory/sample/

Follow standard-rsyslog-forwarding patterns. FQCN only. Verify with syntax-check and pre-commit instructions.
```

### Light profile (lab / low risk)

```text
Mode 2 — Architect. Use automation-new-automation.

Profile: Light.
Add a dev-troubleshooting-style capability for <OS/package scenario> in the delivery collection.
Mirror automation-whitepaper/examples/light-dev-packages/ structure.
Skip Molecule unless I ask. List files you will create before editing.
```

### Extend role to new OS

```text
Use automation-architect, automation-role-development, and
automation-whitepaper/guides/extending-existing-automation.md.

Add platform support for <OsFamily> to deliveries/automation/roles/<function>/
using tasks/platforms/<OsFamily>.yml — do not clone the role.
```

### Architecture placement only (no code yet)

```text
Use automation-architecture in Architect mode.

I need automation for <describe need>. Propose Landscape / Type / Function / Component
mapping and which type playbook name to use. No YAML yet — design note only.
```

### Playbook and inventory only

```text
Use automation-playbook-inventory in Mode 2.

Add inventory sample and a thin type playbook for existing role <function>
in deliveries/automation/. No business logic in the playbook — roles only.
```

---

## 5. Mode 3 — The Librarian (standards / skills maintenance)

Use when the **white book** or **skills** must evolve — not for routine role edits.

### Adopt a new mandatory pattern

```text
Use skill automation-librarian.

We now require Molecule on Standard profile. Propose a diff plan:
1. automation-whitepaper/ (which files)
2. matching skills/*.md
3. AGENTS.md if bootstrap rules change

Do not edit files until I approve the plan.
```

### Sync skill after white book edit

```text
Mode 3 — Librarian.

I updated automation-whitepaper/quality/pre-commit.md. Sync
skills/automation-pre-commit/SKILL.md (stay under 500 lines) and tell me
if skills/README.md catalog needs a row.
```

### GPA submodule review

```text
Use automation-librarian.

Summarize what changed in automation-good-practices submodule vs last pin.
Which white paper sections and skills should we update? No submodule bump yet.
```

---

## 6. Task skills (without naming a mode)

The agent should still declare a mode; these shortcuts map cleanly:

| Goal | Prompt snippet |
|------|----------------|
| Lifecycle / intake | `Use automation-lifecycle — which phase checklist applies to <ticket description>?` |
| Governance / CAB | `Use automation-governance — who must be consulted for a Standard profile prod change?` |
| Controller / SSOT | `Use automation-controller-ops — how should inventory for <source> integrate per white book?` |
| Enterprise change narrative | `Walk through example-enterprise-change-flow.md for a middleware role prod deploy.` |
| Strategic AAP + Puppet proposal | `Read strategic-proposal-aap-governance-evolution.md — summarize phase for <scenario>` |
| Puppet → AAP phase | `Use automation-architecture — Phase 2.1 / 2.2 / 2.3 per aap-puppet-coexistence-evolution.md` |

---

## 6b. Strategic proposal — AAP, Puppet, and phases

References: [strategic-proposal-aap-governance-evolution.md](../governance/strategic-proposal-aap-governance-evolution.md) · [aap-puppet-coexistence-evolution.md](../architecture/aap-puppet-coexistence-evolution.md).

### Phase 2.1 — Centralized orchestration (wrapper playbook)

```text
Use skill automation-puppet-orchestrate. Read AGENTS.md. Mode 2 — Architect.

Create a Phase 1 wrapper type playbook in deliveries/automation/ that runs Puppet
class `<class>` via community.general.puppet with:
- noop: "{{ ansible_check_mode }}"
- summarize: true
- environment from _puppet_environment
- tags / skip_tags support
No shell puppet agent. No Phase 2 native refactor.
```

### Phase 2.2 — On-demand refactor (trigger required)

```text
Use automation-architect and automation-new-automation. Profile: Standard.

Official trigger: <major functional change | architectural rewrite | scope expansion>.
Refactor Puppet module `<module>` to native role `<function>` in deliveries/automation/.
Human-in-the-loop: propose design before YAML. Phase 1 wrapper remains for other classes.
```

### Phase 2.3 — Greenfield (native Ansible only)

```text
Mode 2 — Architect. Phase 2.3 native new development.

New capability `<function>` — greenfield only. Native collection role + type playbook.
Do not create Puppet modules. Follow AGENTS.md bootstrap rules.
```

### Phase assessment

```text
Read strategic-proposal-aap-governance-evolution.md §2.

Scenario: <describe>. Which phase (2.1 Centralized orchestration / 2.2 On-demand refactor /
2.3 Native new developments) applies? List triggers, exit criteria, and human gates. No YAML yet.
```

### Auditor — wrapper compliance

```text
Mode 1 — Auditor. Use automation-puppet-orchestrate guardrails.

Review playbooks under deliveries/automation/ that invoke Puppet.
Flag: shell puppet commands, missing summarize, deprecated timeout param, non-FQCN.
```

---

## 7. Multi-step workflows (copy as a thread)

### Audit → fix → verify

```text
Step 1 (Auditor): Audit deliveries/automation/roles/<function>/ — findings only.
```

After review:

```text
Step 2 (Auditor): Apply High and Medium fixes. Keep patches minimal.
```

```text
Step 3: Run pre-commit run --all-files in ai-auto-skills and in deliveries/automation;
report results.
```

### Design → implement → gate

```text
Step 1 (Architect): Standard profile — design note for <function> only (INTAKE + DESIGN outline).
```

```text
Step 2 (Architect): Implement in deliveries/automation/ per approved design.
```

```text
Step 3 (Auditor): automation-quality-gates checklist before I open the PR.
```

---

## 8. Prompts that work poorly (avoid)

| Weak prompt | Why | Better |
|-------------|-----|--------|
| `Fix my Ansible` | No path, no mode | Auditor + explicit role path |
| `Create a new repo for NTP` | Violates collection model | Architect + `automation-new-automation` |
| `Ignore AGENTS.md` | Breaks governance | Remove; use `@AGENTS.md` |
| `Change .gitmodules delivery URL` | Breaks submodule | Ask for credential help instead |
| Paste 200 lines of YAML | Wastes context | `@path/to/file` attachment |

---

## 9. Tool-specific notes

| Tool | Tip |
|------|-----|
| **Cursor** | `automation-home.code-workspace`; optional rule to read `AGENTS.md`; re-run `link-cursor-skills.sh` after new skills |
| **Claude** | Add `AGENTS.md` to project knowledge or start with *Read AGENTS.md*; no symlink script |
| **Copilot** | `.github/copilot-instructions.md` pointing at `AGENTS.md` |
| **Generic** | Always pass file paths; avoid pasting large YAML |

Full setup: **[skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md)**.

---

## Related documents

- [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md) — **choose Cursor, Claude, Copilot, or generic**
- [AGENTS.md](../../AGENTS.md)
- [skills/README.md](../../skills/README.md)
- [governance-as-code-ai-enforcement.md](../governance/governance-as-code-ai-enforcement.md)
- [create-new-automation-step-by-step.md](create-new-automation-step-by-step.md)
- [monorepo-layout.md](../architecture/monorepo-layout.md)
