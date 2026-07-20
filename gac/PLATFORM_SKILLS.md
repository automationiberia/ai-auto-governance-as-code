# Platform administration skills (AAP)

Enterprise-adapted skills for **live Ansible Automation Platform** operations via MCP. They extend the same governance model as content skills: **human rules** in [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md), encoded for agents in `gac/gac-aap-platform/module/skills/aap-*`.

Upstream reference (not installed directly): `skills/vendor/aap-skills-library/` submodule.

## Phase 1 catalog

| Skill | Area | Profile min | Write |
|-------|------|-------------|-------|
| [aap-live-snapshot](gac-aap-platform/module/skills/aap-live-snapshot/SKILL.md) | Audit | light | No |
| [aap-rbac-review](gac-aap-platform/module/skills/aap-rbac-review/SKILL.md) | Audit | standard | No |
| [aap-job-status](gac-aap-platform/module/skills/aap-job-status/SKILL.md) | Operate | light | No |

Router skill: [automation-controller-ops](gac-aap-platform/module/skills/automation-controller-ops/SKILL.md)

## Upstream sync (Librarian)

```bash
git submodule update --remote skills/vendor/aap-skills-library
./gac/scripts/sync-aapsl-skills.sh --diff
```

Merge approved changes into `gac/gac-aap-platform/module/skills/aap-*` — see [ADR-007](../automation-whitepaper/adrs/ADR-007-aap-platform-skills-plane.md).
