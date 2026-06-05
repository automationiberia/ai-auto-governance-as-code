# ai-auto-skills — Ansible governance monorepo

**AI-Driven Governance-as-Code for Ansible Automation**

The **`ai-auto-skills`** centralized monorepo is the **single point of entry** for standards, documentation, and the **intelligence layer** (AI Agent Skills) that drives automation operations. By moving away from **loose playbooks** scattered across repositories, this layout establishes a **unified framework** aligned with the [Red Hat Community of Practice (CoP)](https://github.com/redhat-cop/automation-good-practices) while remaining adaptable to **enterprise-grade change flows** (see [example-enterprise-change-flow.md](automation-whitepaper/examples/example-enterprise-change-flow.md)).

**AI agents:** read [AGENTS.md](AGENTS.md) first — declare operating mode (Auditor / Architect / Librarian) before technical output. **Prompt examples:** [ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md). Program guide: [governance-as-code-ai-enforcement.md](automation-whitepaper/governance/governance-as-code-ai-enforcement.md).

Architecture: [monorepo layout](automation-whitepaper/architecture/monorepo-layout.md) · [AAP & Puppet evolution (three phases)](automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md).

---

## Monorepo components

| Directory | Function |
|-----------|----------|
| **`automation-whitepaper/`** | The **white book** — authoritative guide for lifecycle, architecture, quality, and **executable examples** (light / standard / heavy). |
| **`skills/`** | **AI Agent Skills** (`SKILL.md` markdown; some tooling uses `.mdc` or equivalent). Instruct agents how to **create**, **review**, and **govern** code according to the white book. |
| **`automation-good-practices/`** | **Git submodule** — upstream reference from the Red Hat CoP GPA. |
| **`deliveries/automation/`** | **Git submodule** → [`automationiberia/ai-auto-deliveries`](https://github.com/automationiberia/ai-auto-deliveries). **Do not change** the URL in [`.gitmodules`](.gitmodules) — submodule init will fail. |

| Root artifact | Function |
|---------------|----------|
| **`AGENTS.md`** | Agent bootstrap, three operating modes, Architect compliance rules. |
| **`requirements-dev.txt`**, **`.pre-commit-config.yaml`** | Lint and hook profile for this repository and examples. |

```bash
export AUTOMATION_HOME=/path/to/this/repository
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

`<automation-home>` in the white book means the governance repository root (this monorepo).

---

## Adopting or cloning

```bash
git clone --recurse-submodules <ai-auto-skills-url>
cd ai-auto-skills
pip install -r requirements-dev.txt
pre-commit install
```

Configure Agent Skills for **your AI tool** (Cursor, Claude, Copilot, or other): **[skills/TOOL-SETUP.md](skills/TOOL-SETUP.md)** — then see [ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md).

Initialize the delivery submodule (remote is fixed in `.gitmodules`):

```bash
git submodule update --init deliveries/automation
```

Requires Git access to `git@github.com:automationiberia/ai-auto-deliveries.git` (SSH key or equivalent in Dev Spaces).

See [deliveries/README.md](deliveries/README.md) and [automation-whitepaper/guides/git-automation-repository.md](automation-whitepaper/guides/git-automation-repository.md).

---

## Optional: OpenShift Dev Spaces

Import in **Dev Spaces** via [`.devfile.yaml`](.devfile.yaml) and [`automation-home.code-workspace`](automation-home.code-workspace). Post-start runs [`.devfile/setup-workspace.sh`](.devfile/setup-workspace.sh). Details: [automation-whitepaper/guides/devspaces-workspace.md](automation-whitepaper/guides/devspaces-workspace.md).
