# Getting started — use this repository in 15 minutes

One-page path from zero to productive. Deep reference: [01-main-guide.md](../01-main-guide.md).

---

## What this repo is

| Piece | Folder | You use it to… |
|-------|--------|----------------|
| **Standards** | `automation-whitepaper/` | Read how we build and ship Ansible |
| **AI rules** | `skills/` + `AGENTS.md` | Let agents audit, build, or update standards |
| **CoP baseline** | `automation-good-practices/` | Pinned Red Hat CoP (submodule) |
| **SDLC skills** | ai-forge via Lola | `/commit`, `/create-pr`, `/release` — run `make install` |
| **Real Ansible code** | `deliveries/automation/` | Roles and playbooks in production (submodule) |

**You are the Architect** (design + approval). AI agents work in **Auditor**, **Builder**, or **Librarian** mode — see [AGENTS.md](../../AGENTS.md). You can also work **manually** (no AI): same standards, no mode declaration.

### Manual path (recommended to start)

1. This guide through Step 5
2. Reference examples: **light** and **standard** under [examples/](../examples/)
3. `pre-commit run --all-files` and `ansible-playbook --syntax-check`

Folder map: [whitebook-folder-map.md](../governance/whitebook-folder-map.md).

---

## Step 1 — Clone and install

```bash
git clone --recurse-submodules git@github.com:automationiberia/ai-auto-governance-as-code.git
cd ai-auto-governance-as-code
make install
pre-commit install
```

If submodules were missing:

```bash
git submodule update --init --recursive
```

---

## Step 2 — Set paths (every session)

```bash
export AUTOMATION_HOME="$(pwd)"
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

Add those lines to your shell profile if you work here often.

---

## Step 3 — Pick your goal

| I want to… | Follow this guide |
|------------|-------------------|
| **Review or fix existing Ansible** | [evaluate-and-update-existing.md](evaluate-and-update-existing.md) |
| **Build something new** | [create-new-from-scratch.md](create-new-from-scratch.md) |
| **Only read standards** | [01-main-guide.md](../01-main-guide.md) or [README.md](../README.md) |
| **Use AI agents** | Continue to Step 4 below, then [ai-prompt-examples.md](ai-prompt-examples.md) |

**AI shortcut (route me):**

```text
Read AGENTS.md. My goal: [review existing Ansible | build new capability | read standards only].
Which guide, mode (Auditor / Builder / Librarian), and skills should I use?
Declare mode before any YAML.
```

---

## Step 4 — Optional: configure AI with Lola

[Lola](https://lobstertrap.org/lola/) installs GaC governance skills and ai-forge SDLC workflows into your AI assistant — one setup path instead of per-tool manual wiring. Details: [TOOL-SETUP.md](../../skills/TOOL-SETUP.md).

**One-time setup** (from repo root, after Steps 1–2):

```bash
pip install lola-ai
lola market add gac \
  https://raw.githubusercontent.com/automationiberia/ai-auto-governance-as-code/main/lola-market.yml
lola install gac -a <assistant>
```

| Assistant | Command |
|-----------|---------|
| **Cursor** | `lola install gac -a cursor` |
| **Claude Code** | `lola install gac -a claude-code` |
| **Other** | `lola install gac` — select assistants when prompted |

After `git pull` adds or renames skills, run `lola install gac -a <assistant>` again (or `lola sync` if the repo uses `.lola-req`).

In every AI session, the agent must **declare its mode** before writing YAML.

**AI shortcut (first session):**

```text
Read AGENTS.md.
AUTOMATION_HOME and AUTOMATION_REPO are set.
Confirm Lola installed the gac module for my assistant. List available skills for my goal.
Declare mode before any YAML.
```

---

## Step 5 — Run a quick health check

```bash
make validate          # or: pre-commit run --all-files
make info              # shows AUTOMATION_HOME / AUTOMATION_REPO
```

Syntax-check an example playbook:

```bash
ansible-playbook --syntax-check \
  automation-whitepaper/examples/light-dev-packages/playbooks/type_dev_workstation.yml
```

**AI shortcut:**

```text
Run make validate (or pre-commit run --all-files) and ansible-playbook --syntax-check
on automation-whitepaper/examples/light-dev-packages/playbooks/type_dev_workstation.yml.
Report results — no file edits.
```

---

## Step 6 — Learn by example (recommended)

| Profile | Start here |
|---------|------------|
| **Light** (simple) | [walkthrough](../examples/example-light-walkthrough-dev-packages.md) · [code](../examples/light-dev-packages/) |
| **Standard** (production-style) | [walkthrough](../examples/example-complete-walkthrough-rsyslog-forwarding.md) · [code](../examples/standard-rsyslog-forwarding/) |

---

## Terms you may see

**Gate** = mandatory checkpoint before merge or production (e.g. pre-commit green, peer review).
**CAB** = Change Advisory Board (*Comité de Cambios*) — formal approval before production changes.

Full definitions: [glossary.md](glossary.md).

---

## Cheat sheet

| Task | Command / doc |
|------|----------------|
| List make targets | `make help` |
| Pre-commit help | [docs/PRE-COMMIT-GUIDE.md](../../docs/PRE-COMMIT-GUIDE.md) |
| Git workflow for delivery code | [git-automation-repository.md](git-automation-repository.md) |
| Dev Spaces (browser IDE) | [devspaces-workspace.md](devspaces-workspace.md) |
| Full skill catalog | [skills/README.md](../../skills/README.md) |

---

## Related

- [evaluate-and-update-existing.md](evaluate-and-update-existing.md)
- [create-new-from-scratch.md](create-new-from-scratch.md)
- [monorepo-layout.md](../architecture/monorepo-layout.md)
