# Idempotency and Check Mode

---

## 1. Definitions

| Term | Meaning |
|------|---------|
| **Idempotency** | Second application with same parameters produces no changes and reports `changed: false` |
| **Check mode** | Dry-run; detects changes without applying (where modules support it) |

---

## 2. Why it matters

- **Change tickets** and integrations rely on accurate change reporting
- **Operations** trust scheduled jobs not to flap
- **CAB** expects predictable production behavior

---

## 3. Requirements

| Requirement | Detail |
|-------------|--------|
| First run check mode | Should not fail; should not false-positive `changed` |
| Second normal run | No changes |
| `command` / `shell` | `changed_when:`; prefer module |
| Registered vars in check mode | Guard with idempotent fact-gathering or `check_mode:` on task |
| Dry-run commands | Use `--dry-run` flags when available + correct `changed_when` |

Document justified exceptions in role README (e.g. first-run package install edge case).

---

## 4. Common fixes

| Problem | Approach |
|---------|----------|
| `command: cat file` | Use `slurp` + decode |
| Command always changed | Parse output; `changed_when: output != expected` |
| Package install in check mode | Document two-pass requirement or use `check_mode: false` on bootstrap with care |
| Template with timestamp | Remove dynamic dates from templates |

---

## 5. Testing

```bash
# Check mode
ansible-playbook -i inventory/ site.yml --check

# Idempotency (second run should show 0 changed)
ansible-playbook -i inventory/ site.yml
ansible-playbook -i inventory/ site.yml
```

Include in Molecule `idempotence` scenario where applicable.

---

## 6. Related documents

- [../development/roles.md](../development/roles.md)
- [code-review-and-linting.md](code-review-and-linting.md)
