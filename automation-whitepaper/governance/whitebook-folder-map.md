# Guide-first white book — folder map

The Automation Whitebook (`automation-whitepaper/`) is **human-authored** enterprise standards. Normative rules live in the topic guides below. Optional decision records go in [`adrs/`](../adrs/README.md).

```text
automation-whitepaper/
├── lifecycle/      WHEN  — request → production stages
├── architecture/   WHERE — L/T/F/C, repo layout, collections
├── development/    HOW   — Ansible rules (roles, playbooks, YAML)
├── quality/        CHECK — pre-commit, review, idempotency
├── governance/     WHO   — RACI, AI modes, program rules
├── operations/     RUN   — Controller, inventory in production
├── guides/         DO    — step-by-step (best start for new users)
├── examples/       SEE   — sample compliant code
├── templates/      COPY  — bootstrap files for new repos
└── adrs/           WHY   — optional; exceptions and major decisions only
```

| Start here if you want to… | Open |
|----------------------------|------|
| Onboard (manual, no AI) | [guides/getting-started.md](../guides/getting-started.md) |
| Write compliant YAML | [development/coding-style.md](../development/coding-style.md) |
| Classify new work (L/T/F/C) | [architecture/landscape-type-function-component.md](../architecture/landscape-type-function-component.md) |
| Record an approved exception | [adrs/](../adrs/README.md) (optional) |

## Related

- [governance-as-code-ai-enforcement.md](governance-as-code-ai-enforcement.md)
- [../README.md](../README.md)
