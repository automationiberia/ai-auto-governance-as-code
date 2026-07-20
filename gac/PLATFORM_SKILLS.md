# Platform administration skills (AAP)

Enterprise-adapted skills for **live Ansible Automation Platform** operations via MCP. Upstream: `skills/vendor/aap-skills-library/` (submodule).

**White book:** [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md)

## Phase 1 catalog

| Skill | Area | Profile min | Write |
|-------|------|-------------|-------|
| [aap-live-snapshot](module/skills/aap-live-snapshot/SKILL.md) | Audit | light | No |
| [aap-rbac-review](module/skills/aap-rbac-review/SKILL.md) | Audit | standard | No |
| [aap-job-status](module/skills/aap-job-status/SKILL.md) | Operate | light | No |

## Upstream sync

```bash
git submodule update --remote skills/vendor/aap-skills-library
./gac/scripts/sync-aapsl-skills.sh --diff
```

Librarian merges approved diffs into `gac/module/skills/aap-*` — see [ADR-007](../automation-whitepaper/adrs/ADR-007-aap-platform-skills-plane.md).
