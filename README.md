# Automation home (monorepo)

Department automation standards, white paper, skills, and delivery collection layout.

| Path | Git |
|------|-----|
| `automation-whitepaper/` | Tracked in this repo |
| `skills/` | Tracked in this repo |
| `automation-good-practices/` | **Submodule** — [redhat-cop/automation-good-practices](https://github.com/redhat-cop/automation-good-practices) |
| `deliveries/automation/` | **Submodule** — [automationiberia/ai-auto-deliveries](https://github.com/automationiberia/ai-auto-deliveries) |

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

## OpenShift Dev Spaces

Import this repository in **Dev Spaces**; it uses [`.devfile.yaml`](.devfile.yaml) and opens [`automation-home.code-workspace`](automation-home.code-workspace).

On first start, `setup-workspace` initializes submodules, installs `requirements-dev.txt`, and configures pre-commit. See [automation-whitepaper/guides/devspaces-workspace.md](automation-whitepaper/guides/devspaces-workspace.md).

---

## Clone with submodules

```bash
git clone --recurse-submodules <automation-home-url>
# or after clone:
git submodule update --init --recursive
```

## Delivery collection submodule

Remote: `git@github.com:automationiberia/ai-auto-deliveries.git` (path `deliveries/automation/`).

```bash
git submodule sync deliveries/automation
git -C deliveries/automation pull origin main
```
