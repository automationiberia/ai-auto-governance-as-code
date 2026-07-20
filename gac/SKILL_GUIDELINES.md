# Skill authoring guidelines

Canonical metadata and body structure for **Agent Skills** — the layer that **translates** human-authored white book rules into instructions AI agents execute. Skills do not define policy; they encode it. Librarian uses this document when adding or syncing skills.

**Update order:** white paper section first → `SKILL.md` → [gac/README.md](README.md) catalog → `lola install gac` ([ADR-004](../automation-whitepaper/adrs/ADR-004-librarian-synchronization.md)).

---

## File layout

```text
gac/gac-<category>/module/skills/automation-<name>/SKILL.md   # content governance
gac/gac-aap-platform/module/skills/aap-<name>/SKILL.md      # platform administration
```

Optional siblings: `reference.md`, `examples.md`, `scripts/` (only when scripts add real value).

---

## Frontmatter template

Follows the [agentskills.io specification](https://agentskills.io/specification). Spec fields go top-level; enterprise-specific fields go inside `metadata:`.

```yaml
---
name: <skill-name>                    # lowercase-hyphen, max 64 chars, must match dir name
description: >                        # WHAT + WHEN; max 1024 chars; third person
  <Capability sentence>. Use when <trigger scenarios>.
user-invocable: true                  # true = visible in / menu; false = internal helper
triggers:                             # optional — natural-language discovery phrases
  - "<phrase>"
metadata:
  author: gac
  version: "1.0"
  # Enterprise fields (GaC-specific, not in agentskills.io spec)
  domain: content-governance | platform-administration
  skill_plane: automation | platform
  execution_modes: [mode-1-auditor, mode-2-builder, mode-3-librarian]
  platform_areas: [operate, audit, build, maintain]
  lifecycle_stages: [1, 2, 3, 4, 5, 6]
  profile_min: light | standard | heavy
  whitepaper: automation-whitepaper/<path>.md
  gpa_refs: []                        # paths under automation-good-practices/
  mcp_domains: []                     # platform only
  write_capability: "false"
  human_gate: none | confirm | cab_ticket
---
```

### Field placement

| Level | Field | Required | Notes |
|-------|-------|----------|-------|
| **Spec** | `name` | Yes | Agent discovery; must match directory name |
| **Spec** | `description` | Yes | Agent discovery; WHAT + WHEN |
| **Extended** | `user-invocable` | Yes | `true` for user-facing skills; `false` for helpers |
| **Extended** | `triggers` | No | Natural-language invocation phrases |
| **Spec** | `metadata` | Yes | Must include `author` and `version` |
| `metadata.` | `author` | Yes | `gac` for all GaC skills |
| `metadata.` | `version` | Yes | Skill version (`"1.0"`) |
| `metadata.` | `domain` | Recommended | Routes content vs platform |
| `metadata.` | `skill_plane` | Recommended | `automation` or `platform` |
| `metadata.` | `whitepaper` | Recommended | Human source of truth link |
| `metadata.` | `profile_min` | Recommended | `light` / `standard` / `heavy` |
| `metadata.` | `write_capability` | Platform | `"false"` for Audit/read Operate |
| `metadata.` | `human_gate` | Platform writes | Enterprise change control |
| `metadata.` | `execution_modes` | Content | Mode 1/2/3 |
| `metadata.` | `platform_areas` | Platform | Operate/Audit/Build/Maintain |
| `metadata.` | `mcp_domains` | Platform MCP | job-management, inventory-management, etc. |

Keep `SKILL.md` body under **~500 lines**. Move long reference material to `reference.md`.

---

## Body sections (in order)

```markdown
# <Title>

## Execution rule

State mode (content) or platform area + precedence confirmation per AGENTS.md.

## Scope

What this skill does and explicitly does **not** do.

## Enterprise constraints

White book overrides that supersede vendor/upstream defaults.

## Procedure

Numbered steps. Platform skills: MCP routing + inspect tool schema before calls.

## Output format

Tables, findings structure, verification.

## Cross-skill routing

| Intent | Route to |
|--------|----------|

## Agent behavior

Read-only default; human_gate enforcement; path variables ($AUTOMATION_HOME, $AUTOMATION_REPO).
```

---

## Examples

| Skill | Plane | Key metadata |
|-------|-------|--------------|
| [automation-auditor](gac-governance/module/skills/automation-auditor/SKILL.md) | automation | `user-invocable: true`, `metadata.domain: content-governance` |
| [aap-live-snapshot](gac-aap-platform/module/skills/aap-live-snapshot/SKILL.md) | platform | `user-invocable: true`, `metadata.platform_areas: [audit]` |

---

## Related

- [README.md](README.md) — skill catalog
- [automation-librarian/SKILL.md](gac-governance/module/skills/automation-librarian/SKILL.md)
- [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md)
