# Platform administration skills (AAP)

Enterprise-adapted skills for **live Ansible Automation Platform** operations via MCP. Upstream reference: `skills/vendor/aap-skills-library/` (submodule).

**White book:** [aap-platform-administration.md](../../automation-whitepaper/operations/aap-platform-administration.md)

---

## Adoption phases

| Phase | Skills | Status |
|-------|--------|--------|
| **1 — Read-only** | `aap-live-snapshot`, `aap-rbac-review`, `aap-job-status` | Included |
| **2 — Controlled write** | `aap-job-template-create`, `aap-template-bundle-update`, `aap-object-rename` | Planned |
| **3 — Restricted** | `aap-job-executor`, `aap-inventory-create`, `aap-object-move-org` | Planned |

---

## Phase 1 catalog

| Skill | Area | Profile min | Write |
|-------|------|-------------|-------|
| [aap-live-snapshot](aap-live-snapshot/SKILL.md) | Audit | light | No |
| [aap-rbac-review](aap-rbac-review/SKILL.md) | Audit | standard | No |
| [aap-job-status](aap-job-status/SKILL.md) | Operate | light | No |

---

## Invocation

**Content + platform (example):**

```text
Platform area: Audit (read-only).
I have evaluated Red Hat CoP baseline rules against white book overrides.
Use skill aap-live-snapshot for organization "Lab".
```

**Router:** [automation-controller-ops](../automation-controller-ops/SKILL.md) maps user intent to platform skills.

---

## Upstream sync

```bash
git submodule update --remote skills/vendor/aap-skills-library
./skills/scripts/sync-aapsl-skills.sh --diff
```

Librarian merges approved diffs into `skills/platform/` — see [ADR-007](../../automation-whitepaper/adrs/ADR-007-aap-platform-skills-plane.md).

---

## Related

- [SKILL-TEMPLATE.md](../SKILL-TEMPLATE.md)
- [TOOL-SETUP.md](../TOOL-SETUP.md#mcp-aap-platform-skills)
- [skills/README.md](../README.md)
