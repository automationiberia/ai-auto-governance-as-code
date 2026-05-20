# Landscape, Type, Function, and Component

This hierarchy is the department's primary structural model, aligned with [GPA — Structures](https://redhat-cop.github.io/automation-good-practices/).

---

## 1. Definitions

| Level | Definition | Artifact |
|-------|------------|----------|
| **Landscape** | Everything deployed together as one logical unit | Controller **workflow**, or playbook importing type playbooks |
| **Type** | Host category with **exactly one** type per host; one playbook deploys the full type | Type playbook (e.g. `middleware_server.yml`) |
| **Function** | Reusable capability used by one or more types | **Role** (e.g. `base_linux`, `postgresql`) |
| **Component** | Maintainability split inside a function | `tasks/<component>.yml` or child role |

**Functions** optimize **re-use**. **Components** optimize **readability**.

---

## 2. Example: three-tier application

| Level | This example |
|-------|--------------|
| Landscape | Web + middleware + database production stack |
| Types | `web_frontend`, `middleware`, `database` |
| Functions | `vm_provision`, `base_linux`, `apache`, `jboss`, `postgresql` |
| Components (in `base_linux`) | `dns.yml`, `ntp.yml`, `ssh.yml` |

Workflow runs three type playbooks (or one playbook-of-playbooks with `import_playbook`).

For a worked layout see [../examples/example-three-tier-landscape.md](../examples/example-three-tier-landscape.md).

---

## 3. Rules and exceptions

### 3.1 Rules

1. One type per host; one playbook per type.
2. Do not chain numbered playbooks (`01_setup.yml`, `02_app.yml`)—use workflow or imports.
3. Prefer re-combining existing function roles over duplicating tasks.

### 3.2 Valid exceptions (document in ADR)

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

- Playbooks are not for programming—push logic to roles/modules
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

---

## 6. Related documents

- [collections-and-execution-environments.md](collections-and-execution-environments.md)
- [../development/playbooks.md](../development/playbooks.md)
- [../development/roles.md](../development/roles.md)
