# ai-auto-skills — Ansible governance monorepo

**AI-Driven Governance-as-Code for Ansible Automation**

Centralized governance monorepo for Ansible standards, documentation, and AI Agent Skills. Aligned with [Red Hat CoP](https://github.com/redhat-cop/automation-good-practices), adaptable to enterprise change flows.

**Quick start:** [AGENTS.md](AGENTS.md) for AI agent modes · [ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md) for prompts · [governance-as-code-ai-enforcement.md](automation-whitepaper/governance/governance-as-code-ai-enforcement.md) for programming guide.

**Architecture:** [monorepo layout](automation-whitepaper/architecture/monorepo-layout.md) · [Strategic proposal v1.0](automation-whitepaper/governance/strategic-proposal-aap-governance-evolution.md) · [AAP & Puppet phases](automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md)

---

## Structure

| Directory | Purpose |
|-----------|---------|
| **`automation-whitepaper/`** | Standards guide — lifecycle, architecture, quality, executable examples |
| **`skills/`** | AI Agent Skills — instructions for creating, reviewing, and governing code |
| **`automation-good-practices/`** | Git submodule — Red Hat CoP reference |
| **`deliveries/automation/`** | Git submodule — [`automationiberia/ai-auto-deliveries`](https://github.com/automationiberia/ai-auto-deliveries) |
| **`AGENTS.md`** | Agent bootstrap and operating modes |

```bash
export AUTOMATION_HOME=/path/to/this/repository
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

---

## Setup

```bash
git clone --recurse-submodules <ai-auto-skills-url>
cd ai-auto-skills
pip install -r requirements-dev.txt
pre-commit install
git submodule update --init deliveries/automation
```

**AI tool setup:** [skills/TOOL-SETUP.md](skills/TOOL-SETUP.md) (Cursor, Claude, Copilot, etc.)

**Delivery submodule** requires SSH access to `git@github.com:automationiberia/ai-auto-deliveries.git`. See [deliveries/README.md](deliveries/README.md).

**OpenShift Dev Spaces:** Import via [`.devfile.yaml`](.devfile.yaml). Details: [devspaces-workspace.md](automation-whitepaper/guides/devspaces-workspace.md).
