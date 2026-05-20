# Runnable examples

Reference trees for walkthroughs. **Real delivery code** lives in the shared collection `deliveries/automation/`; copy example patterns into new roles there.

| Profile | Walkthrough | Reference code |
|---------|-------------|----------------|
| Light | [example-light-walkthrough-dev-packages.md](example-light-walkthrough-dev-packages.md) | [light-dev-packages/](light-dev-packages/) |
| Standard | [example-complete-walkthrough-rsyslog-forwarding.md](example-complete-walkthrough-rsyslog-forwarding.md) | [standard-rsyslog-forwarding/](standard-rsyslog-forwarding/) |

## Path conventions

| Symbol | Meaning |
|--------|---------|
| `<automation-home>` | Department standards repo |
| `<automation-repo>` | **`deliveries/automation/`** — shared Ansible collection |

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

Git flow: [git-automation-repository.md](../guides/git-automation-repository.md).

## Verify reference examples

From `<automation-home>` with `ansible-core` and dev requirements installed:

```bash
# Light
cd "$AUTOMATION_HOME/automation-whitepaper/examples/light-dev-packages"
ansible-playbook --syntax-check playbooks/type_dev_linux.yml

# Standard
cd "$AUTOMATION_HOME/automation-whitepaper/examples/standard-rsyslog-forwarding"
ansible-playbook --syntax-check playbooks/type_linux_logging.yml
```

Each tree includes `ansible.cfg` with `roles_path = roles`.

**Last verified** (syntax-check + `ansible-lint` production profile on `playbooks/` and `roles/`):

| Example | Syntax-check | ansible-lint |
|---------|--------------|--------------|
| `light-dev-packages` | Pass | Pass |
| `standard-rsyslog-forwarding` | Pass | Pass |

Host pattern warnings during `--syntax-check` without a live inventory are expected.
