# OpenShift Dev Spaces / Dev Spaces

Run this repository as a **Dev Spaces workspace** with Ansible tooling, submodules, and pre-commit preconfigured.

---

## Files

| File | Purpose |
|------|---------|
| [`.devfile.yaml`](../../.devfile.yaml) | Container image, env vars, Copilot VSIX path, postStart setup |
| [`.devfile/setup-workspace.sh`](../../.devfile/setup-workspace.sh) | Submodules, Copilot VSIX, Continue config, `pip install`, pre-commit |
| [`.devfile/ollama-pull.sh`](../../.devfile/ollama-pull.sh) | Pull `qwen2.5-coder:7b` into the Ollama sidecar (postStart) |
| [`.continue/config.yaml`](../../.continue/config.yaml) | Continue → local Ollama (`http://127.0.0.1:11434`) |
| [`.devfile/continue.yaml`](../../.devfile/continue.yaml) | Legacy UDI-only stack (`?devfilePath=.devfile/continue.yaml`) |
| [`.vscode/extensions.json`](../../.vscode/extensions.json) | Auto-install `redhat.devspaces-copilot-chat-integration` at workspace start |
| [`automation-home.code-workspace`](../../automation-home.code-workspace) | VS Code workspace (Agent mode enabled; Ansible + Copilot extensions) |

---

## Launch

1. Open your organisation **Dev Spaces** dashboard.
2. **Create Workspace** → import this Git repository URL.
3. Confirm the workspace uses **`.devfile.yaml`** (name **Automation Home**). Do **not** keep a second `devfile.yaml` at the repo root — Dev Spaces may pick the wrong file and fail with `init-persistent-home` CrashLoopBackOff.
4. Ensure **Recreate existing workspace** is used after `.devfile.yaml` changes.
5. Wait for **postStart** to finish (runs in background — IDE may open before setup completes). Track progress:

   ```bash
   tail -f .devfile/setup-workspace.log
   tail -f .devfile/ollama-pull.log
   ```

   When setup finishes, open a **new terminal** so `.venv/bin` is on PATH.

Environment variables (set automatically):

```bash
AUTOMATION_HOME=${PROJECT_SOURCE}          # monorepo root
AUTOMATION_REPO=${PROJECT_SOURCE}/deliveries/automation
PATH=${PROJECT_SOURCE}/.venv/bin:...       # pre-commit, ansible-lint, black, etc.
```

### Dev tools (pre-commit, ansible-lint, …)

`setup-workspace` creates a project **virtualenv** at `.venv/` and installs [requirements-dev.txt](../../requirements-dev.txt). This avoids `pip install --user` (packages in `~/.local/bin` were **not** on PATH for Copilot Agent or devfile commands).

| Tool | Path after setup |
|------|------------------|
| `pre-commit` | `${AUTOMATION_HOME}/.venv/bin/pre-commit` |
| `ansible-lint` | `${AUTOMATION_HOME}/.venv/bin/ansible-lint` |
| `ansible-playbook` | `/usr/bin/ansible-playbook` (image) + venv `ansible-core` |

The workspace file sets `python.defaultInterpreterPath` and `terminal.integrated.env.linux.PATH` to `.venv/bin`.

If an agent or terminal reports `pre-commit: command not found`:

1. Command Palette → **Setup workspace** (or `bash .devfile/setup-workspace.sh`)
2. Open a **new** terminal (reload PATH)
3. Verify: `which pre-commit` → `.../.venv/bin/pre-commit`

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

**`[postStart hook] failed`** on `automation-tools` usually means the setup script exited non-zero or timed out. This repo runs setup **asynchronously** (`nohup`) so the hook returns immediately; recreate the workspace after pulling the latest `.devfile.yaml`.

If failure persists, check `.devfile/setup-workspace.log` (or pod logs). Common causes:

| Cause | Fix |
|-------|-----|
| Script exited before `exit 0` (older revisions) | Pull latest; setup uses `HOME` default and no `set -u` |
| Hook timeout (submodules + pip + VSIX download) | Async postStart — wait for log; run **Setup workspace** manually |
| `git submodule update` | Configure Git/SSH in User Preferences |

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
| **Pull Ollama model (qwen2.5-coder:7b)** | Re-download / verify local LLM in sidecar |
| **Pre-commit (automation-home)** | Lint white paper / skills at repo root |
| **Pre-commit (delivery collection)** | Lint `deliveries/automation/` |
| **Syntax-check delivery playbooks** | `ansible-playbook --syntax-check` on type playbooks |

---

## GitHub Copilot Agent — setup and authentication

Repo governance for Copilot is in [`.github/copilot-instructions.md`](../../.github/copilot-instructions.md). **This repository pre-configures the Dev Spaces Copilot bridge extension and Agent mode.** GitHub sign-in is **manual** — once per cluster user — and cannot be automated from the devfile.

### What the repo configures automatically

| Mechanism | Purpose |
|-----------|---------|
| [`.vscode/extensions.json`](../../.vscode/extensions.json) | Installs `redhat.devspaces-copilot-chat-integration` from Open VSX when the cluster registry has it |
| `.devfile.yaml` → `DEFAULT_EXTENSIONS` | Pre-installs the same extension from a VSIX downloaded to `.devfile/extensions/` (fallback when embedded Open VSX lacks the extension) |
| `.devfile/setup-workspace.sh` | Downloads VSIX **0.36.2** from [Open VSX](https://open-vsx.org/extension/redhat/devspaces-copilot-chat-integration) on postStart |
| `.devfile.yaml` → `VSCODE_TRUSTED_EXTENSIONS` | Allows the bridge extension to access GitHub OAuth tokens |
| `automation-home.code-workspace` | Enables Copilot **Agent** mode (`chat.agent.enabled`) |

After changing `.devfile.yaml`, **Recreate existing workspace** (not just restart) so env vars apply.

If Chat still shows *Getting chat ready…* on the **first** start, run **Dev Spaces: Restart Workspace** once — the VSIX download may finish after the editor first checked `DEFAULT_EXTENSIONS`.

### Prerequisites

| Requirement | How to verify |
|-------------|---------------|
| **Copilot seat** | [github.com/settings/copilot](https://github.com/settings/copilot) — Individual, Business, or Enterprise active on your account |
| **GitHub.com account** | Use github.com (not GHE.com) unless your org uses GitHub Enterprise exclusively |
| **Network egress** | From a workspace terminal: `curl -sI https://api.githubcopilot.com \| head -1` returns `HTTP/2 200` or similar |
| **Correct devfile** | Workspace name is **Automation Home** (not `vscode-continue-ai-env`) |
| **Extension installed** | Extensions view (`Ctrl+Shift+X`) shows **Dev Spaces Copilot Chat Integration** 0.36.2 enabled |

### Git credentials ≠ Copilot authentication

| Purpose | Where it is configured | Used for |
|---------|------------------------|----------|
| **Git clone / submodules** | Dev Spaces **User Preferences → Git / SSH keys** | `git submodule update`, private `deliveries/automation` |
| **Copilot Chat / Agent** | **`GitHub: Device Authentication`** inside the IDE | AI chat, code suggestions, Agent mode |

Being able to clone the repo does **not** mean Copilot is authenticated. Configure both independently.

---

### First-time setup (step-by-step)

Complete these steps **in order** after the workspace opens and `setup-workspace` finishes.

**Do not open Chat or send a message until step 5 is done.** Opening Chat before authentication causes `GitHubLoginFailed` and *Chat took too long to get ready*.

| Step | Action |
|------|--------|
| **1** | Confirm extension: `Ctrl+Shift+X` → search **Dev Spaces Copilot Chat Integration** → status **Enabled** (version 0.36.2). If missing, see [Extension not found](#extension-not-found-redhatdevspaces-copilot-chat-integration) below. |
| **2** | If you previously tried and failed: Activity bar → **Accounts** (person icon) → GitHub → **Sign Out** → confirm. |
| **3** | Command Palette (`F1` / `Ctrl+Shift+P`) → **`GitHub: Device Authentication`**. **Do not** use the popup *Sign in to use AI Features → Continue with GitHub* — that OAuth path often fails in the browser IDE. |
| **4** | A notification shows a **device code** and link. Open the link in a **normal browser tab** (outside Dev Spaces), paste the code, authorize the application, and confirm on GitHub. |
| **5** | **Refresh the Dev Spaces browser tab** (`F5`). The token is applied only after refresh. Optional but recommended: Command Palette → **`Developer: Reload Window`**. |
| **6** | Open **Chat** (right panel). In the mode dropdown, select **Agent** (not only Ask/Edit). |
| **7** | Send a test prompt, for example: `@AGENTS.md List the available automation skills.` |

Device Authentication is **one-time per cluster user** — credentials are stored as a Secret on the cluster and persist across workspaces.

Official reference: [Eclipse Che — GitHub Copilot Chat](https://eclipse.dev/che/docs/stable/end-user-guide/using-github-copilot-chat/).

---

### Verify Copilot is working

| Check | Expected result |
|-------|-----------------|
| **Accounts** menu | GitHub account listed (signed in) |
| **Chat → Agent** | Response to a test prompt within a few seconds |
| **Extensions → Runtime Status** | No **Uncaught Errors** such as `GitHubLoginFailed` |
| **Output → GitHub Copilot Chat** | No repeating `NotAuthorized` or `Failed to get copilot token` |

---

### Recovery: `GitHubLoginFailed` or *Chat took too long to get ready*

These errors mean the extension is installed but **has no valid GitHub/Copilot session**. Typical cause: Chat was opened before Device Authentication completed.

**Reset procedure (confirmed working in Dev Spaces):**

1. Close the Chat panel (do not send more messages).
2. Activity bar → **Accounts** → **Sign Out** from GitHub (all sessions).
3. Command Palette → **`GitHub: Device Authentication`**.
4. Complete the flow in an external browser tab (device code + authorize).
5. **Refresh** the Dev Spaces tab (`F5`).
6. Command Palette → **`Developer: Reload Window`**.
7. Open Chat → **Agent** → test again.

If it still fails, check Output channels (Command Palette → **Output**):

| Output channel | Look for |
|----------------|----------|
| **GitHub Authentication** | Device flow completed; OAuth errors |
| **GitHub Copilot Chat** | `NotAuthorized`, `HTTP401`, `Failed to get copilot token` |
| **Dev Spaces Copilot Chat Integration** | `GitHubLoginFailed` on activation |

For deeper diagnosis: Command Palette → **Developer: Set Log Level…** → **Trace**, reproduce the error, then copy logs from the channels above.

---

### Troubleshooting reference

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| **`GitHubLoginFailed`** in Runtime Status | Chat used before Device Authentication | [Recovery procedure](#recovery-githubloginfailed-or-chat-took-too-long-to-get-ready) above |
| *Chat took too long to get ready* | Same as above, or extension still loading | Sign out → Device Authentication → F5 → Reload Window |
| **Failed to sign in** after OAuth popup | Browser popup OAuth unsupported in Che-Code | Use **`GitHub: Device Authentication`** only |
| **`redhat.devspaces-copilot-chat-integration` not found** | Cluster Open VSX lacks the extension | See [Extension not found](#extension-not-found-redhatdevspaces-copilot-chat-integration) below |
| **User not authorized** / 401 in Output | No Copilot seat on account | [github.com/settings/copilot](https://github.com/settings/copilot) or ask org admin (Copilot Business) |
| **GHE.com** login prompt | User settings force GitHub Enterprise | Remove `"github.copilot.advanced": { "authProvider": "github-enterprise" }` from user settings |
| **Network** errors in Output | Pod cannot reach Copilot API | Ask platform team to allow `github.com`, `api.github.com`, `api.githubcopilot.com` |
| Cluster blocks Copilot entirely | Policy or no seats | [Continue + private LLM](https://developers.redhat.com/learning/learn:openshift-ai:integrate-private-ai-coding-assistant-your-cde-using-ollama-continue-openshift-dev-spaces/resource/resources:access-openshift-dev-spaces-and-create-your-cde) — use [`.devfile/continue.yaml`](../../.devfile/continue.yaml) with `?devfilePath=.devfile/continue.yaml` |

---

### `init-persistent-home` CrashLoopBackOff (works only after Restart)

| Symptom | Cause | Fix |
|---------|-------|-----|
| Workspace name **`vscode-continue-ai-env`** on first create | Wrong devfile — root `devfile.yaml` was selected instead of `.devfile.yaml` | **Recreate** workspace from repo; only `.devfile.yaml` should exist at root |
| Same error with a custom **`home-volume`** on `/home/user` | Conflicts with cluster **persistUserHome** (`init-persistent-home`) | Remove devfile `volume` mounts on `/home/user`; use platform persistence |
| **Automation Home** fails once, succeeds on Restart | PVC or pull-secret race on cluster | Retry once; if recurring, ask platform team (storage class / DWO) |

Optional Continue stack (no custom home volume): append `?devfilePath=.devfile/continue.yaml` to the factory URL.

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

## Continue + Ollama (local LLM, same workspace)

The default [`.devfile.yaml`](../../.devfile.yaml) runs **three AI assistants** in one workspace:

| Assistant | Purpose | Auth / setup |
|-----------|---------|--------------|
| **GitHub Copilot Agent** | Cloud LLM, Agent mode, `@AGENTS.md` | [Device Authentication](#first-time-setup-step-by-step) |
| **Continue** | Private / local LLM, air-gapped friendly | Extension + Ollama sidecar (automatic) |
| **Ollama** | Inference for Continue | Sidecar container, model `qwen2.5-coder:7b`, **CPU only** |

### Architecture

```text
DevWorkspace pod (shared network namespace)
├── che-code (IDE)          → Copilot Chat + Continue extension
├── automation-tools        → Ansible, postStart setup
└── ollama                  → qwen2.5-coder:7b @ http://127.0.0.1:11434
```

Continue reads [`.continue/config.yaml`](../../.continue/config.yaml), copied to `/home/user/.continue/` on postStart.

### Cluster requirements (no GPU)

| Resource | Value | Notes |
|----------|-------|--------|
| **Ollama memory** | 6–10 Gi | Sidecar limit in devfile |
| **Ollama PVC** | 15 Gi | Model cache (`ollama-models` volume) |
| **Pod memory (total)** | ~18 Gi+ | automation-tools 8 Gi + ollama 10 Gi |
| **CPU** | 4+ cores recommended | 7B model on CPU is slow but usable |
| **Egress** | First start only | `ollama pull` (~4.5 GiB for qwen2.5-coder:7b) |

Ask your platform team if workspace quota allows this pod size before rolling out to the whole team.

### First start

1. **Recreate existing workspace** after pulling devfile changes.
2. Wait for postStart:
   - `setup-workspace` — submodules, Copilot VSIX, Continue config
   - `ollama-pull-qwen` — may take **several minutes** on first run (model download)
3. Check logs if needed:

   ```bash
   cat .devfile/setup-workspace.log
   cat .devfile/ollama-pull.log
   ```

4. **Copilot:** complete [Device Authentication](#first-time-setup-step-by-step) (unchanged).
5. **Continue:** open the Continue icon in the activity bar → select **Qwen2.5 Coder 7B** if prompted → skip onboarding wizard if config is preloaded.

### Using governance with Continue

Continue does not auto-load `.github/copilot-instructions.md`. Start prompts with explicit paths:

```text
Read AGENTS.md. Operate in Mode 1: The Auditor.
Follow skills/automation-auditor/SKILL.md. Audit deliveries/automation/roles/<rolename>/.
```

Prompt library: [ai-prompt-examples.md](ai-prompt-examples.md).

### Optional: Context7 MCP

To enable the Context7 MCP server ([`.continue/mcpServers/mcp.json`](../../.continue/mcpServers/mcp.json)), mount a Secret as env `CONTEXT7_API_KEY` on the workspace (Dev Spaces **mount-as: env**). Without it, Continue works with Ollama only.

### Troubleshooting Continue / Ollama

| Symptom | Check | Fix |
|---------|-------|-----|
| Continue cannot connect | `curl -sf http://127.0.0.1:11434/api/tags` from a terminal | Wait for postStart; run **Pull Ollama model** from Command Palette or `bash .devfile/ollama-pull.sh` inside the **ollama** container |
| Model missing | `cat .devfile/ollama-pull.log` | Command Palette → **Pull Ollama model (qwen2.5-coder:7b)** |
| Very slow responses | Expected on CPU 7B | Normal without GPU; use Copilot for heavy Agent tasks |
| Out of memory | Pod OOMKilled on ollama container | Ask platform team for higher quota or use a smaller model |
| Continue extension missing | Extensions view | Install **Continue** (`Continue.continue`) from Open VSX |

Reference: [Red Hat — Ollama + Continue in Dev Spaces](https://developers.redhat.com/articles/2024/08/12/integrate-private-ai-coding-assistant-ollama).

---

## Ansible extension: PET binary warning (OpenVSX)

Dev Spaces distributes extensions via **Open VSX**. The universal build of `ms-python.python` / `ms-python.vscode-python-envs` often **omits the `pet` (Python Environment Tools) binary**. The Ansible extension then shows:

> *Python environment discovery is degraded (PET binary missing). This commonly occurs in OpenVSX-based editors (Dev Spaces, VSCodium).*

This is an **upstream packaging gap** ([Open VSX #1662](https://github.com/eclipse-openvsx/openvsx/issues/1662), [vscode-python #25820](https://github.com/microsoft/vscode-python/issues/25820)), not a defect in this repository.

### What the repo configures

[`automation-home.code-workspace`](../../automation-home.code-workspace) sets:

| Setting | Purpose |
|---------|---------|
| `python.useEnvironmentsExtension` → `false` | Use legacy interpreter discovery (works without PET) |
| `python.defaultInterpreterPath` → `.venv/bin/python` | Project venv from postStart (not global pip) |
| `ansible.python.interpreterPath` → `.venv/bin/python` | Ansible Language Server uses venv Python |

After pulling this change, run **Developer: Reload Window** (or recreate the workspace). The warning may appear once more until settings reload; click **Don't show again** if offered.

### If you use a virtualenv

Activate manually in the terminal:

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements-dev.txt
```

Or Command Palette → **Python: Select Interpreter** → choose `.venv/bin/python`.

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
