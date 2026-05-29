# Code Review and Linting

---

## 1. Review policy

Every merge request requires **one approver** minimum; high-risk changes require **security** or **senior** reviewer.

| Risk level | Examples | Reviewers |
|------------|----------|-----------|
| Low | Docs, lint fixes | 1 engineer |
| Medium | New role, non-prod paths | 1 engineer + optional Ops |
| High | Privilege escalation, destructive tasks, prod templates | 2 engineers + Security |

---

## 2. Review checklist (GPA-aligned)

### Structure
- [ ] Fits landscape/type/function model
- [ ] Playbook thin; logic in roles
- [ ] No numbered playbooks without ADR

### Roles
- [ ] Variables prefixed; internals use `__`
- [ ] `defaults/` documents all inputs
- [ ] `argument_specs` if public API is complex
- [ ] No hardcoded inventory groups
- [ ] README with outcome and limitations

### Inventory / data
- [ ] To-Be in inventory; no prod desired state in extra vars
- [ ] As-Is/To-Be not conflated
- [ ] Structured inventory directory

### Quality
- [ ] Idempotent; check mode considered
- [ ] Named tasks; coding style
- [ ] **Pre-commit** passes (`pre-commit run --all-files`)
- [ ] `ansible-lint` clean
- [ ] Tests or Molecule evidence attached to PR

### Security
- [ ] No secrets in Git
- [ ] `no_log` on sensitive tasks
- [ ] Destructive paths gated

### Operations
- [ ] Tags documented and safe standalone
- [ ] Runbook or template description updated

---

## 3. Pre-commit and linting (mandatory)

**Pre-commit is mandatory** for all contributors. See [pre-commit.md](pre-commit.md).

| Stage | Command |
|-------|---------|
| Setup (once) | `pip install -r requirements-dev.txt && pre-commit install` |
| Every commit | Git hook (automatic) |
| Before push | `pre-commit run --all-files` |
| CI | `pre-commit run --all-files` — merge blocked on failure |

**Tools:** `ansible-lint` ([`.ansible-lint`](../.ansible-lint)), `yamllint` ([`.yamllint`](../.yamllint)), `black` / `pylint` ([`pyproject.toml`](../../pyproject.toml)), config at repo root [`.pre-commit-config.yaml`](../../.pre-commit-config.yaml).

| Policy | Detail |
|--------|--------|
| `--no-verify` | Not allowed except emergency approved by automation lead |
| Exceptions | `# noqa` with inline justification only |

Key rules: yaml line length, name templates, risky modules (`command` without changed_when).

---

## 4. Constructive review culture

Per GPA coding style rationale:

- Standards reduce review friction
- Explain **why**, not only **what**
- Link to white paper section or GPA URL in comments

---

## 5. Related documents

- [../development/coding-style.md](../development/coding-style.md)
- [../lifecycle/test-and-promote.md](../lifecycle/test-and-promote.md)
