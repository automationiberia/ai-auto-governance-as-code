# Automation philosophy

## Community reference: Zen of Ansible

For **philosophical** guidance (simplicity, readability, clarity), optionally use ai-forge's `/ansible-zen` skill after `make install` / Lola sync.

GaC does **not** encode the 20 Zen principles locally — reference ai-forge to avoid duplication.

## Enterprise principles

Organization-specific principles live in the **automation-whitepaper** and [cop-overrides.md](cop-overrides.md), for example:

- L/T/F/C mandatory classification ([ADR-006](../adrs/ADR-006-ltfc-mandatory.md))
- AAP deployment and migration patterns ([architecture/](../architecture/))
- Approval and promotion workflows ([lifecycle/](../lifecycle/))

## CoP compliance

**Mechanical CoP compliance** uses the pinned **`automation-good-practices/`** submodule — not ai-forge's dynamic CoP fetch. This supports audit trails and version control required for governance platforms.

## Related

- [ai-forge and GaC](ai-forge-and-gac.md)
- [cop-overrides.md](cop-overrides.md)
