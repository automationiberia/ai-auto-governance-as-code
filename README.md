# ai-auto-governance-as-code

> **AI-Driven Governance-as-Code for Ansible Automation**

Centralized governance monorepo for Ansible standards, documentation, and AI Agent Skills. **Consumes [ai-forge](https://github.com/ansible-community/ai-forge) for SDLC workflows** while maintaining **version-controlled CoP** in `automation-good-practices/`.

Governance is **human-authored** in the [Automation White Paper](automation-whitepaper/README.md). **Red Hat CoP** (`automation-good-practices/` submodule) is the baseline where the white book is silent; on conflict, **the white book wins**.

**Architecture:** [GaC + ai-forge integration](automation-whitepaper/architecture/ai-forge-gac-integration.md) · [Getting started](automation-whitepaper/guides/getting-started.md)

| Goal | Guide |
|------|-------|
| First time in the repo | [Getting started](automation-whitepaper/guides/getting-started.md) |
| Review or fix existing code | [Evaluate & update](automation-whitepaper/guides/evaluate-and-update-existing.md) |
| Build something new | [Create from scratch](automation-whitepaper/guides/create-new-from-scratch.md) |

**AI agents:** [AGENTS.md](AGENTS.md) · [ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md)

---

## Quick Start

```bash
git clone --recurse-submodules https://github.com/automationiberia/ai-auto-governance-as-code.git
cd ai-auto-governance-as-code
make install
```

Optional: `pre-commit install` · set `AUTOMATION_HOME` and `AUTOMATION_REPO` — see [getting-started](automation-whitepaper/guides/getting-started.md).

### Lola install (AI assistant only)

Run from **repository root**. Skills go to your **assistant** (e.g. `.cursor/skills/`), **not** into `automation-whitepaper/`.

```bash
cd ai-auto-governance-as-code    # repo root
pip install lola-ai
lola market add gac \
  https://raw.githubusercontent.com/automationiberia/ai-auto-governance-as-code/main/lola-market.yml
lola install gac -a claude-code   # or: -a cursor
```

See [Where Lola installs](automation-whitepaper/architecture/ai-forge-gac-integration.md#where-lola-installs-explicit) for the full table.

---

## Built on ai-forge

GaC **consumes ai-forge for SDLC only** — not for CoP compliance governance.

| Source | Provides |
|--------|----------|
| **ai-forge** (Lola) | `/commit`, `/create-pr`, `/release`, `/changelog-fragment`; optional `/ansible-zen` |
| **GaC** (this repo) | Pinned CoP submodule, white book, AAP architecture, Auditor/Builder/Librarian agents |

Full architecture, rationale, and usage examples: **[ai-forge-gac-integration.md](automation-whitepaper/architecture/ai-forge-gac-integration.md)**

---

## Repository Structure

```
ai-auto-governance-as-code/
├── .lola-req                   # ai-forge SDLC dependency
├── lola-market.yml             # Makes GaC installable via Lola
├── automation-whitepaper/      # Enterprise standards, architecture, guides
├── skills/                     # Enterprise Agent Skills
├── automation-good-practices/  # Red Hat CoP submodule (pinned, auditable)
├── deliveries/automation/      # Production collection (submodule)
├── AGENTS.md
└── Makefile                    # make install · make validate
```

Layout details: [monorepo layout](automation-whitepaper/architecture/monorepo-layout.md).

---

## Common Tasks

```bash
make install           # Lola sync (SDLC) + git submodules
make validate          # pre-commit run --all-files
make help              # All targets
```

---

## OpenShift Dev Spaces

Import via [`.devfile.yaml`](.devfile.yaml) (workspace **Automation Home**): **Copilot Agent** + **Continue** + **Ollama** (`qwen2.5-coder:7b`, CPU). Fallback without Ollama: `?devfilePath=.devfile/base.yaml`. See [devspaces-workspace.md](automation-whitepaper/guides/devspaces-workspace.md).

**Delivery submodule** requires SSH: `git@github.com:automationiberia/ai-auto-deliveries.git`. See [deliveries/README.md](deliveries/README.md).
