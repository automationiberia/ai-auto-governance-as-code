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

`deliveries/automation/` is a **separate Git repository** (submodule of the automation-home monorepo). It is local-only until you add a remote; the monorepo `.gitmodules` entry uses a placeholder URL:

`git@github.com:REPLACE_ME/deliveries-automation.git`

Replace `REPLACE_ME` with your organisation when the collection repo is created, then run `git submodule sync` from the monorepo root.
