# Automation White Paper

> **Human-authored governance** for Ansible automation — the rules your company adopts before any YAML is written or reviewed.

Based on [Red Hat CoP Automation Good Practices](https://redhat-cop.github.io/automation-good-practices/) where this guide is silent. **On conflict, this white book wins.**

AI agents do not invent policy here. Engineers and architects write these guides; the **Librarian** path translates them into [Agent Skills](../gac/README.md) (`gac/gac-*/module/skills/`). Same rules apply whether work is **manual** or **AI-assisted** — see [governance-as-code-ai-enforcement.md](governance/governance-as-code-ai-enforcement.md).

---

## Quick navigation

| I want to… | Go to |
|------------|-------|
| **Start here (first visit)** | [getting-started.md](guides/getting-started.md) |
| **Review or fix existing code** | [evaluate-and-update-existing.md](guides/evaluate-and-update-existing.md) |
| **Create new automation** | [create-new-from-scratch.md](guides/create-new-from-scratch.md) |
| **Use AI agents** | [AGENTS.md](../AGENTS.md) · [gac/README.md](../gac/README.md) · [ai-prompt-examples.md](guides/ai-prompt-examples.md) |
| **See examples** | [examples/](examples/) — Light & Standard profiles |
| **Understand the monorepo** | [architecture/monorepo-layout.md](architecture/monorepo-layout.md) · [whitebook-folder-map.md](governance/whitebook-folder-map.md) |

---

## Governance flow

```text
  automation-whitepaper/     gac/gac-*/module/skills/  AI assistant
  (human rules)         →    (encoded skills)     →    (Auditor/Builder/…)
```

Mechanical gates (pre-commit, CI) validate **artifacts**. Skills validate **behavior** during design and implementation.

---

## Documentation structure

```text
automation-whitepaper/
├── governance/     WHO   — program rules, AI modes, folder map
├── lifecycle/      WHEN  — intake → operate
├── architecture/   WHERE — L/T/F/C, monorepo, AAP
├── development/    HOW   — roles, playbooks, YAML
├── quality/        CHECK — pre-commit, lint, idempotency
├── operations/     RUN   — Controller, platform administration
├── guides/         DO    — step-by-step (best start for humans)
├── mob-sessions/   LOG   — AI Mob Design session notes
├── examples/       SEE   — compliant reference code
├── templates/      COPY  — bootstrap for delivery repos
└── adrs/           WHY   — optional exceptions
```

Folder map: [whitebook-folder-map.md](governance/whitebook-folder-map.md).

---

## Key sections

### Governance

- **[AI-Driven Governance](governance/governance-as-code-ai-enforcement.md)** — Human as Architect; manual path + AI modes
- **[AI Mob Design](guides/ai-mob-design.md)** — Group designs, AI implements ([ADR-008](adrs/ADR-008-ai-mob-design.md))
- **[GaC + ai-forge](architecture/ai-forge-gac-integration.md)** — SDLC and governance modules via Lola
- **[Strategic Proposal](governance/strategic-proposal-aap-governance-evolution.md)** — AAP, Puppet, GenAI, Dev Spaces
- [Organizational model](governance/organizational-model-and-stakeholders.md) · [Roles & responsibilities](governance/roles-and-responsibilities.md)

### Lifecycle · Architecture · Development · Quality · Guides · Operations

See [01-main-guide.md](01-main-guide.md) for the full overview, or use the quick navigation table above.

---

## Examples

| Profile | Code | Walkthrough |
|---------|------|-------------|
| **Light** | [light-dev-packages/](examples/light-dev-packages/) | [walkthrough](examples/example-light-walkthrough-dev-packages.md) |
| **Standard** | [standard-rsyslog-forwarding/](examples/standard-rsyslog-forwarding/) | [walkthrough](examples/example-complete-walkthrough-rsyslog-forwarding.md) |

More: [examples/README.md](examples/README.md)
