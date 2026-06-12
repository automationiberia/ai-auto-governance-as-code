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
4. Wait for **postStart** (`setup-workspace`) to finish.

Environment variables (set automatically):

```bash
AUTOMATION_HOME=${PROJECT_SOURCE}          # monorepo root
AUTOMATION_REPO=${PROJECT_SOURCE}/deliveries/automation
```

---

## View logs when startup fails

On the **Starting workspace** screen (your screenshot), use the tabs at the top:

| Tab | What you see |
|-----|----------------|
| **Progress** | High-level steps and the short error summary |
| **Logs** | **Start here** — container and operator output (scroll to the bottom for the last lines) |
| **Events** | Kubernetes events (`FailedPostStartHook`, etc.) |

The **Progress** tab alone does not show the full `postStart` script output.

### Log file in the repository

`setup-workspace` writes everything to:

```text
.devfile/setup-workspace.log
```

After the pod exists (even if the IDE did not open), open that file in the project tree or run:

```bash
cat .devfile/setup-workspace.log
```

### If the workspace never opens

1. **Restart with default devfile** — only to confirm it is a custom `postStart` issue; you lose this repo’s devfile until you import it again.
2. **Debug mode** (cluster admin or advanced): add to the DevWorkspace before create:

   ```yaml
   metadata:
     annotations:
       controller.devfile.io/debug-start: "true"
   ```

   The pod stays up after a failed hook; then check `/tmp/poststart-stdout.txt` and `/tmp/poststart-stderr.txt` inside the container (`oc exec`).

3. **OpenShift CLI** (if you have access):

   ```bash
   oc get pods -n <your-devspaces-namespace>
   oc logs <workspace-pod> -c automation-tools
   oc describe pod <workspace-pod>
   ```

### Typical `postStart` failure

`git submodule update` on the private delivery repo without SSH/PAT in **User Preferences → Git**. Configure credentials, then in a terminal:

```bash
bash .devfile/setup-workspace.sh
```

**AI shortcut (postStart failure):**

```text
I am operating in Mode 1: The Auditor.

Read .devfile/setup-workspace.log and diagnose Dev Spaces postStart failure.
Typical cause: submodule SSH credentials for deliveries/automation.
Suggest fix only — do not edit .devfile.yaml until I approve.
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

### Dual stack (AAP + Puppet strategy)

Per [strategic-proposal-aap-governance-evolution.md](../governance/strategic-proposal-aap-governance-evolution.md), workspaces should support **both**:

| Stack | Purpose in workspace |
|-------|----------------------|
| **Ansible** | ansible-navigator, execution environments, ansible-lint, native collection development |
| **Puppet** | Ruby runtime, Puppet CLI, manifest validation — inspect legacy code **before** Phase 2 refactor |

The default devfile image is Ansible-first. Extend the devfile or use a custom image when Puppet CLI is required on-cluster; document the choice in your platform team runbook. Goal: **identical runtime** for humans and AI agents (zero-configuration onboarding).

**Roadmap:** This layout prepares integration with **Red Hat Developer Hub** as the developer portal.

---

## Related

- [strategic-proposal-aap-governance-evolution.md](../governance/strategic-proposal-aap-governance-evolution.md)
- [aap-puppet-coexistence-evolution.md](../architecture/aap-puppet-coexistence-evolution.md)
- [git-automation-repository.md](git-automation-repository.md)
- [pre-commit.md](../quality/pre-commit.md)
- [README.md](../../README.md)
