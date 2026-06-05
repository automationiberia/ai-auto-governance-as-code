# Automation Department White Paper

This white paper defines recommended processes, practices, and procedures for the automation department. It is derived from community good practices ([Red Hat COP — Automation Good Practices](https://redhat-cop.github.io/automation-good-practices/)) and adapted for organizational use, including collaboration with traditional enterprise teams typical in Spanish organizations.

## How to read this documentation

| Level | Location | Purpose |
|-------|----------|---------|
| **1 — Main guide** | [01-main-guide.md](01-main-guide.md) | End-to-end processes and flows for creating and maintaining automation |
| **2 — Domain guides** | Subdirectories below | Focused guidance per topic (divide and conquer) |
| **3 — Deep dives** | Nested documents in each domain | Detailed rules, rationale, and checklists |
| **4 — Practical examples** | [examples/](examples/) | Worked scenarios tying guidance to real patterns |
| **New automation** | [guides/create-new-automation-step-by-step.md](guides/create-new-automation-step-by-step.md) | Checklist (light/standard/heavy) from intake to operations |
| **Agent skills** | [../skills/TOOL-SETUP.md](../skills/TOOL-SETUP.md), [../skills/README.md](../skills/README.md), [../AGENTS.md](../AGENTS.md) | Tool-agnostic; configure per Cursor / Claude / Copilot / other |

## Document map

### Governance and people

- [governance/strategic-proposal-aap-governance-evolution.md](governance/strategic-proposal-aap-governance-evolution.md) — **Strategic Proposal v1.0** (AAP, Puppet, GenAI, Dev Spaces)
- [governance/governance-as-code-ai-enforcement.md](governance/governance-as-code-ai-enforcement.md) — **AI-Driven Governance-as-Code for Ansible Automation** (Auditor / Architect / Librarian)
- [governance/organizational-model-and-stakeholders.md](governance/organizational-model-and-stakeholders.md) — Who participates, when, and why
- [governance/roles-and-responsibilities.md](governance/roles-and-responsibilities.md) — RACI-style responsibilities for automation work

### Lifecycle

- [lifecycle/automation-lifecycle-overview.md](lifecycle/automation-lifecycle-overview.md) — From idea to retirement
- [lifecycle/intake-and-prioritization.md](lifecycle/intake-and-prioritization.md)
- [lifecycle/design-and-build.md](lifecycle/design-and-build.md)
- [lifecycle/test-and-promote.md](lifecycle/test-and-promote.md)
- [lifecycle/operate-and-improve.md](lifecycle/operate-and-improve.md)

### Architecture

- [architecture/monorepo-layout.md](architecture/monorepo-layout.md) — Governance monorepo (`ai-auto-skills`), white book, skills, submodules
- [architecture/aap-puppet-coexistence-evolution.md](architecture/aap-puppet-coexistence-evolution.md) — §2 three phases: centralized orchestration, on-demand refactor, native greenfield
- [architecture/landscape-type-function-component.md](architecture/landscape-type-function-component.md)
- [architecture/collections-and-execution-environments.md](architecture/collections-and-execution-environments.md)

### Development (Ansible content)

- [development/roles.md](development/roles.md)
- [development/playbooks.md](development/playbooks.md)
- [development/inventories-and-variables.md](development/inventories-and-variables.md)
- [development/plugins.md](development/plugins.md)
- [development/coding-style.md](development/coding-style.md)

### Quality

- [quality/pre-commit.md](quality/pre-commit.md) — **Mandatory** pre-commit hooks
- [quality/idempotency-and-check-mode.md](quality/idempotency-and-check-mode.md)
- [quality/code-review-and-linting.md](quality/code-review-and-linting.md)

### Guides

- [guides/ai-prompt-examples.md](guides/ai-prompt-examples.md) — **Copy-paste prompts** (any AI tool; setup in [skills/TOOL-SETUP.md](../skills/TOOL-SETUP.md))
- [guides/create-new-automation-step-by-step.md](guides/create-new-automation-step-by-step.md) — Step-by-step for new automation
- [guides/git-automation-repository.md](guides/git-automation-repository.md)
- [guides/devspaces-workspace.md](guides/devspaces-workspace.md) — Dev Spaces / OpenShift Dev Spaces — Initialize `<automation-repo>` under `deliveries/`
- [guides/extending-existing-automation.md](guides/extending-existing-automation.md) — Extend same role (new OS / servers)
- [../deliveries/README.md](../deliveries/README.md) — Where real automation repos live

### Operations

- [operations/controller-and-workflows.md](operations/controller-and-workflows.md)
- [operations/inventory-ssot-integration.md](operations/inventory-ssot-integration.md)

### Examples

Runnable code lives under [examples/](examples/README.md); walkthrough docs link to real files.

| Profile | Walkthrough | Code |
|---------|-------------|------|
| Light | [example-light-walkthrough-dev-packages.md](examples/example-light-walkthrough-dev-packages.md) | [light-dev-packages/](examples/light-dev-packages/) |
| Standard | [example-complete-walkthrough-rsyslog-forwarding.md](examples/example-complete-walkthrough-rsyslog-forwarding.md) | [standard-rsyslog-forwarding/](examples/standard-rsyslog-forwarding/) |

Other narratives: [example-three-tier-landscape.md](examples/example-three-tier-landscape.md), [example-inventory-good-vs-bad.md](examples/example-inventory-good-vs-bad.md), [example-role-interface.md](examples/example-role-interface.md), [example-spanish-enterprise-change-flow.md](examples/example-spanish-enterprise-change-flow.md)

## Source reference

Technical Ansible guidance in this white paper aligns with the [Automation Good Practices (GPA)](https://github.com/redhat-cop/automation-good-practices) repository maintained by the Red Hat Community of Practice. Local copies of illustrative code may exist under `automation-good-practices/` in this workspace.

## Language

All department-facing documentation in this tree is written in **English**.
