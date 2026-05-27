# Deliveries — shared automation collection

All **real** automation lives in **one** Ansible collection repository (not one repo per initiative):

```
<automation-home>/deliveries/automation/
```

Each new capability adds a **role** and **type playbook(s)** inside that collection — do not create a new Git repo per automation.

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

See [git-automation-repository.md](../automation-whitepaper/guides/git-automation-repository.md).

## Git submodule

`deliveries/automation/` is a **Git submodule** of the automation-home monorepo.

| Item | Value |
|------|--------|
| Remote | `git@github.com:automationiberia/ai-auto-deliveries.git` |
| GitHub | [automationiberia/ai-auto-deliveries](https://github.com/automationiberia/ai-auto-deliveries) |

After cloning the monorepo:

```bash
git submodule update --init deliveries/automation
```

Work on the collection inside the submodule (`cd deliveries/automation`), push to `origin`, then update the submodule pointer in the monorepo when you want to pin a new release.
