# OpenShift Dev Spaces / Dev Spaces

Run this repository as a **Dev Spaces workspace** with Ansible tooling, submodules, and pre-commit preconfigured.

---

## Files

| File | Purpose |
|------|---------|
| [`.devfile.yaml`](../../.devfile.yaml) | Container image, env vars, postStart setup |
| [`.devfile/setup-workspace.sh`](../../.devfile/setup-workspace.sh) | Submodules, `pip install`, pre-commit |
| [`automation-home.code-workspace`](../../automation-home.code-workspace) | Multi-root IDE (monorepo + delivery collection) |

---

## Launch

1. Open your organisation **Dev Spaces** dashboard.
2. **Create Workspace** → import this Git repository URL.
3. Ensure **Recreate existing workspace** is used after `.devfile.yaml` changes.
4. Wait for **postStart** (`setup-workspace`) to finish (see terminal output).

Environment variables (set automatically):

```bash
AUTOMATION_HOME=${PROJECT_SOURCE}          # monorepo root
AUTOMATION_REPO=${PROJECT_SOURCE}/deliveries/automation
```

---

## Git submodules and credentials

The workspace runs `git submodule update --init --recursive` on start.

| Submodule | Remote |
|-----------|--------|
| `automation-good-practices` | public redhat-cop |
| `deliveries/automation` | `git@github.com:automationiberia/ai-auto-deliveries.git` |

For the **private** delivery repo, configure Git credentials in Dev Spaces (**User Preferences → Git / SSH keys** or Personal Access Token) before the workspace starts, or run **Setup workspace** again from the command palette after adding credentials.

---

## Devfile commands (Command Palette)

| Command | Action |
|---------|--------|
| **Setup workspace** | Re-run submodule init + pip + pre-commit |
| **Pre-commit (automation-home)** | Lint white paper / skills at repo root |
| **Pre-commit (delivery collection)** | Lint `deliveries/automation/` |
| **Syntax-check delivery playbooks** | `ansible-playbook --syntax-check` on type playbooks |

---

## Base image

`ghcr.io/ansible/ansible-devspaces:latest` — Ansible VS Code extension, `ansible-core`, `ansible-lint`, and related ADT tools ([ansible-devspaces](https://github.com/redhat-cop/ansible-devspaces)).

---

## Related

- [git-automation-repository.md](git-automation-repository.md)
- [pre-commit.md](../quality/pre-commit.md)
- [README.md](../../README.md)
