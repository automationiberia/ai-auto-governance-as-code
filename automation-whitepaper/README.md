# Automation White Paper

> Standards, architecture, and best practices for Ansible automation. Based on [Red Hat CoP Automation Good Practices](https://redhat-cop.github.io/automation-good-practices/).

## 🚀 Quick Navigation

| I want to... | Go to |
|--------------|-------|
| **Create new automation** | [create-new-automation-step-by-step.md](guides/create-new-automation-step-by-step.md) |
| **Use AI agents** | [AI prompt examples](guides/ai-prompt-examples.md) + [../AGENTS.md](../AGENTS.md) |
| **See examples** | [examples/](examples/) — Light & Standard profiles |
| **Understand the architecture** | [architecture/monorepo-layout.md](architecture/monorepo-layout.md) |

## 📖 Documentation Structure

```
automation-whitepaper/
├── 01-main-guide.md          # Start here - complete overview
├── governance/               # AI-driven governance, org model
├── lifecycle/                # Intake → design → test → operate
├── architecture/             # L/T/F/C, collections, monorepo
├── development/              # Roles, playbooks, coding style
├── quality/                  # Pre-commit, linting, idempotency
├── operations/               # Controller, inventory, SSOT
├── guides/                   # Step-by-step how-tos
└── examples/                 # Runnable reference code
```

## 📚 Key Sections

### Governance

- **[AI-Driven Governance](governance/governance-as-code-ai-enforcement.md)** — Auditor / Architect / Librarian modes
- [Organizational Model](governance/organizational-model-and-stakeholders.md)
- [Roles & Responsibilities](governance/roles-and-responsibilities.md)

### Lifecycle

- [Overview](lifecycle/automation-lifecycle-overview.md) — Complete lifecycle
- [Intake & Prioritization](lifecycle/intake-and-prioritization.md)
- [Design & Build](lifecycle/design-and-build.md)
- [Test & Promote](lifecycle/test-and-promote.md)
- [Operate & Improve](lifecycle/operate-and-improve.md)

### Architecture

- [Monorepo Layout](architecture/monorepo-layout.md)
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

- **[AI Prompt Examples](guides/ai-prompt-examples.md)** — Copy-paste prompts
- **[New Automation Steps](guides/create-new-automation-step-by-step.md)**
- [Git Workflow](guides/git-automation-repository.md)
- [Dev Spaces Setup](guides/devspaces-workspace.md)
- [Extending Automation](guides/extending-existing-automation.md)

### Operations

- [Controller & Workflows](operations/controller-and-workflows.md)
- [Inventory SSOT](operations/inventory-ssot-integration.md)

## 💡 Examples

Runnable reference implementations:

| Profile | Code | Walkthrough |
|---------|------|-------------|
| **Light** | [light-dev-packages/](examples/light-dev-packages/) | [walkthrough](examples/example-light-walkthrough-dev-packages.md) |
| **Standard** | [standard-rsyslog-forwarding/](examples/standard-rsyslog-forwarding/) | [walkthrough](examples/example-complete-walkthrough-rsyslog-forwarding.md) |

**More examples:** [Three-tier landscape](examples/example-three-tier-landscape.md) • [Inventory patterns](examples/example-inventory-good-vs-bad.md) • [Role interface](examples/example-role-interface.md) • [Enterprise change flow](examples/example-spanish-enterprise-change-flow.md)
