# AI-Driven Governance-as-Code for Ansible Automation

Open standard that replaces static style guides with an **active AI enforcement engine** for Ansible content. By encoding white book rules into **Agent Skills**, AI agents act as **Senior Lead Engineers** rather than mere assistants. Enterprise strategy: [strategic-proposal-aap-governance-evolution.md](strategic-proposal-aap-governance-evolution.md).

**Short name:** AI-Driven Governance-as-Code (use in prose after first mention in a document).

---

## Paradigm: Human as the Architect

In this operational model, the **human engineer functions exclusively as the Architect**. Engineers focus on high-level strategic design, establishing compliance **Red Lines**, and executing final approval gates — not on writing syntax, debugging YAML, or manually refactoring legacy playbooks.

AI agents operate under the Architect's guidance in three **execution roles** (modes): Auditor, Builder, and Librarian. Do not confuse **Mode 2 — The Builder** (an AI execution role) with the human Architect.

Implementation in this monorepo:

| Component | Path | Content | Functional role | Source |
|-----------|------|---------|-----------------|--------|
| White book | `automation-whitepaper/` | Core architecture, lifecycle guides, effort profiles | Authoritative standards | Internal |
| Agent Skills | `skills/` (`SKILL.md`; some tools use `.mdc`) | Behavioral logic and instruction sets | Active enforcement engine | Internal |
| GPA baseline | `automation-good-practices/` | Red Hat CoP reference standards | Compliance baseline | Red Hat CoP (submodule) |
| Delivery collection | `deliveries/automation/` | Production roles and playbooks (`ai-auto-deliveries`) | Production execution | Internal (submodule) |
| Mechanical gates | `pre-commit`, delivery CI | Lint, syntax, policy | Automated blocking | Internal |

Layout: [../architecture/monorepo-layout.md](../architecture/monorepo-layout.md).

### Primary architectural objectives

| Objective | Meaning |
|-----------|---------|
| **Lifecycle standardization** | Rigorous, repeatable flow across intake, design, implementation, quality, promotion, and operations |
| **Red Hat CoP alignment** | GPA submodule as the upstream baseline |
| **Enterprise adaptability** | Local white book overrides for CAB, security, SSOT, and change management |
| **Governance-as-Code** | Static documentation compiled into AI skills that block technical debt at creation |

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

## Three AI operating modes

| Mode | Type | Agent responsibility | Specific actions |
|------|------|----------------------|----------------|
| **1 — The Auditor** | Retroactive | Scan legacy or incoming codebases for technical debt. | Gap analysis: missing variable prefixes, FQCN violations, legacy loops; output findings and remediating diffs. |
| **2 — The Builder** | Proactive | Generate net-new automation or refactor to 100% compliance. | Bootstrap from `AGENTS.md` and `skills/` before rendering YAML; meet Red Line standards by design. |
| **3 — The Librarian** | Maintenance | Keep the `skills/` engine current. | Monitor GPA upstream and platform shifts (Molecule, Satellite, Vault); propose white book + `SKILL.md` updates. |

### Skill mapping

| Mode | Skill |
|------|--------|
| 1 — Auditor | `skills/automation-auditor/SKILL.md` |
| 2 — Builder | `skills/automation-builder/SKILL.md` |
| 3 — Librarian | `skills/automation-librarian/SKILL.md` |

Supporting task skills (lifecycle, roles, pre-commit, etc.): [skills/README.md](../../skills/README.md).

### Execution prompt interfaces

| Mode | Example prompt |
|------|----------------|
| **1 — Auditor** | *"I am executing in Mode 1. Review `roles/webserver/tasks/main.yml` against the Whitebook rules and output all compliance violations with remediating diffs."* |
| **2 — Builder** | *"I am executing in Mode 2. Generate a new Nginx role that implements internal variable prefixing for all registered execution results."* |
| **3 — Librarian** | *"I am executing in Mode 3. Red Hat has updated its security guidance regarding vault-encrypted string declarations. Propose an optimized update to our general skill definitions."* |

More prompts: [../guides/ai-prompt-examples.md](../guides/ai-prompt-examples.md).

---

## Rule of precedence

`SKILL.md` logic compiles operational guardrails: industry baseline plus enterprise mandates.

| Priority | Source | Rule |
|----------|--------|------|
| **1 — Foundation** | Red Hat CoP [automation-good-practices](https://github.com/redhat-cop/automation-good-practices) | Default baseline where the white book is silent |
| **2 — Supreme override** | Enterprise white book (`automation-whitepaper/`) | Where rules overlap or conflict, the **white book wins**; the COP rule is discarded |

Violations of either layer (after precedence) are **compilation failures** — blocked by agents and pre-commit.

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

### Native-first execution mandate

- `ansible.builtin.shell` and `ansible.builtin.command` are **heavily restricted**
- If a native module exists, the Builder **refuses** shell/command
- When shell is the only option, the Builder adds a **Documentation Gate** comment above the task explaining why native alternatives failed, plus explicit `changed_when` and `failed_when`

Details: [../development/coding-style.md](../development/coding-style.md).

---

## Runtime execution rule

Before outputting YAML or architectural advice, the AI agent must:

1. **Declare its active operational mode** (Auditor, Builder, or Librarian)
2. **Confirm** it has evaluated the Red Hat COP baseline against active white book precedence overrides

Example:

> I am operating in **Mode 1: The Auditor**. I have evaluated Red Hat COP baseline rules against white book overrides (variable scoping, L/T/F/C, native-first).

Technical payloads delivered without this initialization block are rejected by governance hooks and review policy.

Humans may request a mode explicitly:

- *"Audit this role"* → Mode 1
- *"Create a new NTP sync capability"* → Mode 2
- *"We now require Molecule on standard profile — update governance"* → Mode 3

---

## Librarian workflow (summary)

1. Change **white paper** markdown first (`automation-whitepaper/`).
2. Sync the matching **`skills/<name>/SKILL.md`** (keep each skill under ~500 lines).
3. Update [skills/README.md](../../skills/README.md) catalog if skills are added or renamed.
4. Update [AGENTS.md](../../AGENTS.md) if mode or bootstrap rules change.
5. Sync skills in your AI tool per [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md) (Cursor: `link-cursor-skills.sh`; others: project knowledge / instructions).
6. Record rationale in PR description; pin `automation-good-practices` submodule when adopting GPA changes.

---

## Program scope

This program applies to **Ansible automation** managed under `<automation-home>` and the shared delivery collection `<automation-repo>`. It complements — does not replace — human governance (RACI, CAB, security sign-off).

## RACI note

Mode selection does not replace [roles-and-responsibilities.md](roles-and-responsibilities.md). **Heavy** profile changes still require human CAB, security, and operations sign-off; agents prepare evidence and diffs, humans approve production risk.

---

## Related documents

- [organizational-model-and-stakeholders.md](organizational-model-and-stakeholders.md)
- [roles-and-responsibilities.md](roles-and-responsibilities.md)
- [../quality/pre-commit.md](../quality/pre-commit.md)
- [../../AGENTS.md](../../AGENTS.md)
