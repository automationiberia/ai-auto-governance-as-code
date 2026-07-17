# ai-forge and GaC — quick reference

Full architecture: **[GaC Architecture: ai-forge Integration](../architecture/ai-forge-gac-integration.md)**

---

## At a glance

| From ai-forge (Lola) | From GaC (local) |
|----------------------|------------------|
| `/commit`, `/create-pr`, `/release`, `/changelog-fragment` | `automation-good-practices/` submodule (pinned CoP) |
| Optional: `/ansible-zen` | `automation-whitepaper/`, `AGENTS.md`, `skills/` |

GaC consumes ai-forge for **SDLC only**. CoP compliance stays **version-controlled** in the submodule — not via ai-forge's dynamic CoP fetch.

---

## Install

| Audience | Command |
|----------|---------|
| Contributors | `make install` after clone |
| AI assistant users | `lola install gac -a <assistant>` |

See [README.md](../../README.md) and the [full architecture doc](../architecture/ai-forge-gac-integration.md).

---

## Related

- [philosophy.md](philosophy.md)
- [cop-overrides.md](cop-overrides.md)
- [ADR-003](../adrs/ADR-003-enforcement-precedence.md)
