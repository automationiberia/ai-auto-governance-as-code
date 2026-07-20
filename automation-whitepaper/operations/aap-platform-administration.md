# AAP Platform Administration

Governance for **live Ansible Automation Platform (AAP)** operations via Agent Skills and MCP — complementary to Git-side Ansible content governance.

**Related:** [controller-and-workflows.md](controller-and-workflows.md) · [inventory-ssot-integration.md](inventory-ssot-integration.md) · [operate-and-improve.md](../lifecycle/operate-and-improve.md) · [ADR-007](../adrs/ADR-007-aap-platform-skills-plane.md)

---

## Two skill planes

| Plane | Path prefix | Domain | System of record |
|-------|-------------|--------|------------------|
| **Content governance** | `gac/module/skills/automation-*` | Roles, playbooks, collections in Git | `$AUTOMATION_REPO` |
| **Platform administration** | `gac/module/skills/aap-*` | Controller objects, jobs, RBAC via MCP | Live AAP |

Both planes share the same monorepo, white book precedence, and human Architect approval gates. Platform skills **do not** replace content skills or GPA rules for YAML authoring.

```text
Content (Mode 2 Builder)  →  Git artifacts (role + type playbook)
        ↓ promotion
Platform (Build area)     →  Job template wired to Git project (MCP)
        ↓
Platform (Operate area)   →  Launch, monitor jobs (MCP)
```

---

## MCP prerequisites

Platform skills require **AAP MCP servers** registered in the AI client. See [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md#mcp-aap-platform-skills).

| Layer | Role |
|-------|------|
| **Skills** (`gac/module/skills/aap-*`) | What to do; enterprise constraints |
| **MCP** | Protocol boundary to AAP APIs |
| **AAP** | System of record for platform objects |

Without MCP, engineers follow this white book and the Controller UI manually — platform skills are optional accelerators.

---

## Platform areas (not content modes)

AAP platform skills use four **areas** — distinct from Mode 1/2/3 content modes:

| Area | Purpose | Write capability |
|------|---------|------------------|
| **Audit** | Snapshots, RBAC review | Read-only |
| **Operate** | Job launch, status | Mixed (launch = write) |
| **Build** | Create inventories, job templates | Write |
| **Maintain** | Rename, re-associate, move org | Write |

When using platform skills, declare **both** the content mode (if reviewing Git) and the platform area:

> Platform area: **Audit** (read-only). I have evaluated Red Hat CoP baseline rules against white book overrides.

---

## Enterprise Red Lines

These override upstream [AAP Skills Library](https://github.com/automationiberia/aap-skills-library) defaults.

### SSOT inventory

Production hosts and groups **must** flow from CMDB, cloud, or Satellite dynamic inventory — not chat-driven manual curation. See [inventory-ssot-integration.md](inventory-ssot-integration.md).

| Organization class | `aap-inventory-create` |
|--------------------|------------------------|
| Lab / dev (non-prod) | Allowed with confirmation |
| Pre-prod / prod | **Blocked** — use Git + dynamic inventory plugins |

### Job template standards

When creating or updating job templates (platform Build/Maintain), enforce [controller-and-workflows.md](controller-and-workflows.md) §3:

| Field | Rule |
|-------|------|
| Name | `landscape_type_environment` pattern |
| Extra variables | Safety/debug only — **no desired state** |
| Description | Link to runbook, change category, owner |
| Playbook | Must exist in the Git project under `$AUTOMATION_REPO` |

### Change control

| Profile | Platform write operations |
|---------|---------------------------|
| **Light** | Lab org only; no CAB |
| **Standard** | Pre-prod: team lead confirmation; prod: ITSM ticket reference |
| **Heavy** | CAB approval before prod org writes |

Recommend `aap-live-snapshot` (or targeted read) **before** production template or RBAC changes.

### Security

- Platform Audit skills are read-only — never modify RBAC during audit.
- Do not expose credentials, tokens, or secrets from job extra vars in chat output.
- Align RBAC reviews with Information Security access review cadence.

---

## Upstream sync (Librarian)

Reference upstream skills live in `skills/vendor/aap-skills-library/` (git submodule). Enterprise-adapted skills live in `gac/module/skills/aap-*/`.

**Do not** symlink vendor skills directly into AI clients. Librarian merges upstream changes into `gac/module/skills/` per [ADR-007](../adrs/ADR-007-aap-platform-skills-plane.md).

```bash
git submodule update --remote skills/vendor/aap-skills-library
./gac/scripts/sync-aapsl-skills.sh --diff   # review only
./gac/scripts/sync-aapsl-skills.sh          # after Librarian approval
```

---

## Phase 1 skills (read-only)

| Skill | Area | Profile min |
|-------|------|-------------|
| [aap-live-snapshot](../../gac/module/skills/aap-live-snapshot/SKILL.md) | Audit | light |
| [aap-rbac-review](../../gac/module/skills/aap-rbac-review/SKILL.md) | Audit | standard |
| [aap-job-status](../../gac/module/skills/aap-job-status/SKILL.md) | Operate | light |

Write skills (`aap-job-executor`, `aap-inventory-create`, `aap-job-template-create`, maintain skills) follow in later adoption phases.

---

## Related documents

- [gac/module/gac/README.md](../../gac/module/gac/README.md) — platform skill catalog
- [gac/SKILL_GUIDELINES.md](../../gac/SKILL_GUIDELINES.md) — unified skill metadata
- [automation-controller-ops](../../gac/module/skills/automation-controller-ops/SKILL.md) — router to platform skills
- [governance-as-code-ai-enforcement.md](../governance/governance-as-code-ai-enforcement.md)
