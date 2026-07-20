# ai-forge and GaC — quick reference

Full architecture: **[GaC Architecture: ai-forge Integration](../architecture/ai-forge-gac-integration.md)**

---

## At a glance

| From ai-forge (Lola) | From GaC (local, in git) |
|----------------------|--------------------------|
| `/commit`, `/create-pr`, `/release`, `/changelog-fragment` | `automation-good-practices/` submodule (pinned CoP) |
| Optional: `/ansible-zen` | `automation-whitepaper/`, `AGENTS.md`, `skills/` |

GaC consumes ai-forge for **SDLC only**. CoP compliance stays **version-controlled** in the submodule — not via ai-forge's dynamic CoP fetch.

### Where Lola installs (not `automation-whitepaper/`)

| Content | Installed into `automation-whitepaper/`? | Actual location |
|---------|------------------------------------------|-----------------|
| ai-forge SDLC slash commands | **No** | Assistant + Lola cache |
| GaC skills (`skills/`) | **No** | Assistant (e.g. `.cursor/skills/`) |
| White book guides, ADRs | **No** — read from git clone | `automation-whitepaper/` unchanged |

Run `lola install` from **repo root**, not inside `automation-whitepaper/`. Details: [installation § Where Lola installs](../architecture/ai-forge-gac-integration.md#where-lola-installs-explicit).

---

## Install

| Audience | Command | Working directory |
|----------|---------|-------------------|
| Contributors | `make install` after clone | **Repo root** |
| AI assistant users | `lola install gac -a <assistant>` | **Repo root** |

See [README.md](../../README.md) and the [full architecture doc](../architecture/ai-forge-gac-integration.md).

---

## Related

- [philosophy.md](philosophy.md)
- [cop-overrides.md](cop-overrides.md)
- [ADR-003](../adrs/ADR-003-enforcement-precedence.md)
