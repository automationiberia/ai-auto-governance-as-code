# Coding Style

Department coding standards aligned with GPA **Coding Style**. Agree early; expand gradually.

---

## 1. Naming

- Valid Python identifiers: `snake_case` for files, variables, keys
- No special characters in variable names (even if YAML allows)
- Descriptive names; pattern `object[_feature]_action` for roles/playbooks
- **No numbered** roles/playbooks (`web_01`)
- **Name every** task, play, block
- Task names: **imperative** ("Ensure service is started")
- Abbreviations: avoid, or use capitals for known acronyms

---

## 2. YAML and Jinja2

| Rule | Example |
|------|---------|
| Indent 2 spaces | Standard |
| List content indented | `  - item` under key |
| Booleans | `true` / `false` (not `yes`/`no`) |
| Module args | YAML dict, not `key=value` |
| Jinja spacing | `{{ variable }}` |
| File extension | `.yml` not `.yaml` |
| Quotes | Double for YAML strings; single inside Jinja strings |
| Long lines | `>-` folding; break `when:` lists |

---

## 3. Ansible-specific

- Idempotent tasks; prefer modules over `command`/`shell`
- Comment justification when `command`/`shell` required
- `when:` with bare vars: `| bool` filter
- Bracket notation: `__foo_entry['key']` not `__foo_entry.key` (loop/dict entries)
- Avoid `meta: end_play` (use `end_host`)
- Dynamic task names: variable at **end** of name string
- Do not override role params with `set_fact` same name
- Limit `set_fact` scope pollution
- Avoid `ignore_errors: true` on assert blocks
- Use `match`/`search`/`regex`, not Jinja2 `eq` test (EL7/Jinja 2.7)
- Prefer handlers over `when: result is changed`
- `package` module with full list, not loop per package
- In **roles**, use `loop_control.loop_var` with `__` prefixed names; do not use default `item`
- Meta modules: `service`, `package` when sufficient
- Avoid `lineinfile` when `template`, `ini_file`, or dedicated module fits
- Templates: suffix `.j2`; `template` over `copy` for config files

---

## 4. Line length

Target **≤ 82** characters (ansible-lint default). Techniques:

- YAML `>-` for long strings
- Multi-line Jinja in `when:` without `{{ }}` wrapper
- Backslash continuation in double-quoted URLs

---

## 5. Tooling

- **`pre-commit` mandatory** — install via `requirements-dev.txt`; hooks at repo root (see [../quality/pre-commit.md](../quality/pre-commit.md))
- `ansible-lint` in pre-commit and CI (department profile: [`.ansible-lint`](../.ansible-lint))
- `yamllint` in pre-commit ([`.yamllint`](../.yamllint))
- `ansible-playbook --syntax-check` on all playbooks

---

## 6. Related documents

- [../quality/code-review-and-linting.md](../quality/code-review-and-linting.md)
- [roles.md](roles.md)
