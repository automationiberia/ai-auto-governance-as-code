# ai-forge and GaC — quick reference

Full architecture: **[GaC Architecture: ai-forge Integration](../architecture/ai-forge-gac-integration.md)**

---

## At a glance

| Source | Type | Role |
|--------|------|------|
| `skills/vendor/ai-forge/` | Git submodule (pinned) | SDLC slash commands (`/commit`, `/create-pr`, …) — Lola marketplace served locally |
| `gac/gac-*/module/` | Owned | Governance skills, white book encoding |
| `automation-good-practices/` | Git submodule (pinned) | CoP baseline |

| In git (not installed by Lola into the white book) | Path |
|----------------------------------------------------|------|
| White book | `automation-whitepaper/` |
| Governance skills (source) | `gac/gac-*/module/skills/` |
| AI Forge vendor (SDLC + standards) | `skills/vendor/ai-forge/` |
| CoP baseline | `automation-good-practices/` |
| Agent bootstrap | `AGENTS.md` |

### Where Lola installs

| Content | Installed into `automation-whitepaper/`? | Actual location |
|---------|------------------------------------------|-----------------|
| SDLC slash commands | **No** | Assistant + Lola cache (from local submodule) |
| Governance skills | **No** | Assistant (e.g. `.cursor/skills/`) |
| White book guides, ADRs | **No** — read from git clone | `automation-whitepaper/` unchanged |

Run `lola install` from **repo root**, not inside `automation-whitepaper/`. Details: [installation § Where Lola installs](../architecture/ai-forge-gac-integration.md#where-lola-installs-explicit).

---

## Install

| Audience | Command | Working directory |
|----------|---------|-------------------|
| Contributors | `make install` after clone (submodules + Lola from local ai-forge) | **Repo root** |
| AI assistant users | `git submodule update --init --recursive` + `lola market add ansible-content skills/vendor/ai-forge/lola-market.yml` + `lola market add gac` + `lola install gac -a <assistant>` | **Repo root** |

See [README.md](../../README.md) and the [full architecture doc](../architecture/ai-forge-gac-integration.md).

---

## Related

- [ai-forge-overrides.md](ai-forge-overrides.md)
- [ADR-009](../adrs/ADR-009-ai-forge-submodule-governance.md)
- [philosophy.md](philosophy.md)
- [cop-overrides.md](cop-overrides.md)
- [ADR-003](../adrs/ADR-003-enforcement-precedence.md)
