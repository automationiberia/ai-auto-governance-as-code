# Monorepo layout — governance, intelligence, and delivery

This document describes the **centralized monorepo** pattern used to separate **standards**, **AI enforcement**, and **production Ansible code**. The layout is organization-agnostic; adopters clone or vendor the governance repository and wire their own delivery-collection remote.

---

## Purpose

A single governance monorepo (this repository is commonly named **`ai-auto-governance-as-code`**) is the **single point of entry** for:

- Normative standards and process documentation
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
| **`automation-whitepaper/`** | White book: architecture, lifecycle, effort profiles, examples | Authoritative standards | Internal |
| **`skills/`** | Agent Skills (`SKILL.md`; some tools use `.mdc`) | Active enforcement engine | Internal |
| **`automation-good-practices/`** | Red Hat CoP GPA reference | Compliance baseline | Red Hat CoP (submodule) |
| **`deliveries/automation/`** | Shared collection [`ai-auto-deliveries`](https://github.com/automationiberia/ai-auto-deliveries) | Production execution | Internal (submodule) |

Additional root artifacts:

| Path | Function |
|------|----------|
| **`AGENTS.md`** | Agent bootstrap: human-as-Architect paradigm, three AI modes (Auditor / Builder / Librarian), Builder rules (FQCN, naming, collection model). |
| **`requirements-dev.txt`**, **`.pre-commit-config.yaml`** | Mechanical quality gates for the governance repo and examples. |
| **`deliveries/README.md`** | How the delivery submodule relates to the monorepo. |

---

## Data and control flow

```text
                    ┌─────────────────────────────┐
                    │  automation-good-practices  │
                    │  (Red Hat CoP GPA upstream) │
                    └──────────────┬──────────────┘
                                   │ informs (Librarian)
                                   ▼
┌──────────────────────────────────────────────────────────────┐
│  Governance monorepo (e.g. ai-auto-governance-as-code)                   │
│  ┌────────────────────┐    ┌─────────────────────────────┐   │
│  │ automation-whitepaper │──│ skills/ + AGENTS.md         │   │
│  │ (white book)         │    │ (AI intelligence layer)    │   │
│  └────────────────────┘    └─────────────────────────────┘   │
└──────────────────────────────┬───────────────────────────────┘
                               │ encodes rules for
                               ▼
                    ┌─────────────────────────────┐
                    │  deliveries/automation/     │
                    │  (delivery collection,      │
                    │   ai-auto-deliveries)       │
                    │  roles + type playbooks     │
                    └─────────────────────────────┘
```

| Layer | Consumed by |
|-------|-------------|
| White book | Engineers, auditors, change managers |
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
- [landscape-type-function-component.md](landscape-type-function-component.md)
- [collections-and-execution-environments.md](collections-and-execution-environments.md)
- [../../deliveries/README.md](../../deliveries/README.md)
- [../guides/git-automation-repository.md](../guides/git-automation-repository.md)
