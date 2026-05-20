# Light Walkthrough: Dev Lab Troubleshooting Packages

Minimal process for **lab-only** automation. Compare with the **standard** walkthrough: [example-complete-walkthrough-rsyslog-forwarding.md](example-complete-walkthrough-rsyslog-forwarding.md).

**Reference code (verified):** [light-dev-packages/](light-dev-packages/) — copy into `<automation-repo>`; do not edit the reference tree for delivery.

| Field | Value |
|-------|-------|
| Profile | **Light** |
| Backlog | DEV-127 (no ITSM/CAB) |
| Branch | `feature/DEV-127-dev-troubleshoot-packages` |
| `<automation-repo>` | `deliveries/automation` (shared collection; add role `dev_troubleshoot_packages`) |

**Goal:** Ensure `jq`, `vim-enhanced`, and `policycoreutils-python-utils` are installed on developer lab VMs.

Paths: [examples/README.md](README.md) · Git: [git-automation-repository.md](../guides/git-automation-repository.md).

---

## What we skip (light vs standard)

| Step (guide) | Standard (rsyslog) | Light (this example) |
|--------------|-------------------|----------------------|
| Git | New repo `linux-logging-rsyslog` | New repo `lab-troubleshoot-packages` |
| ITSM ticket | ITSM-4521 | Backlog DEV-127 |
| Stakeholders | Ops, Security, CAB, CMDB | None |
| CAB / CMDB | Yes | **Skipped** |
| Molecule | Optional later | **Skipped** |

**Gates:** `git init` in `<automation-repo>`, `pre-commit`, idempotency, peer review.

---

## 1. Set up (tooling)

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
python3 -m venv "$AUTOMATION_HOME/.venv" && source "$AUTOMATION_HOME/.venv/bin/activate"
pip install -r "$AUTOMATION_HOME/requirements-dev.txt"
```

- [ ] §1 complete

---

## 2. New Git repository (default)

```bash
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
mkdir -p "$AUTOMATION_REPO" && cd "$AUTOMATION_REPO"
git init -b main

cp "$AUTOMATION_HOME/automation-whitepaper/templates/automation-repo.gitignore" .gitignore
cp "$AUTOMATION_HOME/automation-whitepaper/templates/automation-repo.pre-commit-config.yaml" .pre-commit-config.yaml
cp "$AUTOMATION_HOME/automation-whitepaper/.ansible-lint" .
cp "$AUTOMATION_HOME/automation-whitepaper/.yamllint" .

git add .gitignore .pre-commit-config.yaml .ansible-lint .yamllint
git commit -m "chore: initialize lab automation repository"
pre-commit install
```

Copy reference layout:

```bash
cp -r "$AUTOMATION_HOME/automation-whitepaper/examples/light-dev-packages/"* "$AUTOMATION_REPO/"
# includes ansible.cfg, playbooks/, roles/, inventory/
```

- [ ] §2 complete

*Optional:* add to existing team repo → [git-automation-repository.md § Optional](../guides/git-automation-repository.md#optional-add-to-an-existing-git-repository).

---

## 3. Intake

**Backlog DEV-127:** Lab VMs missing `jq` and SELinux utils — install standard packages on `dev_linux`.

- [ ] §3 complete

---

## 4. Design note

- **Type:** [playbooks/type_dev_linux.yml](light-dev-packages/playbooks/type_dev_linux.yml)
- **Function:** [roles/dev_troubleshoot_packages/](light-dev-packages/roles/dev_troubleshoot_packages/)
- **Vars:** [inventory/lab/group_vars/dev_linux/dev_troubleshoot_packages.yml](light-dev-packages/inventory/lab/group_vars/dev_linux/dev_troubleshoot_packages.yml)

- [ ] §4 complete

---

## 5. Build

```bash
cd "$AUTOMATION_REPO"
git checkout -b feature/DEV-127-dev-troubleshoot-packages
```

| File | Link |
|------|------|
| Playbook | [playbooks/type_dev_linux.yml](light-dev-packages/playbooks/type_dev_linux.yml) |
| Role | [roles/dev_troubleshoot_packages/](light-dev-packages/roles/dev_troubleshoot_packages/) |
| Config | [ansible.cfg](light-dev-packages/ansible.cfg) |

- [ ] §5 complete

---

## 6. Verify locally

```bash
cd "$AUTOMATION_REPO"
ansible-playbook --syntax-check playbooks/type_dev_linux.yml
pre-commit run --all-files
ansible-playbook -i inventory/lab playbooks/type_dev_linux.yml --check
```

- [ ] §6 complete

---

## 7. Ship

- [ ] PR on `<automation-repo>` remote; CAB skipped

- [ ] §7 complete

---

## 8. Operate

Wiki: add host to `dev_linux` in inventory; run type playbook from `<automation-repo>`.

- [ ] §8 complete

---

## Related

- [create-new-automation-step-by-step.md](../guides/create-new-automation-step-by-step.md)
- [example-complete-walkthrough-rsyslog-forwarding.md](example-complete-walkthrough-rsyslog-forwarding.md)
