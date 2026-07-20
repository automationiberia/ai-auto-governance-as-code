# Agent Skills — tool-agnostic setup

**Canonical source (all tools):** `skills/*/SKILL.md` and [AGENTS.md](../AGENTS.md) in the **`ai-auto-governance-as-code`** repository.
Do not fork skill text into tool-specific copies unless your platform requires it — link or load from here.

**Recommended:** Install skills with **[Lola](#lola-recommended)** — one command per assistant. Manual per-tool setup below is a fallback.

Prompt copy-paste library (tool-neutral): [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md).

---

## Lola (recommended)

[Lola](https://lobstertrap.org/lola/) is the package manager for AI context. It installs GaC governance skills (and ai-forge SDLC skills via the `gac` module) into Cursor, Claude Code, and other supported assistants.

### Where Lola installs (explicit)

**Run from the repository root** (`ai-auto-governance-as-code/`, where `lola-market.yml` is). **Never** from `automation-whitepaper/`.

| Content | Lola writes to `automation-whitepaper/`? | Where it goes |
|---------|------------------------------------------|---------------|
| ai-forge SDLC (`/commit`, …) | **No** | Lola cache → assistant-native format |
| GaC skills (`skills/`) | **No** | e.g. `.cursor/skills/` (gitignored) |
| White book (`automation-whitepaper/`) | **No** — read only | Stays in your git clone |

Full table: [ai-forge-gac-integration.md § Where Lola installs](../automation-whitepaper/architecture/ai-forge-gac-integration.md#where-lola-installs-explicit).

### Install GaC into your assistant

After [repository prep](#repository-prep-every-tool):

```bash
cd /path/to/ai-auto-governance-as-code   # repo root
pip install lola-ai
lola market add gac \
  https://raw.githubusercontent.com/automationiberia/ai-auto-governance-as-code/main/lola-market.yml
lola install gac -a <assistant>
```

| Assistant | Command |
|-----------|---------|
| **Cursor** | `lola install gac -a cursor` |
| **Claude Code** | `lola install gac -a claude-code` |
| **Multiple / unsure** | `lola install gac` — select assistants when prompted |

**Verify:** `lola list` — skills should appear under your assistant for this project.

**Refresh:** After `git pull` changes skills or `.lola-req`, run `lola sync` and/or `lola install gac -a <assistant>` again.

**Invoke:** `Use skill automation-builder` · `@AGENTS.md` · ai-forge SDLC slash commands (`/commit`, `/create-pr`, …).

---

## Choose your AI environment (manual fallback)

Use these sections only if Lola is unavailable for your assistant.

| Tool | Skill format | Setup (fallback) | How to invoke |
|------|--------------|------------------|---------------|
| **[Cursor](#cursor)** | `SKILL.md` in `.cursor/skills/` | [Cursor setup](#cursor) | Chat: `Use skill automation-auditor` · `@AGENTS.md` · `@skills/.../SKILL.md` |
| **[Claude](#claude)** (Desktop, Code, Projects, API) | Project knowledge / system context | [Claude setup](#claude) | Paste path or attach `AGENTS.md` + skill; name mode in prompt |
| **[VS Code + Copilot](#github-copilot)** | Instructions / chat | [Copilot setup](#github-copilot) | Reference `AGENTS.md` in instructions; @-file if supported |
| **[Other / generic](#generic-any-agent)** | Any agent with file + chat access | [Generic setup](#generic-any-agent) | Read `AGENTS.md`; explicit skill name + file paths in prompt |

---

## Repository prep (every tool)

```bash
cd /path/to/ai-auto-governance-as-code
make install          # Lola SDLC (ai-forge) + git submodules (CoP + delivery)
pre-commit install    # optional but recommended for humans
export AUTOMATION_HOME="$(pwd)"
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

**SDLC from ai-forge (via Lola):** `/commit`, `/create-pr`, `/release`, `/changelog-fragment`.
**CoP compliance:** `automation-good-practices/` submodule + GaC Auditor skills — not ai-forge `/ansible-cop-review`.
See [ai-forge-gac-integration.md](../automation-whitepaper/architecture/ai-forge-gac-integration.md).

---

## Cursor

**When:** You use Cursor IDE with Agent / Chat on this repo.

**Prefer:** [Lola](#lola-recommended) — `lola install gac -a cursor`.

**Manual fallback:**

1. Clone `ai-auto-governance-as-code` and run repository prep above.
2. Link skills into Cursor’s project skill directory:

   ```bash
   ./skills/scripts/link-cursor-skills.sh
   ```

   This symlinks `skills/automation-*` and `skills/platform/aap-*` → `.cursor/skills/` (gitignored; per-machine). Removes stale links (e.g. deprecated `automation-architect`) and links current skills such as `automation-builder`.

3. Open `automation-home.code-workspace` (monorepo root; `deliveries/automation/` is a nested submodule folder).
4. Optional: configure AAP MCP per [MCP setup](#mcp-aap-platform-skills).
5. Optional project rule (Cursor Settings → Rules): *Read AGENTS.md; state Mode 1/2/3 before Ansible output.*

**Invoke:** `Use skill automation-builder` · `Use skill aap-live-snapshot` · `@AGENTS.md` · `@skills/automation-auditor/SKILL.md`

**Refresh (manual):** After `git pull` adds or renames skills, re-run `link-cursor-skills.sh` or prefer `lola install gac -a cursor`.

---

## Claude

**When:** Claude Desktop, Claude Code, Claude Projects, or API agents working against this repo.

**Prefer:** [Lola](#lola-recommended) — `lola install gac -a claude-code`.

Claude has **no standard “skills folder”** shared with Cursor. Without Lola, configure **context** instead:

### Claude Code / CLI (repo on disk)

1. Repository prep above.
2. Add or merge a project instruction file that points at governance (optional template below).
3. In session, ask Claude to read `AGENTS.md` before Ansible work.

**Optional** — create `CLAUDE.md` at repo root (if your workflow uses it):

```markdown
# Project instructions

Before Ansible or automation-whitepaper work, read AGENTS.md and declare
Auditor / Builder / Librarian mode (human = Architect). Content skills: skills/automation-*/SKILL.md.
Platform skills: skills/platform/aap-*/SKILL.md (MCP required).
Delivery code: deliveries/automation/ ($AUTOMATION_REPO).
```

### Claude Desktop / Projects (upload or connector)

1. Add **`AGENTS.md`** and relevant **`skills/<name>/SKILL.md`** files to project knowledge, **or**
2. Paste the skill path and ask: *Read skills/automation-auditor/SKILL.md and AGENTS.md, then …*

**Invoke (any Claude surface):**

```text
Read AGENTS.md in this project. Operate in Mode 1: The Auditor.
Follow skills/automation-auditor/SKILL.md. Audit deliveries/automation/roles/rolename/.
```

Do **not** rely on `.mdc` unless your Claude product documents that format; **`SKILL.md` here is markdown**.

---

## GitHub Copilot

**When:** VS Code / Visual Studio with Copilot Chat on this workspace (including **OpenShift Dev Spaces**).

**Prefer:** [Lola](#lola-recommended) if your Copilot build is supported; otherwise manual setup below.

**Manual fallback:**

1. Repository prep above.
2. **Dev Spaces — Copilot:** [devspaces-workspace.md § Copilot Agent](../automation-whitepaper/guides/devspaces-workspace.md#github-copilot-agent--setup-and-authentication).
3. **Dev Spaces — Continue + Ollama:** same guide, [§ Continue + Ollama](../automation-whitepaper/guides/devspaces-workspace.md#continue--ollama-local-llm-same-workspace) (local `qwen2.5-coder:7b`, no GPU).
4. Repo instructions ship in [`.github/copilot-instructions.md`](../.github/copilot-instructions.md) — Copilot loads this automatically once signed in.
5. Open `automation-home.code-workspace`.
6. In chat, `@AGENTS.md` and skill paths if your Copilot build supports file context.

**Invoke:** Same natural-language prompts as [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md); name the skill explicitly.

---

## Generic (any agent)

**When:** ChatGPT, Gemini, internal LLM gateways, CI agents, or any tool that can read files.

**Prefer:** [Lola](#lola-recommended) when available for your agent.

**Manual fallback:**

1. Provide the agent read access to the cloned repo (or paste/upload `AGENTS.md` + one `SKILL.md`).
2. Start every automation task with:

   ```text
   Read <path>/AGENTS.md. State your mode (Auditor / Builder / Librarian).
   Then follow <path>/skills/<skill-name>/SKILL.md.
   ```

3. Use **paths**, not pasted YAML — e.g. `deliveries/automation/roles/rolename/tasks/main.yml`.

**No extra scripts required** when using Lola. Skip `link-cursor-skills.sh` unless you use the Cursor manual fallback.

---

## MCP (AAP platform skills)

**When:** You use `skills/platform/aap-*` skills to operate or audit live Ansible Automation Platform via MCP.

Platform skills are **optional** — engineers without MCP follow [aap-platform-administration.md](../automation-whitepaper/operations/aap-platform-administration.md) and the Controller UI manually.

1. Deploy AAP MCP servers in your environment (see upstream [AAP Skills Library](https://github.com/automationiberia/aap-skills-library)).
2. Copy [config/mcp.json.example](../config/mcp.json.example) to your client config (e.g. `.cursor/mcp.json`). **Never commit secrets.**
3. Set `AAP_MCP_TOKEN` or equivalent in your environment — not in Git.
4. Link platform skills: `lola install gac -a <assistant>` (recommended) or `./skills/scripts/link-cursor-skills.sh` (Cursor manual) or reference `skills/platform/aap-*/SKILL.md` directly (Claude/Copilot/generic).

**Invoke (read-only Phase 1 example):**

```text
Platform area: Audit (read-only).
I have evaluated Red Hat CoP baseline rules against white book overrides.
Use skill aap-live-snapshot for organization "Lab".
```

More prompts: [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md) §12.

---

## Adding a new skill (Librarian — all tools)

1. Add `skills/automation-<name>/SKILL.md` or `skills/platform/aap-<name>/SKILL.md` (see [SKILL-TEMPLATE.md](SKILL-TEMPLATE.md)).
2. Update white paper + catalog in `skills/README.md`.
3. **Sync to assistants:**
   - **Lola (recommended):** `lola install gac -a <assistant>` (or `lola sync` if `.lola-req` lists the module)
   - **Cursor (manual):** `./skills/scripts/link-cursor-skills.sh`
   - **Claude / Copilot / generic:** Update project knowledge or instruction file if you mirror paths there

For platform skills sourced from AAPSL: update white book first, merge from `skills/vendor/aap-skills-library/`, run `./skills/scripts/sync-aapsl-skills.sh --diff`.

---

## Related

- [skills/README.md](README.md) — catalog and modes
- [AGENTS.md](../AGENTS.md) — bootstrap rules
- [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md) — prompts
