# Skill template (content and platform)

Canonical metadata and body structure for all Agent Skills in this repository. Librarian uses this when adding or syncing skills.

**Update order:** white paper section first → `SKILL.md` → catalog → tool sync ([ADR-004](../automation-whitepaper/adrs/ADR-004-librarian-synchronization.md)).

---

## File layout

```text
skills/automation-<name>/SKILL.md     # content governance
skills/platform/aap-<name>/SKILL.md # platform administration
```

Optional siblings: `reference.md`, `examples.md`, `scripts/` (only when scripts add real value).

---

## Frontmatter template

```yaml
---
name: <skill-name>                    # lowercase-hyphen, max 64 chars
description: >                        # WHAT + WHEN; max 1024 chars; third person
  <Capability sentence>. Use when <trigger scenarios>.
domain: content-governance | platform-administration
skill_plane: automation | platform
execution_modes:                      # content plane only (omit or [] for platform)
  - mode-1-auditor
  - mode-2-builder
  - mode-3-librarian
platform_areas: []                   # platform: operate | audit | build | maintain
lifecycle_stages: [1, 2, 3, 4, 5, 6]
profile_min: light | standard | heavy
whitepaper: automation-whitepaper/<path>.md
gpa_refs: []                          # paths under automation-good-practices/
mcp_domains: []                       # platform only
write_capability: false
human_gate: none | confirm | cab_ticket
triggers:                             # optional natural-language hooks
  - "<phrase>"
---
```

| Field | Required | Notes |
|-------|----------|-------|
| `name`, `description` | Yes | Agent discovery |
| `domain`, `skill_plane` | Yes | Routes content vs platform |
| `whitepaper` | Yes | Human source of truth link |
| `profile_min` | Yes | light / standard / heavy |
| `write_capability` | Platform | `false` for Audit/read Operate |
| `human_gate` | Platform writes | Enterprise change control |
| `execution_modes` | Content | Mode 1/2/3 |
| `platform_areas` | Platform | Operate/Audit/Build/Maintain |
| `mcp_domains` | Platform MCP | job-management, inventory-management, etc. |

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
| [automation-auditor](automation-auditor/SKILL.md) | automation | `domain: content-governance`, `execution_modes: [mode-1-auditor]` |
| [platform/aap-live-snapshot](platform/aap-live-snapshot/SKILL.md) | platform | `platform_areas: [audit]`, `write_capability: false` |

---

## Related

- [README.md](README.md) — skill catalog
- [automation-librarian/SKILL.md](automation-librarian/SKILL.md)
- [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md)
