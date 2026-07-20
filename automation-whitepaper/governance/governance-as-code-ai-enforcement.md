# AI-Driven Governance-as-Code for Ansible Automation

Open standard that replaces static style guides with an **active AI enforcement engine** for Ansible content. By encoding white book rules into **Agent Skills**, AI agents act as **Senior Lead Engineers** rather than mere assistants. Enterprise strategy: [strategic-proposal-aap-governance-evolution.md](strategic-proposal-aap-governance-evolution.md).

**Short name:** AI-Driven Governance-as-Code (use in prose after first mention in a document).

Governance is **human-authored** in the Automation Whitebook (Guide-first topic guides). **Red Hat CoP** is the baseline where the white book is silent; where they conflict, **the white book takes precedence**. There is **no automated compile pipeline** — **Librarian** mode keeps the white book and skills in sync.

---

## Paradigm: Human as the Architect

In this operational model, the **human engineer functions exclusively as the Architect**. Engineers focus on high-level strategic design, establishing compliance **Red Lines**, and executing final approval gates — not on writing syntax, debugging YAML, or manually refactoring legacy playbooks.

AI agents operate under the Architect's guidance in three **execution roles** (modes): Auditor, Builder, and Librarian. Do not confuse **Mode 2 — The Builder** (an AI execution role) with the human Architect. Engineers may also work **manually**, following the same white book guides without AI.

Implementation in this monorepo:

| Component | Path | Content | Functional role | Source |
|-----------|------|---------|-----------------|--------|
| White book | `automation-whitepaper/` | Guide-first topic guides, lifecycle, architecture, examples | Authoritative enterprise standards (human-authored) | Internal |
| Agent Skills | `gac/gac-*/module/skills/` | `SKILL.md` per skill (Lola module) | Translation of white book rules for AI agents | Internal (Librarian-synced) |
| Agent bootstrap | `AGENTS.md` | Mode selection, Builder rules, precedence confirmation | AI entry point | Internal |
| GPA baseline | `automation-good-practices/` | Red Hat CoP reference standards | Compliance baseline | Red Hat CoP (submodule) |
| Delivery collection | `deliveries/automation/` | Production roles and playbooks (`ai-auto-deliveries`) | Production execution | Internal (submodule) |
| Mechanical gates | `pre-commit`, delivery CI | Lint, syntax, policy | Automated blocking | Internal |

Canonical skill format is **`SKILL.md`**. Layout: [../architecture/monorepo-layout.md](../architecture/monorepo-layout.md). Folder map: [whitebook-folder-map.md](whitebook-folder-map.md).

### Primary architectural objectives

| Objective | Meaning |
|-----------|---------|
| **Lifecycle standardization** | Rigorous, repeatable flow across intake, design, implementation, quality, promotion, and operations |
| **Red Hat CoP alignment** | GPA submodule as the upstream baseline |
| **Enterprise adaptability** | Local white book overrides for CAB, security, SSOT, and change management |
| **Governance-as-Code** | Encoding white book standards into Agent Skills (`SKILL.md`) and mechanical quality gates — optional AI assistance on the same rules humans follow manually |

---

## Six-stage automation lifecycle

Every automation initiative follows these stages (detailed guides under [../lifecycle/](../lifecycle/)):

| Stage | Purpose | Detailed doc |
|-------|---------|--------------|
| **1 — Intake** | Formal demand management, priority assessment, success criteria | [intake-and-prioritization.md](../lifecycle/intake-and-prioritization.md) |
| **2 — Design** | L/T/F/C placement, SSOT, target execution environments | [design-and-build.md](../lifecycle/design-and-build.md), [architecture/](../architecture/) |
| **3 — Implementation** | Roles and playbooks: naming, variable scoping, modular design | [development/](../development/) |
| **4 — Quality** | Pre-commit, ansible-lint, semantic checks, Molecule idempotency | [quality/](../quality/) |
| **5 — Promotion** | Dev → Pre-Prod → Prod via GitOps and AAP Controller | [test-and-promote.md](../lifecycle/test-and-promote.md) |
| **6 — Operation & improvement** | Job metrics, systematic refactoring, technical debt removal | [operate-and-improve.md](../lifecycle/operate-and-improve.md) |

Overview diagram: [automation-lifecycle-overview.md](../lifecycle/automation-lifecycle-overview.md).

---

## Effort profiles

Tasks are triaged into three profiles to scale execution:

| Profile | When | Requirements |
|---------|------|--------------|
| **Light** | Trivial tasks (e.g. basic package install); zero external dependencies | Pre-commit; syntax-check |
| **Standard** | Baseline enterprise automation | Full compliance, standardized variables, Molecule testing |
| **Heavy** | Complex multi-tier orchestration; high business criticality | CAB, security sign-off, deep cross-platform validation |

Examples: [light-dev-packages](../examples/light-dev-packages/) · [standard-rsyslog-forwarding](../examples/standard-rsyslog-forwarding/).

---

## Operating paths

| Path | Operator | Use |
|------|----------|-----|
| **Manual** | Human engineer | Follow [guides/](../guides/getting-started.md) and examples; no AI mode declaration |
| **Mode 1 — Auditor** | AI agent | Gap analysis and remediating diffs |
| **Mode 2 — Builder** | AI agent | Greenfield or refactor to full compliance |
| **Mode 3 — Librarian** | AI agent (+ human approval) | Evolve white book and `SKILL.md` |

### Manual path (recommended to start)

1. [guides/getting-started.md](../guides/getting-started.md)
2. Reference examples: **light** and **standard** profiles under [examples/](../examples/)
3. `pre-commit run --all-files` and `ansible-playbook --syntax-check`

Manual operation is **first-class**. AI modes apply the **same rules**, faster.

### Three AI operating modes

| Mode | Type | Agent responsibility | Specific actions |
|------|------|----------------------|----------------|
| **1 — The Auditor** | Retroactive | Scan legacy or incoming codebases for technical debt. | Gap analysis: missing variable prefixes, FQCN violations, legacy loops; output findings and remediating diffs. |
| **2 — The Builder** | Proactive | Generate net-new automation or refactor to 100% compliance. | Bootstrap from `AGENTS.md` and `skills/` before rendering YAML; meet Red Line standards by design. |
| **3 — The Librarian** | Maintenance | Keep white book and skills aligned. | Monitor GPA upstream; propose white book + `SKILL.md` updates. |

### Skill mapping

| Mode | Skill |
|------|--------|
| 1 — Auditor | `gac/gac-governance/module/skills/automation-auditor/SKILL.md` |
| 2 — Builder | `gac/gac-governance/module/skills/automation-builder/SKILL.md` |
| 3 — Librarian | `gac/gac-governance/module/skills/automation-librarian/SKILL.md` |

Supporting task skills (lifecycle, roles, pre-commit, etc.): [gac/README.md](../../gac/README.md).

### Execution prompt interfaces

| Mode | Example prompt |
|------|----------------|
| **1 — Auditor** | *"I am operating in Mode 1: The Auditor. I have evaluated Red Hat CoP baseline rules against white book overrides. Review `roles/webserver/tasks/main.yml` and output compliance violations with remediating diffs."* |
| **2 — Builder** | *"I am operating in Mode 2: The Builder. I have evaluated Red Hat CoP baseline rules against white book overrides. Generate a new Nginx role with internal variable prefixing for registered results."* |
| **3 — Librarian** | *"I am operating in Mode 3: The Librarian. I have evaluated Red Hat CoP baseline rules against white book overrides. CoP updated vault guidance — propose white book and SKILL.md updates."* |

More prompts: [../guides/ai-prompt-examples.md](../guides/ai-prompt-examples.md).

---

## Optional ADRs

Teams **may** write an ADR when a decision needs formal traceability. ADRs **supplement** the white book; normative rules stay in guides. See [../adrs/README.md](../adrs/README.md).

| Type | Typical use |
|------|-------------|
| STRUCTURAL | Exceptions to L/T/F/C or repo layout |
| CODING_STANDARD | Org-wide rule adoption record |
| SECURITY_POLICY | Security deviations |
| LIFECYCLE_POLICY | Promotion exceptions |
| GOVERNANCE_RULE | New Red Line |
| EVOLUTION_RULE | Deprecations, GPA or skill renames |
| EXCEPTION_POLICY | Approved standard deviation |

---

## Rule of precedence

`SKILL.md` logic **operationalizes** white book and CoP guardrails for AI agents.

| Priority | Source | Rule |
|----------|--------|------|
| **1 — Foundation** | Red Hat CoP [automation-good-practices](https://github.com/redhat-cop/automation-good-practices) | Default baseline where the white book is **silent** |
| **2 — Supreme override** | Enterprise white book (`automation-whitepaper/`) | On conflict, **white book wins** |
| **3 — AI encoding** | `gac/gac-*/module/skills/*/SKILL.md` + `AGENTS.md` | Operationalizes 1–2 for AI; must match white book |
| **4 — Mechanical** | pre-commit, ansible-lint, CI | Validates **code artifacts** |

Violations of the effective rule set are **non-compliant** and must be remediated before merge — via review policy, agents, and mechanical hooks.

Example ADR: [ADR-003](../adrs/ADR-003-enforcement-precedence.md).

### COP foundation (base law)

Where the white book does not override:

- **FQCN** — mandatory on all modules; short-form forbidden
- **Idempotency** — tasks reach `ok` on re-run; `command`/`shell` need explicit change tracking
- **Modern loops** — `with_*` deprecated; use `loop:` + `loop_control` + labels

### White book overrides (custom law)

Enterprise mandates take absolute authority when they overlap COP:

- **L/T/F/C inventory matrix** — every asset must map to Landscape / Type / Function / Component ([definitions](../architecture/landscape-type-function-component.md))
- **Variable scoping** — internal vars with `_` prefix; public vars `rolename_*` (GPA); role loops `__rolename_…`
- **Strict boolean typing** — unquoted lowercase `true` / `false`

Under this model, **all automation — manual or AI-generated** — must conform to the white book before secondary alignment to CoP.

### Native-first execution mandate

- `ansible.builtin.shell` and `ansible.builtin.command` are **heavily restricted**
- If a native module exists, the Builder **refuses** shell/command
- When shell is the only option, the Builder adds a **Documentation Gate** comment above the task explaining why native alternatives failed, plus explicit `changed_when` and `failed_when`

Details: [../development/coding-style.md](../development/coding-style.md). Example ADR: [ADR-005](../adrs/ADR-005-native-first-execution.md).

---

## Runtime execution rule

**AI agents** must, before Ansible YAML or remediation advice:

1. **Declare** the active operational mode (Auditor, Builder, or Librarian)
2. **Confirm** evaluation of the Red Hat CoP baseline against white book overrides

Example:

> I am operating in **Mode 1: The Auditor**. I have evaluated Red Hat CoP baseline rules against white book overrides.

**Manual (human-only) work** does not require mode declaration.

**pre-commit and CI** validate **code** (YAML, lint, secrets) — not natural-language mode declarations in chat. Mode declaration is **policy for AI-assisted work**, documented in [AGENTS.md](../../AGENTS.md).

Humans may request a mode explicitly:

- *"Audit this role"* → Mode 1
- *"Create a new NTP sync capability"* → Mode 2
- *"We now require Molecule on standard profile — update governance"* → Mode 3

---

## Librarian workflow (summary)

1. Change **white paper** markdown first (`automation-whitepaper/`).
2. Sync the matching **`skills/<name>/SKILL.md`** (keep each skill under ~500 lines).
3. Update [AGENTS.md](../../AGENTS.md) if mode or bootstrap rules change.
4. Update [gac/README.md](../../gac/README.md) catalog if skills are added or renamed.
5. Sync skills via [Lola](../../skills/TOOL-SETUP.md#lola-recommended) (`lola install gac -a <assistant>`) per [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md).
6. Record rationale in PR description; pin `automation-good-practices` submodule when adopting GPA changes.

Example ADR: [ADR-004](../adrs/ADR-004-librarian-synchronization.md).

---

## Program scope

This program applies to **Ansible automation** managed under `<automation-home>` and the shared delivery collection `<automation-repo>`. It complements — does not replace — human governance (RACI, CAB, security sign-off).

## RACI note

Mode selection does not replace [roles-and-responsibilities.md](roles-and-responsibilities.md). **Heavy** profile changes still require human CAB, security, and operations sign-off; agents prepare evidence and diffs, humans approve production risk.

---

## Related documents

- [whitebook-folder-map.md](whitebook-folder-map.md)
- [../adrs/README.md](../adrs/README.md)
- [organizational-model-and-stakeholders.md](organizational-model-and-stakeholders.md)
- [roles-and-responsibilities.md](roles-and-responsibilities.md)
- [../quality/pre-commit.md](../quality/pre-commit.md)
- [../../AGENTS.md](../../AGENTS.md)
