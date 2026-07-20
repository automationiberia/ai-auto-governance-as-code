# ai-forge and GaC — quick reference

Full architecture: **[GaC Architecture: ai-forge Integration](../architecture/ai-forge-gac-integration.md)**

---

## At a glance

| Lola module | Role |
|-------------|------|
| `@ansible-content/ansible-collection-sdlc` | SDLC slash commands (`/commit`, `/create-pr`, …) |
| `@gac/gac` | Governance skills, white book encoding, pinned CoP via submodule |

| In git (not installed by Lola into the white book) | Path |
|----------------------------------------------------|------|
| White book | `automation-whitepaper/` |
| Governance skills (source) | `gac/module/skills/` |
| CoP baseline | `automation-good-practices/` |
| Agent bootstrap | `AGENTS.md` |

### Where Lola installs

| Content | Installed into `automation-whitepaper/`? | Actual location |
|---------|------------------------------------------|-----------------|
| SDLC slash commands | **No** | Assistant + Lola cache |
| Governance skills | **No** | Assistant (e.g. `.cursor/skills/`) |
| White book guides, ADRs | **No** — read from git clone | `automation-whitepaper/` unchanged |

Run `lola install` from **repo root**, not inside `automation-whitepaper/`. Details: [installation § Where Lola installs](../architecture/ai-forge-gac-integration.md#where-lola-installs-explicit).

---

## Install

| Audience | Command | Working directory |
|----------|---------|-------------------|
| Contributors | `make install` after clone | **Repo root** |
| AI assistant users | `lola market add ansible-content` + `lola market add gac` + `lola install gac -a <assistant>` | **Repo root** |

See [README.md](../../README.md) and the [full architecture doc](../architecture/ai-forge-gac-integration.md).

---

## Related

- [philosophy.md](philosophy.md)
- [cop-overrides.md](cop-overrides.md)
- [ADR-003](../adrs/ADR-003-enforcement-precedence.md)
