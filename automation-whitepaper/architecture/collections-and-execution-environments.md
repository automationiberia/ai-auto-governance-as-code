# Collections and Execution Environments

## 1. Why collections

Per GPA:

- Package roles at **type** or **landscape** level when distributing together
- Namespace prevents variable and module name collisions
- Share plugins across roles without duplicating `library/` per role
- Required for consistent **execution environments** (EE) on Ansible Automation Platform

---

## 2. Collection-level variables (implicit)

Pattern for shared settings across roles in collection `mycollection`:

**`roles/alpha/defaults/main.yml`:**

```yaml
alpha_job_name: "some text"
alpha_controller_username: "{{ mycollection_controller_username }}"
alpha_no_log: "{{ mycollection_no_log | default(true) }}"
```

**`roles/beta/defaults/main.yml`:**

```yaml
beta_job_name: "other text"
beta_controller_username: "{{ mycollection_controller_username }}"
beta_no_log: "{{ mycollection_no_log | default(false) }}"
```

- Document implicit collection variables (`mycollection_*`) in collection README
- Each role still prefixes its own variables per [../development/roles.md](../development/roles.md)

---

## 3. Collection hygiene

| Item | Requirement |
|------|-------------|
| README | Purpose, license link, ansible-core versions, SDK deps |
| LICENSE | `LICENSE` or `COPYING` in root |
| Versioning | Semantic versioning for Git tags (`X.Y.Z`) |
| Plugin docs | Generate where possible (`collection_prep`) |

---

## 4. Execution environments

| Practice | Detail |
|----------|--------|
| Pin collections | `requirements.yml` in EE build |
| Build in CI | `ansible-builder` on tag |
| Promote EE with code | Same change record as collection bump |
| Test EE before prod | Run smoke playbook in pre-prod Controller |

---

## 5. Semantic versioning

- Use `0.y.z` until role/collection interface is stable
- Breaking variable renames → major version bump
- Communicate upgrades to Operations and Application teams consuming variables

---

## 6. Related documents

- [../lifecycle/test-and-promote.md](../lifecycle/test-and-promote.md)
- [../operations/controller-and-workflows.md](../operations/controller-and-workflows.md)
