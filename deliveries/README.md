# Deliveries — shared automation collection

Git submodule inside the **`ai-auto-skills`** governance monorepo. Production **roles** and **type playbooks** live here — separate from the white book and Agent Skills.

| Item | Value |
|------|--------|
| Submodule path | `deliveries/automation/` |
| Remote (fixed) | `git@github.com:automationiberia/ai-auto-deliveries.git` |
| GitHub | [automationiberia/ai-auto-deliveries](https://github.com/automationiberia/ai-auto-deliveries) |

**Do not change** the `url` for `deliveries/automation` in [`.gitmodules`](../.gitmodules). This monorepo is wired to that repository; a different URL causes submodule clone/update to fail.

Monorepo overview: [architecture/monorepo-layout.md](../automation-whitepaper/architecture/monorepo-layout.md).

---

All automation for a capability set lives in **one** collection (not one Git repository per initiative):

```
<automation-home>/deliveries/automation/
```

Each new capability adds a **role** and **type playbook(s)** — do not create a new Git repo per automation.

```bash
export AUTOMATION_HOME=/path/to/this/repository
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

See [git-automation-repository.md](../automation-whitepaper/guides/git-automation-repository.md).

## After clone

```bash
git submodule update --init deliveries/automation
```

Configure Git/SSH credentials for `automationiberia/ai-auto-deliveries` before clone or run `bash .devfile/setup-workspace.sh` after adding credentials.

Work inside the submodule (`cd deliveries/automation`), push to `origin`, then update the submodule pointer in **`ai-auto-skills`** when pinning a release.
