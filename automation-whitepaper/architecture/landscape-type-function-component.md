# Landscape, Type, Function, and Component

The **L/T/F/C inventory matrix** classifies every automation asset. No role or playbook may be generated or validated without identifying its place in this hierarchy. Aligned with enterprise white book mandates; GPA structures inform implementation patterns.

---

## 1. Inventory matrix definitions

| Level | Definition | Examples |
|-------|------------|----------|
| **Landscape (L)** | Targeted environment tier | `production`, `development`, `sandbox` |
| **Type (T)** | Underlying infrastructure platform | `rhel`, `windows`, `cisco`, `vmware` |
| **Function (F)** | Broader business service being automated | `webserver`, `database`, `security_patching` |
| **Component (C)** | Specific technical unit or application daemon | `nginx`, `postgresql`, `rsyslog` |

**Example mapping:** Landscape `production` · Type `rhel` · Function `webserver` · Component `nginx`.

Every new capability documents its L/T/F/C placement in `docs/rolename/DESIGN.md` or the design note.

---

## 2. Mapping to Ansible artifacts

The matrix drives **classification and inventory hygiene**. Implementation still follows collection layout and GPA-inspired structure:

| Matrix level | Typical artifact | Notes |
|--------------|------------------|-------|
| Landscape | Controller workflow, environment-specific inventory groups | One logical deployment unit per landscape |
| Type | Type playbook (e.g. `playbooks/type_webserver.yml`) | One type per host; thin playbook importing function roles |
| Function | Function role (e.g. `roles/webserver/`) | Reusable capability; one role per function in `$AUTOMATION_REPO` |
| Component | `tasks/<component>.yml` or focused task file inside the function role | Maintainability split (e.g. `nginx.yml`, `tls.yml`) |

**Functions** optimize **re-use**. **Components** optimize **readability**.

For a worked three-tier example see [../examples/example-three-tier-landscape.md](../examples/example-three-tier-landscape.md).

---

## 3. Rules and exceptions

### 3.1 Rules

1. Document L/T/F/C before implementation (Design stage).
2. One type per host; one type playbook per host category.
3. Do not chain numbered playbooks (`01_setup.yml`, `02_app.yml`) — use workflow or imports.
4. Prefer re-combining existing function roles over duplicating tasks.

### 3.2 Valid exceptions (optional ADR)

Record approved exceptions in [`adrs/`](../adrs/README.md) (optional ADR). Normative L/T/F/C rules remain in this guide. Example: [ADR-006](../adrs/ADR-006-ltfc-mandatory.md).

| Situation | Possible exception |
|-----------|-------------------|
| "Hardened OS" vs "standard OS" | Two functions **or** one function + parameter |
| SSH as function vs component of base OS | Team choice; be consistent |
| External Galaxy collection | May not follow naming; wrap in thin local role |
| Integrated test type | New type combining existing functions in one playbook |

**Breaking rules without team discussion hurts reuse and onboarding.**

---

## 4. Zen of Ansible (design guidepost)

When structure is unclear, apply:

- Playbooks are not for programming — push logic to roles/modules
- Clear, concise, readable
- If implementation is hard to explain, simplify
- Convention over configuration for consumers

---

## 5. Anti-patterns

| Anti-pattern | Problem |
|--------------|---------|
| Monolithic 2000-line playbook | No reuse; untestable |
| Duplicate type playbooks differing by one role | Use variables and groups |
| Multiple types on same host without clear primary | Violates one-type rule |
| Landscape logic in role defaults | Blurs layers |
| Asset without L/T/F/C classification | Blocks governance validation |

---

## 6. Related documents

- [collections-and-execution-environments.md](collections-and-execution-environments.md)
- [monorepo-layout.md](monorepo-layout.md)
- [../development/roles.md](../development/roles.md)
