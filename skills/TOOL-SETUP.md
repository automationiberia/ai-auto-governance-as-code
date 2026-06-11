# Agent Skills — tool-agnostic setup

**Canonical source (all tools):** `skills/*/SKILL.md` and [AGENTS.md](../AGENTS.md) in the **`ai-auto-governance-as-code`** repository.
Do not fork skill text into tool-specific copies unless your platform requires it — link or load from here.

**Which tool are you using?** Follow exactly one row below, then use [prompt examples](../automation-whitepaper/guides/ai-prompt-examples.md).

---

## Choose your AI environment

| Tool | Skill format | Setup (this repo) | How to invoke |
|------|--------------|-------------------|---------------|
| **[Cursor](#cursor)** | `SKILL.md` in `.cursor/skills/` | [Cursor setup](#cursor) | Chat: `Use skill automation-auditor` · `@AGENTS.md` · `@skills/.../SKILL.md` |
| **[Claude](#claude)** (Desktop, Code, Projects, API) | Project knowledge / system context | [Claude setup](#claude) | Paste path or attach `AGENTS.md` + skill; name mode in prompt |
| **[VS Code + Copilot](#github-copilot)** | Instructions / chat | [Copilot setup](#github-copilot) | Reference `AGENTS.md` in instructions; @-file if supported |
| **[Other / generic](#generic-any-agent)** | Any agent with file + chat access | [Generic setup](#generic-any-agent) | Read `AGENTS.md`; explicit skill name + file paths in prompt |

Prompt copy-paste library (tool-neutral): [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md).

---

## Repository prep (every tool)

```bash
cd /path/to/ai-auto-governance-as-code
git submodule update --init --recursive
pip install -r requirements-dev.txt
pre-commit install   # optional but recommended for humans
export AUTOMATION_HOME="$(pwd)"
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

---

## Cursor

**When:** You use Cursor IDE with Agent / Chat on this repo.

1. Clone `ai-auto-governance-as-code` and run repository prep above.
2. Link skills into Cursor’s project skill directory:

   ```bash
   ./skills/scripts/link-cursor-skills.sh
   ```

   This symlinks `skills/automation-*` → `.cursor/skills/` (gitignored; per-machine).

3. Open `automation-home.code-workspace` (monorepo + `deliveries/automation`).
4. Optional project rule (Cursor Settings → Rules): *Read AGENTS.md; state Mode 1/2/3 before Ansible output.*

**Invoke:** `Use skill automation-architect` · `@AGENTS.md` · `@skills/automation-auditor/SKILL.md`

**Refresh:** After `git pull` adds skills, re-run `link-cursor-skills.sh`.

---

## Claude

**When:** Claude Desktop, Claude Code, Claude Projects, or API agents working against this repo.

Claude has **no standard “skills folder”** shared with Cursor. Configure **context** instead:

### Claude Code / CLI (repo on disk)

1. Repository prep above.
2. Add or merge a project instruction file that points at governance (optional template below).
3. In session, ask Claude to read `AGENTS.md` before Ansible work.

**Optional** — create `CLAUDE.md` at repo root (if your workflow uses it):

```markdown
# Project instructions

Before Ansible or automation-whitepaper work, read AGENTS.md and declare
Auditor / Architect / Librarian mode. Skills live under skills/automation-*/SKILL.md.
Delivery code: deliveries/automation/ ($AUTOMATION_REPO).
```

### Claude Desktop / Projects (upload or connector)

1. Add **`AGENTS.md`** and relevant **`skills/<name>/SKILL.md`** files to project knowledge, **or**
2. Paste the skill path and ask: *Read skills/automation-auditor/SKILL.md and AGENTS.md, then …*

**Invoke (any Claude surface):**

```text
Read AGENTS.md in this project. Operate in Mode 1: The Auditor.
Follow skills/automation-auditor/SKILL.md. Audit deliveries/automation/roles/<function>/.
```

Do **not** rely on `.mdc` unless your Claude product documents that format; **`SKILL.md` here is markdown**.

---

## GitHub Copilot

**When:** VS Code / Visual Studio with Copilot Chat on this workspace.

1. Repository prep above.
2. Point Copilot at repo instructions, e.g. create or extend `.github/copilot-instructions.md`:

   ```markdown
   For Ansible automation in this repo, follow AGENTS.md and skills/automation-*/SKILL.md.
   Declare Auditor, Architect, or Librarian mode before technical output.
   ```

3. In chat, `@AGENTS.md` and role paths if your Copilot build supports file context.

**Invoke:** Same natural-language prompts as [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md); name the skill explicitly.

---

## Generic (any agent)

**When:** ChatGPT, Gemini, internal LLM gateways, CI agents, or any tool that can read files.

**Minimum viable setup:**

1. Provide the agent read access to the cloned repo (or paste/upload `AGENTS.md` + one `SKILL.md`).
2. Start every automation task with:

   ```text
   Read <path>/AGENTS.md. State your mode (Auditor / Architect / Librarian).
   Then follow <path>/skills/<skill-name>/SKILL.md.
   ```

3. Use **paths**, not pasted YAML — e.g. `deliveries/automation/roles/<function>/tasks/main.yml`.

**No extra scripts required** — skip `link-cursor-skills.sh` unless you also use Cursor.

---

## Adding a new skill (Librarian — all tools)

1. Add `skills/automation-<name>/SKILL.md` (see [skills/README.md](README.md)).
2. Update white paper + catalog in `skills/README.md`.
3. **Tool-specific sync:**
   - **Cursor:** `./skills/scripts/link-cursor-skills.sh`
   - **Claude / Copilot / generic:** Update project knowledge or instruction file if you mirror paths there

---

## Related

- [skills/README.md](README.md) — catalog and modes
- [AGENTS.md](../AGENTS.md) — bootstrap rules
- [ai-prompt-examples.md](../automation-whitepaper/guides/ai-prompt-examples.md) — prompts
