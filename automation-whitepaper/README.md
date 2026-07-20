# Automation White Paper

> Standards, architecture, and best practices for Ansible automation. Based on [Red Hat CoP Automation Good Practices](https://redhat-cop.github.io/automation-good-practices/).

## 🚀 Quick Navigation


| I want to...                    | Go to                                                                                                                                         |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **Start here (first visit)**    | [getting-started.md](guides/getting-started.md)                                                                                               |
| **Review or fix existing code** | [evaluate-and-update-existing.md](guides/evaluate-and-update-existing.md)                                                                     |
| **Create new automation**       | [create-new-from-scratch.md](guides/create-new-from-scratch.md)                                                                               |
| **Use AI agents**               | [AI prompt examples](guides/ai-prompt-examples.md) + [../AGENTS.md](../AGENTS.md)                                                             |
| **See examples**                | [examples/](examples/) — Light & Standard profiles                                                                                            |
| **Understand the architecture** | [architecture/monorepo-layout.md](architecture/monorepo-layout.md) · [governance/whitebook-folder-map.md](governance/whitebook-folder-map.md) |


## 📖 Documentation Structure

```
automation-whitepaper/
├── 01-main-guide.md          # Start here - complete overview
├── governance/               # AI-driven governance, org model, folder map
├── adrs/                     # Optional decision records (exceptions)
├── lifecycle/                # Intake → design → test → operate
├── architecture/             # L/T/F/C, collections, monorepo
├── development/              # Roles, playbooks, coding style
├── quality/                  # Pre-commit, linting, idempotency
├── operations/               # Controller, inventory, SSOT
├── guides/                   # Step-by-step how-tos (manual path start)
├── mob-sessions/             # AI Mob Design session notes
├── examples/                 # Runnable reference code
└── templates/                # Bootstrap files for delivery repos
```

Folder map: [whitebook-folder-map.md](governance/whitebook-folder-map.md).

## 📚 Key Sections

### Governance

- **[AI-Driven Governance](governance/governance-as-code-ai-enforcement.md)** — Human as Architect; manual path + AI modes
- **[AI Mob Design](guides/ai-mob-design.md)** — Group designs, AI implements ([ADR-008](adrs/ADR-008-ai-mob-design.md))
- **[White book folder map](governance/whitebook-folder-map.md)** — WHEN/WHERE/HOW guide to each directory
- **[Optional ADRs](adrs/README.md)** — Exceptions and major decisions
- **[Strategic Proposal v1.0](governance/strategic-proposal-aap-governance-evolution.md)** — AAP, Puppet, GenAI, Dev Spaces
- [Organizational Model](governance/organizational-model-and-stakeholders.md)
- [Roles & Responsibilities](governance/roles-and-responsibilities.md)

### Lifecycle

- [Overview](lifecycle/automation-lifecycle-overview.md) — Complete lifecycle
- [Intake & Prioritization](lifecycle/intake-and-prioritization.md)
- [Design & Build](lifecycle/design-and-build.md)
- [Test & Promote](lifecycle/test-and-promote.md)
- [Operate & Improve](lifecycle/operate-and-improve.md)

### Architecture

- [Monorepo Layout](architecture/monorepo-layout.md) — Governance monorepo (`ai-auto-governance-as-code`), white book, skills, submodules
- [AAP & Puppet Coexistence Evolution](architecture/aap-puppet-coexistence-evolution.md) — Three phases: centralized orchestration, on-demand refactor, native greenfield
- [L/T/F/C Patterns](architecture/landscape-type-function-component.md)
- [Collections & EEs](architecture/collections-and-execution-environments.md)

### Development

- [Roles](development/roles.md) | [Playbooks](development/playbooks.md) | [Inventories](development/inventories-and-variables.md)
- [Coding Style](development/coding-style.md) | [Plugins](development/plugins.md)

### Quality

- **[Pre-commit Hooks](quality/pre-commit.md)** — Mandatory
- [Code Review](quality/code-review-and-linting.md)
- [Idempotency](quality/idempotency-and-check-mode.md)

### Guides

- **[Getting started](guides/getting-started.md)** — Clone, setup, first steps
- **[Evaluate & update existing](guides/evaluate-and-update-existing.md)** — Audit and fix roles/playbooks
- **[Create new from scratch](guides/create-new-from-scratch.md)** — Greenfield checklist with gates, CAB, Molecule
- **[Glossary](guides/glossary.md)** — Gates, CAB, UAT, profiles
- **[AI Prompt Examples](guides/ai-prompt-examples.md)** — Copy-paste prompts
- [Git Workflow](guides/git-automation-repository.md)
- [Dev Spaces Setup](guides/devspaces-workspace.md)

### Operations

- [Controller & Workflows](operations/controller-and-workflows.md)
- [AAP Platform Administration](operations/aap-platform-administration.md) — MCP skills, SSOT boundaries, adoption phases
- [Inventory SSOT](operations/inventory-ssot-integration.md)

## 💡 Examples

Runnable reference implementations:


| Profile      | Code                                                                  | Walkthrough                                                                |
| ------------ | --------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| **Light**    | [light-dev-packages/](examples/light-dev-packages/)                   | [walkthrough](examples/example-light-walkthrough-dev-packages.md)          |
| **Standard** | [standard-rsyslog-forwarding/](examples/standard-rsyslog-forwarding/) | [walkthrough](examples/example-complete-walkthrough-rsyslog-forwarding.md) |


**More examples:** [Three-tier landscape](examples/example-three-tier-landscape.md) • [Inventory patterns](examples/example-inventory-good-vs-bad.md) • [Role interface](examples/example-role-interface.md) • [Enterprise change flow](examples/example-enterprise-change-flow.md)
