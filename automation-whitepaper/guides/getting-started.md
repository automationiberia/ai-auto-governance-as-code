# Getting started — use this repository in 15 minutes

One-page path from zero to productive. Deep reference: [01-main-guide.md](../01-main-guide.md).

---

## What this repo is

| Piece | Folder | You use it to… |
|-------|--------|----------------|
| **Standards** | `automation-whitepaper/` | Read how we build and ship Ansible |
| **AI rules** | `skills/` + `AGENTS.md` | Let agents audit, build, or update standards |
| **Upstream baseline** | `automation-good-practices/` | Compare with Red Hat CoP (submodule) |
| **Real Ansible code** | `deliveries/automation/` | Roles and playbooks in production (submodule) |

**You are the Architect** (design + approval). AI agents work in **Auditor**, **Builder**, or **Librarian** mode — see [AGENTS.md](../../AGENTS.md).

---

## Step 1 — Clone and install

```bash
git clone --recurse-submodules git@github.com:automationiberia/ai-auto-governance-as-code.git
cd ai-auto-governance-as-code
pip install -r requirements-dev.txt
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

---

## Step 4 — Optional: configure AI (pick one tool)

| Tool | Do this once |
|------|----------------|
| **Cursor** | `./skills/scripts/link-cursor-skills.sh` — see [TOOL-SETUP.md](../../skills/TOOL-SETUP.md#cursor) |
| **Claude / Copilot / other** | Point the agent at `AGENTS.md` + one `skills/*/SKILL.md` — see [TOOL-SETUP.md](../../skills/TOOL-SETUP.md) |

In every AI session, the agent must **declare its mode** before writing YAML.

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
