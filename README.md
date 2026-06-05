# ai-auto-skills

> **AI-Driven Governance-as-Code for Ansible Automation**

Centralized monorepo providing standards, documentation, and AI agent skills for enterprise Ansible automation. Aligned with [Red Hat CoP Automation Good Practices](https://github.com/redhat-cop/automation-good-practices).

## 🚀 Quick Start

```bash
# Clone with submodules
git clone --recurse-submodules <repo-url>
cd ai-auto-skills

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
ai-auto-skills/
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
| **[AGENTS.md](AGENTS.md)** | AI agent modes: Auditor / Architect / Librarian |
| **[skills/TOOL-SETUP.md](skills/TOOL-SETUP.md)** | Configure Cursor / Claude / Copilot |
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
