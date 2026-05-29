# Pre-commit (Mandatory)

Pre-commit is **mandatory** for every engineer working on Ansible automation in this workspace. No pull request may be merged unless pre-commit passes locally and in CI.

---

## 1. Policy

| Rule | Detail |
|------|--------|
| **Who** | All automation developers and contributors |
| **When** | Every commit; enforced again in CI |
| **What** | Hooks in repository root [`.pre-commit-config.yaml`](../../.pre-commit-config.yaml) |
| **Exceptions** | Only with automation lead approval; document in PR (never `--no-verify` by default) |

Skipping hooks (`git commit --no-verify`) is **not allowed** except emergencies approved by the automation lead, with a follow-up fix within 24 hours.

---

## 2. One-time setup

Install Python tooling once (from `<automation-home>`). Run **pre-commit hooks in each `<automation-repo>`** where you commit automation code.

### Tooling (once per machine)

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
python3 -m venv "$AUTOMATION_HOME/.venv" && source "$AUTOMATION_HOME/.venv/bin/activate"
pip install -r "$AUTOMATION_HOME/requirements-dev.txt"
```

### Hooks in your automation project (required)

New project: follow [git-automation-repository.md](../guides/git-automation-repository.md) — copy `.pre-commit-config.yaml` into `<automation-repo>`, then:

```bash
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
cd "$AUTOMATION_REPO"
pre-commit install
pre-commit run --all-files
```

Existing monorepo (optional): `cd "$AUTOMATION_REPO" && pre-commit install` if hooks are not already configured.

---

## 3. Hooks included

| Hook | Purpose |
|------|---------|
| `trailing-whitespace` | Clean diffs |
| `end-of-file-fixer` | POSIX-friendly files |
| `check-yaml` | Valid YAML (with Ansible allowances) |
| `detect-private-key` | Block accidental key commits |
| `black` | Python formatting (`plugins/`, `module_utils/`, etc.) — [`pyproject.toml`](../../pyproject.toml) |
| `pylint` | Python static analysis (same paths) |
| `ansible-lint` | GPA-aligned Ansible rules ([`.ansible-lint`](../.ansible-lint)) |
| `yamllint` | Line length and YAML style ([`.yamllint`](../.yamllint)) |

The upstream `automation-good-practices/` reference tree is **excluded** from Ansible/yaml hooks (read-only reference). Python hooks (`black`, `pylint`) also skip that path; they **do** run on `deliveries/automation/` when plugin Python exists.

---

## 4. Daily workflow

```bash
# Before commit (automatic via git hook)
git add .
git commit -m "Add rsyslog_forward role"

# Manual run on all files (recommended before push)
pre-commit run --all-files

# Run only ansible-lint, black, or pylint
pre-commit run ansible-lint --all-files
pre-commit run black --all-files
pre-commit run pylint --all-files
```

---

## 5. CI enforcement

Pipeline must run equivalent checks:

```yaml
# Example GitLab CI / GitHub Actions step
script:
  - pip install -r requirements-dev.txt
  - pre-commit run --all-files
```

Merge requests **blocked** on failure.

---

## 6. Fixing common failures

| Failure | Fix |
|---------|-----|
| `yaml[line-length]` | Use `>-` folding; break `when:` into list |
| `name[missing]` | Add `name:` to every task |
| `no-changed-when` on `command` | Add `changed_when:` or use a module |
| `detect-private-key` | Remove key; use Vault/Controller credential |
| yamllint line-length | Same as ansible-lint line breaks |
| `black` / `pylint` on `.ansible/collections/...` | Installed collection cache — excluded via `exclude` in `.pre-commit-config.yaml` and `pyproject.toml` (not part of Git) |
| `black` would reformat `tests/...py` | Real repo file — run `black tests/` or `pre-commit run black --files <path>` and commit |

Use `# noqa: rule-id` only with inline justification.

---

## 7. Related documents

- [code-review-and-linting.md](code-review-and-linting.md)
- [../development/coding-style.md](../development/coding-style.md)
- [../guides/create-new-automation-step-by-step.md](../guides/create-new-automation-step-by-step.md)
