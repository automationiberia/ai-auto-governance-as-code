# Copilot instructions — AI-Driven Governance-as-Code

For Ansible automation in this repository, follow [AGENTS.md](../AGENTS.md) and the relevant
`gac/module/skills/automation-*/SKILL.md` or `gac/module/skills/aap-*/SKILL.md` files.

## Before technical output

1. Declare your mode: **Auditor** (Mode 1), **Builder** (Mode 2), or **Librarian** (Mode 3).
2. Confirm precedence: Red Hat CoP GPA baseline, with white book (`automation-whitepaper/`) overrides.
3. Use paths — do not invent YAML without reading the target files.

## Paths

| Variable | Typical value in Dev Spaces |
|----------|----------------------------|
| `AUTOMATION_HOME` | Monorepo root (`ai-auto-governance-as-code`) |
| `AUTOMATION_REPO` | `deliveries/automation/` (delivery collection submodule) |

## Invoke skills explicitly

Examples:

- *Read AGENTS.md. Operate in Mode 1: The Auditor. Follow gac/module/skills/automation-auditor/SKILL.md.*
- *Read gac/module/skills/automation-builder/SKILL.md. Create a new role under deliveries/automation/roles/.*

Prompt library: [automation-whitepaper/guides/ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md).
