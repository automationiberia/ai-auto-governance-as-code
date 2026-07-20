# Monorepo layout — governance, intelligence, and delivery

This document describes the **centralized monorepo** pattern used to separate **standards**, **AI enforcement**, and **production Ansible code**. The layout is organization-agnostic; adopters clone or vendor the governance repository and wire their own delivery-collection remote.

---

## Purpose

A single governance monorepo (this repository is commonly named **`ai-auto-governance-as-code`**) is the **single point of entry** for:

- Normative standards and process documentation (Guide-first white book)
- Runnable reference examples
- The **intelligence layer** (Agent Skills) that drives consistent create / review / govern behavior

By moving away from **loose playbooks** scattered across teams and repositories, adopters establish a **unified framework** that:

- Aligns with the [Red Hat Community of Practice — Automation Good Practices](https://github.com/redhat-cop/automation-good-practices) (GPA)
- Remains adaptable to **enterprise-grade change flows** (CAB, security review, SSOT inventory) via optional governance narratives and profiles (**light / standard / heavy**)

Production implementation code lives in a **separate delivery collection** (submodule), not mixed with the standard itself.

---

## Architectural components

| Path | Content | Functional role | Source |
|------|---------|-----------------|--------|
| **`automation-whitepaper/`** | Guide-first white book: lifecycle, architecture, guides, optional `adrs/` | Authoritative enterprise standards (human-authored) | Internal |
| **`gac/gac-*/module/skills/`** | Lola module skills (`SKILL.md` per skill) | AI enforcement layer (Librarian-synced) | Internal |
| **`gac/gac-*/module/commands/`** | Lola slash commands (`/audit`, `/build`, …) | Mode entry points | Internal |
| **`skills/`** | `TOOL-SETUP.md`, `vendor/` submodule only | Install docs + AAPSL upstream reference | Internal |
| **`AGENTS.md`** | Mode selection, Builder bootstrap, precedence confirmation | AI entry point | Internal |
| **`automation-good-practices/`** | Red Hat CoP GPA reference (submodule pin) | Compliance baseline | Red Hat CoP (submodule) |
| **`.lola-req`**, **`lola-market.yml`** | Lola manifests | SDLC via ai-forge; GaC installable as module | Internal + [ai-forge](https://github.com/ansible-community/ai-forge) |
| **`deliveries/automation/`** | Shared collection [`ai-auto-deliveries`](https://github.com/automationiberia/ai-auto-deliveries) | Production execution | Internal (submodule) |

Additional root artifacts:

| Path | Function |
|------|----------|
| **`requirements-dev.txt`**, **`.pre-commit-config.yaml`** | Mechanical quality gates for the governance repo and examples |
| **`deliveries/README.md`** | How the delivery submodule relates to the monorepo |

Canonical skill format is **`SKILL.md`**. There is **no automated compile pipeline** to `.mdc` or other formats.

White book folder map: [../governance/whitebook-folder-map.md](../governance/whitebook-folder-map.md).

**GaC vs ai-forge:** [ai-forge-gac-integration.md](ai-forge-gac-integration.md) — SDLC from ai-forge; CoP from submodule.

**Lola install target:** `lola install gac` wires skills into the **AI assistant** (e.g. `.cursor/skills/`), **not** into `automation-whitepaper/`. The white book is read from the git clone. See [Where Lola installs](ai-forge-gac-integration.md#where-lola-installs-explicit).

---

## Data and control flow

```text
                    ┌─────────────────────────────┐
                    │  automation-good-practices  │
                    │  (Red Hat CoP GPA upstream) │
                    └──────────────┬──────────────┘
                                   │ baseline; Librarian monitors
                                   ▼
┌──────────────────────────────────────────────────────────────┐
│  Governance monorepo (ai-auto-governance-as-code)          │
│  ┌────────────────────┐    ┌─────────────────────────────┐ │
│  │ automation-whitepaper │──│ gac/gac-*/module/ + AGENTS.md │ │
│  │ (Guide-first)        │    │ (AI operationalization)   │ │
│  └────────────────────┘    └─────────────────────────────┘ │
└──────────────────────────────┬───────────────────────────────┘
                               │
              ┌────────────────┴────────────────┐
              ▼                                 ▼
     Manual path (guides/)              AI modes (Auditor / Builder / Librarian)
              │                                 │
              └────────────────┬────────────────┘
                               ▼
                    ┌─────────────────────────────┐
                    │  deliveries/automation/     │
                    │  roles + type playbooks     │
                    └──────────────┬──────────────┘
                                   │ pre-commit + CI
                                   ▼
                         mechanical validation
```

| Layer | Consumed by |
|-------|-------------|
| White book | Engineers (manual), auditors, change managers |
| Agent Skills + `AGENTS.md` | AI agents (configure per [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md)) |
| Delivery collection | Ansible CLI, Controller, CI pipelines |

---

## Path placeholders

```bash
export AUTOMATION_HOME=/path/to/this/repository    # governance monorepo root
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

`<automation-home>` in documentation means the governance repository root, regardless of the directory name on disk.

---

## Related documents

- [AI-Driven Governance-as-Code](../governance/governance-as-code-ai-enforcement.md)
- [GaC + ai-forge integration](ai-forge-gac-integration.md)
- [whitebook-folder-map.md](../governance/whitebook-folder-map.md)
- [landscape-type-function-component.md](landscape-type-function-component.md)
- [collections-and-execution-environments.md](collections-and-execution-environments.md)
- [../../deliveries/README.md](../../deliveries/README.md)
- [../guides/git-automation-repository.md](../guides/git-automation-repository.md)
