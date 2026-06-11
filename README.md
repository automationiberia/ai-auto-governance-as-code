# ai-auto-governance-as-code

> **AI-Driven Governance-as-Code for Ansible Automation**

Centralized governance monorepo for Ansible standards, documentation, and AI Agent Skills. Aligned with [Red Hat CoP](https://github.com/redhat-cop/automation-good-practices), adaptable to enterprise change flows.

**New here?** Start with [Getting started](automation-whitepaper/guides/getting-started.md) (15 min).

| Goal | Guide |
|------|-------|
| First time in the repo | [Getting started](automation-whitepaper/guides/getting-started.md) |
| Review or fix existing code | [Evaluate & update](automation-whitepaper/guides/evaluate-and-update-existing.md) |
| Build something new | [Create from scratch](automation-whitepaper/guides/create-new-from-scratch.md) |

**AI agents:** [AGENTS.md](AGENTS.md) · [ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md)

**Architecture:** [monorepo layout](automation-whitepaper/architecture/monorepo-layout.md) · [Strategic proposal v1.0](automation-whitepaper/governance/strategic-proposal-aap-governance-evolution.md) · [AAP & Puppet phases](automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md)

---

## 🚀 Quick Start

```bash
# Clone with submodules
git clone --recurse-submodules <repo-url>
cd ai-auto-governance-as-code

# Setup (or use 'make setup')
pip install -r requirements-dev.txt
pre-commit install
git submodule update --init deliveries/automation

# Set environment
export AUTOMATION_HOME=$(pwd)
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

## 📁 Repository Structure

```
ai-auto-governance-as-code/
├── automation-whitepaper/    # Standards, architecture, examples
├── skills/                   # AI agent skills (SKILL.md files)
├── automation-good-practices/# Red Hat CoP submodule
├── deliveries/automation/    # Actual Ansible collection (submodule)
├── AGENTS.md                 # AI agent operating modes
└── Makefile                  # Common tasks (make help)
```

## 📚 Key Documentation

| Document | Purpose |
|----------|---------|
| **[Getting started](automation-whitepaper/guides/getting-started.md)** | Clone, setup, pick your path |
| **[Evaluate & update](automation-whitepaper/guides/evaluate-and-update-existing.md)** | Audit and fix existing automation |
| **[Create from scratch](automation-whitepaper/guides/create-new-from-scratch.md)** | New capability in 7 steps |
| **[AGENTS.md](AGENTS.md)** | Human as Architect; AI modes: Auditor / Builder / Librarian |
| **[skills/TOOL-SETUP.md](skills/TOOL-SETUP.md)** | Configure Cursor / Claude / Copilot |
| **[docs/PRE-COMMIT-GUIDE.md](docs/PRE-COMMIT-GUIDE.md)** | Pre-commit hooks setup and usage |
| **[automation-whitepaper/](automation-whitepaper/)** | Complete standards & architecture |
| **[CONTRIBUTING.md](CONTRIBUTING.md)** | How to contribute |

## 🤖 For AI Agents

**Start here:** [AGENTS.md](AGENTS.md) — Declare your mode before generating code.

**Prompt examples:** [ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md)

**Skills catalog:** [skills/README.md](skills/README.md)

## 🛠️ Common Tasks

```bash
make help              # List all available commands
make validate          # Run all validation checks
make test              # Run tests (lint + validate)
make info              # Show environment info
```

See [Makefile](Makefile) for all targets.

## 🌐 OpenShift Dev Spaces

Import via [`.devfile.yaml`](.devfile.yaml). See [devspaces-workspace.md](automation-whitepaper/guides/devspaces-workspace.md).

**Delivery submodule** requires SSH access to `git@github.com:automationiberia/ai-auto-deliveries.git`. See [deliveries/README.md](deliveries/README.md).
