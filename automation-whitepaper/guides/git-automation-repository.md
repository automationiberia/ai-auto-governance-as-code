# Git Repository for Automation Code

**All automation code must live in Git.** Delivery code is organized as **one Ansible collection** under `deliveries/automation/` (adjust the directory name to match your `galaxy.yml` if needed).

| Repository | Purpose |
|------------|---------|
| `<automation-home>` | Department standards (white paper, lint templates, reference examples) |
| `<automation-repo>` | **Shared delivery collection** — `deliveries/automation/` |

Never create per-initiative repos (e.g. `deliveries/linux-ntp-sync/`). Never put delivery code at the workspace root.

```text
<automation-home>/
├── automation-whitepaper/
├── deliveries/
│   └── automation/          # <-- AUTOMATION_REPO (Ansible collection)
│       ├── galaxy.yml
│       ├── roles/
│       │   └── <function>/
│       ├── playbooks/
│       └── inventory/sample/
└── skills/
```

---

## Default: shared collection (required)

**One Git repository** for the team. Each automation adds:

- `roles/<function>/` — one role per capability
- `playbooks/type_<category>.yml` — thin type playbooks
- `docs/<function>/INTAKE.md` and `DESIGN.md` — optional but recommended per capability

### First-time setup (collection does not exist yet)

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"

mkdir -p "$AUTOMATION_REPO"
cd "$AUTOMATION_REPO"
git init -b main

cp "$AUTOMATION_HOME/automation-whitepaper/templates/delivery-collection.galaxy.yml" galaxy.yml
cp "$AUTOMATION_HOME/automation-whitepaper/templates/automation-repo.gitignore" .gitignore
cp "$AUTOMATION_HOME/automation-whitepaper/templates/automation-repo.pre-commit-config.yaml" .pre-commit-config.yaml
cp "$AUTOMATION_HOME/automation-whitepaper/.ansible-lint" .
cp "$AUTOMATION_HOME/automation-whitepaper/.yamllint" .

git add galaxy.yml .gitignore .pre-commit-config.yaml .ansible-lint .yamllint
git commit -m "chore: initialize delivery collection with lint hooks"

pip install -r "$AUTOMATION_HOME/requirements-dev.txt"
pre-commit install
```

### Adding a new capability (collection already exists)

```bash
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
cd "$AUTOMATION_REPO"
git checkout main && git pull
git checkout -b feature/<ticket>-<function>-short-name
# add roles/<function>/, playbooks/, docs/, inventory updates
pre-commit run --all-files
git commit -m "feat: add <function> automation"
```

```bash
git remote add origin <url>/<group>/automation.git
git push -u origin main
```

Continue with [create-new-automation-step-by-step.md](create-new-automation-step-by-step.md).

---

## Optional: legacy per-initiative repo

Use only when migrating old repos. New work must go into the shared collection.

---

## Feature branch workflow

```bash
cd "$AUTOMATION_REPO"
git checkout -b feature/<ticket>-short-name
pre-commit run --all-files
git commit -m "feat: describe change"
git push -u origin feature/<ticket>-short-name
```

---

## Policy

- No production-bound automation outside Git and peer review
- No secrets in Git
- `pre-commit install` runs inside `<automation-repo>`
- Bump `galaxy.yml` `version` when publishing the collection to Automation Hub / private galaxy

---

## Related

- [create-new-automation-step-by-step.md](create-new-automation-step-by-step.md)
- [extending-existing-automation.md](extending-existing-automation.md)
- [quality/pre-commit.md](../quality/pre-commit.md)
