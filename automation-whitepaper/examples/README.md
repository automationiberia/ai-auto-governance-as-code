# Reference Examples

> Runnable Ansible code demonstrating white paper patterns. Copy into `$AUTOMATION_REPO` for real delivery.

## 📦 Available Examples

| Profile | Code | Walkthrough |
|---------|------|-------------|
| **Light** | [light-dev-packages/](light-dev-packages/) | [Walkthrough](example-light-walkthrough-dev-packages.md) |
| **Standard** | [standard-rsyslog-forwarding/](standard-rsyslog-forwarding/) | [Walkthrough](example-complete-walkthrough-rsyslog-forwarding.md) |

## ✅ Validation

All examples pass `ansible-playbook --syntax-check` and `ansible-lint`.

```bash
# Validate Light example
cd $AUTOMATION_HOME/automation-whitepaper/examples/light-dev-packages
ansible-playbook --syntax-check playbooks/type_dev_linux.yml

# Validate Standard example
cd $AUTOMATION_HOME/automation-whitepaper/examples/standard-rsyslog-forwarding
ansible-playbook --syntax-check playbooks/type_linux_logging.yml
```

## 📂 Environment

```bash
export AUTOMATION_HOME=/path/to/ai-auto-skills
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

See [git-automation-repository.md](../guides/git-automation-repository.md) for workflow.
