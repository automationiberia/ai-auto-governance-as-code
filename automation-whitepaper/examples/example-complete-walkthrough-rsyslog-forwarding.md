# Complete Walkthrough: Central Rsyslog Forwarding

**Profile:** **standard** (production, shared collection).

Applies [create-new-automation-step-by-step.md](../guides/create-new-automation-step-by-step.md).  
**Light** contrast: [example-light-walkthrough-dev-packages.md](example-light-walkthrough-dev-packages.md).

**Reference code (verified):** [standard-rsyslog-forwarding/](standard-rsyslog-forwarding/) — copy into `<automation-repo>`.

| Field | Value |
|-------|-------|
| Ticket | ITSM-4521 |
| Branch | `feature/ITSM-4521-rsyslog-forward` |
| `<automation-repo>` | `deliveries/automation` (shared collection; add role `rsyslog_forward`) |
| Collection name | `company.linux` (in [galaxy.yml](standard-rsyslog-forwarding/galaxy.yml)) |

Paths: [examples/README.md](README.md) · Git: [git-automation-repository.md](../guides/git-automation-repository.md).

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
git commit -m "chore: initialize linux logging automation repository"
pre-commit install

cp -r "$AUTOMATION_HOME/automation-whitepaper/examples/standard-rsyslog-forwarding/"* "$AUTOMATION_REPO/"
```

- [ ] §2 complete

*Optional:* extend an existing monorepo → [git-automation-repository.md § Optional](../guides/git-automation-repository.md#optional-add-to-an-existing-git-repository).

---

## 3. Intake

**ITSM-4521:** Repeatable rsyslog forwarding to SIEM on RHEL 8/9 (~800 hosts). Profile **standard**.

- [ ] §3 complete

---

## 4. Design note

| Level | Reference |
|-------|-----------|
| Type playbook | [playbooks/type_linux_logging.yml](standard-rsyslog-forwarding/playbooks/type_linux_logging.yml) |
| Function role | [roles/rsyslog_forward/](standard-rsyslog-forwarding/roles/rsyslog_forward/) |
| Inventory To-Be | [inventory/sample/group_vars/all/rsyslog_forward.yml](standard-rsyslog-forwarding/inventory/sample/group_vars/all/rsyslog_forward.yml) |

- [ ] §4 complete

---

## 5. Build

```bash
cd "$AUTOMATION_REPO"
git checkout -b feature/ITSM-4521-rsyslog-forward
```

### File index

| Area | Files |
|------|-------|
| Collection | [galaxy.yml](standard-rsyslog-forwarding/galaxy.yml) |
| Playbook | [playbooks/type_linux_logging.yml](standard-rsyslog-forwarding/playbooks/type_linux_logging.yml) |
| Role | [roles/rsyslog_forward/](standard-rsyslog-forwarding/roles/rsyslog_forward/) |
| Ansible config | [ansible.cfg](standard-rsyslog-forwarding/ansible.cfg) |
| Inventory | [inventory/sample/](standard-rsyslog-forwarding/inventory/sample/) |

- [ ] §5 complete

---

## 6. Verify locally

```bash
cd "$AUTOMATION_REPO"
ansible-playbook --syntax-check playbooks/type_linux_logging.yml
pre-commit run --all-files
ansible-playbook -i inventory/sample playbooks/type_linux_logging.yml --check
```

- [ ] §6 complete

---

## 7. Ship

| Step | Result |
|------|--------|
| PR on `<automation-repo>` | Merged after review + CAB |
| Release tag | `1.2.0` per [galaxy.yml](standard-rsyslog-forwarding/galaxy.yml) |
| Controller | Job template points at this repo's playbook |

- [ ] §7 complete

---

## 8. Operate

- Weekly drift job; Controller failure → NOC

- [ ] §8 complete

---

## Guide index

| Guide § | Section |
|---------|---------|
| 1–8 | §1–§8 above |

---

## Related

- [create-new-automation-step-by-step.md](../guides/create-new-automation-step-by-step.md)
- [example-light-walkthrough-dev-packages.md](example-light-walkthrough-dev-packages.md)
