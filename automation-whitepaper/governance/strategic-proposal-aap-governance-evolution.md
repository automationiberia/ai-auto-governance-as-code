# Strategic Proposal: Automation Governance Model and Evolution with AAP

| Field | Value |
|-------|-------|
| **Document version** | 1.0 (Initial Draft) |
| **Target audience** | Enterprise Architecture & Automation Teams |
| **Core stack** | Ansible Automation Platform (AAP), OpenShift Dev Spaces, Puppet, GenAI Agents |
| **Repository** | `ai-auto-governance-as-code` (governance) + `ai-auto-deliveries` (Ansible collection) |

---

## TL;DR

**Goal:** AAP as centralized automation control plane + AI-driven governance.

**Approach:** Three-phase evolution (not rip-and-replace):
- **Phase 1:** AAP orchestrates existing Puppet (wrapper playbooks)
- **Phase 2:** Trigger-based refactor (only when business demands change)
- **Phase 3:** Greenfield = native Ansible only

**Tools:** OpenShift Dev Spaces, AI Agent Skills, centralized logging/RBAC.

**Key rule:** No bulk migrations. Puppet stays until business triggers change.

---

## 1. Executive summary

The primary objective is to establish **Ansible Automation Platform (AAP)** as the centralized **orchestration and automation control plane**. The enterprise unifies operations, enforces consistent security policies, and implements a **single source of truth** for reporting and auditing.

This strategy **avoids costly, high-risk rip-and-replace** migrations. It introduces a **hybrid governance model** that:

- Respects current legacy investments (**Puppet**)
- Provides a modern, scalable roadmap driven by **AI-Driven Governance-as-Code**, **GenAI Agent Skills**, and **containerized development** via **OpenShift Dev Spaces**

Implementation in this monorepo:

| Layer | Path |
|-------|------|
| White book (human standards) | `automation-whitepaper/` |
| Agent Skills (machine-actionable rules) | `skills/` + [AGENTS.md](../../AGENTS.md) |
| GPA upstream baseline | `automation-good-practices/` submodule |
| Native Ansible delivery | `deliveries/automation/` → `ai-auto-deliveries` |

Related: [governance-as-code-ai-enforcement.md](governance-as-code-ai-enforcement.md) · [monorepo-layout.md](../architecture/monorepo-layout.md).

---

## 2. Coexistence and technological evolution (AAP & Puppet)

To optimize resource allocation and eliminate operational risk, evolution from legacy configuration management to centralized orchestration follows a **three-phased, just-in-time** approach.

**Deep dive:** [aap-puppet-coexistence-evolution.md](../architecture/aap-puppet-coexistence-evolution.md).

| Phase | Horizon | Summary |
|-------|---------|---------|
| **2.1 — Centralized orchestration** | Short-term | Puppet code unchanged; **AAP orchestrates** Puppet via certified modules |
| **2.2 — On-demand refactoring** | Medium-term | **Trigger-based** Puppet → native Ansible translation only when business demands change |
| **2.3 — Native new developments** | Long-term | **Greenfield** exclusively native Ansible (collections, roles, playbooks) |

---

## 3. Governance-as-Code & AI Skills framework

Traditional text documentation becomes **machine-readable, AI-actionable** rules — without making AI mandatory for humans.

### 3.1. Centralized repository and corporate standards

Base architectural standard: [Red Hat CoP automation-good-practices](https://github.com/redhat-cop/automation-good-practices) (`automation-good-practices/` submodule), customized with explicit corporate rules:

| Rule | Requirement |
|------|-------------|
| **`_` prefix (internal)** | Variables for **internal** task logic, private loops, or backend computations use a leading underscore (e.g. `_internal_retry_count`, `_puppet_environment`). **Public** variables overridable from inventory omit the prefix. |
| **`__` loop variables (roles)** | In roles, `loop_control.loop_var` uses `__<function>_…` per GPA — see [coding-style.md](../development/coding-style.md). |
| **Syntax restrictions** | `with_items`, `with_dict`, and similar legacy loops are **blocked**; use native `loop` + `loop_control`. |
| **FQCN** | Fully qualified collection names for all modules. |

### 3.2. AI Skills architecture

The `skills/` directory hosts **system blueprints**, structural context, and guardrails for LLMs (GPT, Claude, Copilot, Ansible Lightspeed, etc.). Skills define how an AI must interact with this codebase.

| Skill type | Examples |
|------------|----------|
| **Mode skills** | [automation-auditor](../../skills/automation-auditor/SKILL.md), [automation-builder](../../skills/automation-builder/SKILL.md), [automation-librarian](../../skills/automation-librarian/SKILL.md) |
| **Phase 1 Puppet orchestration** | [automation-puppet-orchestrate](../../skills/automation-puppet-orchestrate/SKILL.md) |
| **Task skills** | [skills/README.md](../../skills/README.md) catalog |

Tool setup (agnostic): [TOOL-SETUP.md](../../skills/TOOL-SETUP.md).

### 3.3. Operational rules — when and how to use AI

AI is an **operational accelerator** with explicit boundaries.

#### When to use AI (approved)

| Use case | Mode / skill |
|----------|----------------|
| Initial design drafting (skeleton roles) | **Builder** (human Architect approves) |
| Phase 2 refactoring (Puppet DSL → Ansible YAML, **human review**) | **Builder** + peer review |
| Automated CI/CD gatekeeping (PR policy scan) | **Auditor** |
| Phase 1 wrapper playbook generation | **Builder** + [automation-puppet-orchestrate](../../skills/automation-puppet-orchestrate/SKILL.md) |
| Standards / skill maintenance | **Librarian** |

#### How to use AI (human-in-the-loop)

| Rule | Requirement |
|------|-------------|
| **Sandbox confinement** | AI proposes code in **isolated branches** or **Dev Spaces** workspaces only |
| **No direct prod deploy** | Never deploy to staging or production without **peer review** and engineering approval |
| **Decoupling clause** | AI is **optional** — all `skills/` content is human-readable Markdown; engineers can execute and audit manually |

#### Operational matrix

| | AI allowed | Human gate required |
|--|------------|---------------------|
| Draft PR / branch | Yes | — |
| Merge to main | — | Yes (review + CI) |
| AAP job template to prod | — | Yes (CAB / change process per profile) |
| Puppet wrapper first prod run | — | Yes (standard/heavy) |

Prompt library: [ai-prompt-examples.md](../guides/ai-prompt-examples.md).

---

## 4. Development ecosystem — OpenShift Dev Spaces

Human developers and AI agents share an **identical, predictable** runtime.

| Capability | Benefit |
|------------|---------|
| **Zero-configuration onboarding** | Pre-configured workspaces in the browser; reduces “works on my machine” variance |
| **Unified tooling runtime** | Each workspace includes **Ansible stack** (ansible-navigator, execution environments, ansible-lint) and, for legacy inspection, **Puppet stack** (Ruby, Puppet CLI, manifest linters) — see [devspaces-workspace.md](../guides/devspaces-workspace.md) |
| **Infrastructure optimization** | Workspaces on corporate OpenShift; idle shutdown reduces compute use |
| **Roadmap** | Foundation for **Red Hat Developer Hub** as the developer portal |

Entry point: [`.devfile.yaml`](../../.devfile.yaml) · `automation-home.code-workspace`.

---

## 5. Team impact and onboarding

| Outcome | Mechanism |
|---------|-----------|
| **Reduced time-to-market** | AI Skills accelerate wrapper playbooks and Phase 2 refactors (days vs weeks) |
| **Frictionless onboarding** | Open Dev Space → read white book → commit compliant code day one |
| **Consistent quality** | Pre-commit, ansible-lint, and Auditor-mode review for human-, Puppet-translated, or AI-generated code |

Onboarding path:

1. Clone `ai-auto-governance-as-code` with submodules
2. [TOOL-SETUP.md](../../skills/TOOL-SETUP.md) for your AI tool (optional)
3. [01-main-guide.md](../01-main-guide.md) and [create-new-automation-step-by-step.md](../guides/create-new-automation-step-by-step.md)
4. Phase-aware work: [aap-puppet-coexistence-evolution.md](../architecture/aap-puppet-coexistence-evolution.md)

---

## Document map

| Section | Detail document |
|---------|-----------------|
| §2 Phases | [aap-puppet-coexistence-evolution.md](../architecture/aap-puppet-coexistence-evolution.md) |
| §3 Governance-as-Code | [governance-as-code-ai-enforcement.md](governance-as-code-ai-enforcement.md) |
| §3 Puppet wrappers | [automation-puppet-orchestrate](../../skills/automation-puppet-orchestrate/SKILL.md) |
| §4 Dev Spaces | [devspaces-workspace.md](../guides/devspaces-workspace.md) |
| Monorepo | [monorepo-layout.md](../architecture/monorepo-layout.md) |
