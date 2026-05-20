# Automation home (monorepo)

Department automation standards, white paper, skills, and delivery collection layout.

| Path | Git |
|------|-----|
| `automation-whitepaper/` | Tracked in this repo |
| `skills/` | Tracked in this repo |
| `automation-good-practices/` | **Submodule** — [redhat-cop/automation-good-practices](https://github.com/redhat-cop/automation-good-practices) |
| `deliveries/automation/` | **Submodule** — independent delivery collection (URL placeholder until published) |

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

## Clone with submodules

```bash
git clone --recurse-submodules <automation-home-url>
# or after clone:
git submodule update --init --recursive
```

## Delivery collection remote

When `deliveries/automation` is published to its own Git server, set the URL in `.gitmodules` and in the submodule:

```bash
git -C deliveries/automation remote set-url origin git@github.com:YOUR_ORG/deliveries-automation.git
git submodule sync deliveries/automation
```

Then commit the `.gitmodules` URL change in this monorepo.
