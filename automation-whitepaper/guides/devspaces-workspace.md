# OpenShift Dev Spaces / Dev Spaces

Run this repository as a **Dev Spaces workspace** with Ansible tooling, submodules, and pre-commit preconfigured.

---

## Files

| File | Purpose |
|------|---------|
| [`.devfile.yaml`](../../.devfile.yaml) | Container image, env vars, postStart setup |
| [`.devfile/setup-workspace.sh`](../../.devfile/setup-workspace.sh) | Submodules, `pip install`, pre-commit |
| [`automation-home.code-workspace`](../../automation-home.code-workspace) | VS Code workspace (monorepo root; submodules nested under `deliveries/automation/`, etc.) |

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

## GitHub Copilot and AI chat

Repo governance for Copilot is already in [`.github/copilot-instructions.md`](../../.github/copilot-instructions.md) — Copilot loads it automatically once you are signed in. **No extra repo configuration is required.**

What you must configure is **GitHub authentication inside Dev Spaces**. The browser IDE does **not** use the same OAuth popup as desktop VS Code.

### Prerequisites

| Requirement | Notes |
|-------------|--------|
| **Copilot seat** | GitHub Copilot Individual, Business, or Enterprise on your GitHub account |
| **GitHub.com account** | Use **Continue with GitHub** (not GHE.com) unless your org uses GitHub Enterprise exclusively |
| **Network egress** | Workspace pod must reach `github.com` for device activation |

### Correct sign-in flow (Dev Spaces / Eclipse Che)

Do **not** start with the **Sign in to use AI Features → Continue with GitHub** dialog if it fails — that path often errors in the browser IDE. Use **device authentication** instead:

1. **Sign out** if you already tried and failed:
   - Activity bar → **Accounts** (person icon) → your GitHub account → **Sign Out**.
2. Open Command Palette (`F1` / `Ctrl+Shift+P`) → run **`GitHub: Device Authentication`**.
3. Copy the **device code** from the notification and open the GitHub activation link in your browser (outside Dev Spaces).
4. Paste the code, authorize, and confirm.
5. When prompted, **refresh the Dev Spaces browser tab** (F5). Authentication applies only after refresh.
6. Open **Chat** (right panel) and send a test prompt.

Official reference: [Eclipse Che — GitHub Copilot Chat](https://eclipse.dev/che/docs/stable/end-user-guide/using-github-copilot-chat/).

### If sign-in still fails

| Symptom | Try |
|---------|-----|
| **Failed to sign in to GitHub** after popup | Sign out → `GitHub: Device Authentication` → refresh tab (do not retry popup) |
| **`redhat.devspaces-copilot-chat-integration` not found** | Cluster Open VSX lacks the extension — see below |
| **Getting chat ready…** (stuck) | Same — Chat waits for the integration extension |
| **User not authorized** / 401 in Output | Confirm Copilot seat on GitHub; ask org admin to assign Copilot Business |
| **GHE.com** prompt when you use github.com | Remove `"github.copilot.advanced": { "authProvider": "github-enterprise" }` from user settings |
| Cluster blocks Copilot | Ask platform team about **Continue + private LLM** ([Red Hat guide](https://developers.redhat.com/learning/learn:openshift-ai:integrate-private-ai-coding-assistant-your-cde-using-ollama-continue-openshift-dev-spaces/resource/resources:access-openshift-dev-spaces-and-create-your-cde)) |

Check logs: Command Palette → **Output** → select **GitHub Copilot** or **GitHub Copilot Chat** from the dropdown.

### Extension not found: `redhat.devspaces-copilot-chat-integration`

Dev Spaces does **not** install marketplace `GitHub.copilot-chat` automatically. Che-Code uses a bridge extension:

| Item | Value |
|------|--------|
| Extension ID | `redhat.devspaces-copilot-chat-integration` |
| Upstream | [redhat-developer/devspaces-copilot-chat-integration](https://github.com/redhat-developer/devspaces-copilot-chat-integration) (experimental) |
| Registry | Must exist in the cluster **Open VSX** registry |

Error *"cannot be installed because it was not found"* means a **platform configuration gap**, not a problem with this repository.

**Option A — platform team (recommended):** register the extension in the cluster Open VSX registry (version must match the Che editor — docs often cite **0.36.2**), or point Dev Spaces at public Open VSX.

**Option B — manual install (if VSIX download is allowed):**

1. Command Palette → **Help: About** — note the editor version.
2. Download the matching `.vsix` from [Open VSX](https://open-vsx.org/extension/redhat/devspaces-copilot-chat-integration).
3. Command Palette → **Extensions: Install from VSIX…**
4. Reload window → **`GitHub: Device Authentication`** → refresh browser tab.

**Option C — no Copilot on cluster:** use **Continue** + private LLM, or **Cursor locally** with `link-cursor-skills.sh`.

### Using governance once Copilot works

Open `automation-home.code-workspace`, then in Chat:

```text
@AGENTS.md Operate in Mode 1: The Auditor.
Follow skills/automation-auditor/SKILL.md. Audit deliveries/automation/roles/<rolename>/.
```

Prompt library: [ai-prompt-examples.md](ai-prompt-examples.md). Full tool matrix: [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md).

### Without Copilot (generic agent)

If your cluster does not provide Copilot seats, use the same prompts in Chat or any agent with file access — point at `AGENTS.md` and `skills/*/SKILL.md` explicitly. See [TOOL-SETUP.md § Generic](../../skills/TOOL-SETUP.md).

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
- [skills/TOOL-SETUP.md](../../skills/TOOL-SETUP.md)
- [README.md](../../README.md)
