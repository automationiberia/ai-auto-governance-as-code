# Plugins — Development Standards

For custom modules, filters, lookups, and other plugins (GPA **Plugins**).

---

## 1. When to use plugins

| Need | Prefer |
|------|--------|
| Transform structured data | Python **filter** plugin |
| Complex CLI not in module | **Module** with proper argspec |
| Long Jinja generating JSON | Filter or module—not Jinja |

---

## 2. Python standards

- Follow Ansible module development guide and **PEP 8**
- **pytest** for unit tests (not unittest)
- **Sphinx/reST** docstrings on public functions
- **Type hints** (Python 3.5+) for maintainability
- Scaffold with [ansible.plugin_builder](https://github.com/ansible-community/ansible.plugin_builder)

---

## 3. Structure

- Keep plugin entry files **minimal**
- Shared logic in `module_utils/` or `plugin_utils/`
- Consistent argspec style within a collection (single dict vs composed dicts—pick one)

---

## 4. Errors and verbosity

Use `module.fail_json(msg='specific reason')`—not generic "Failed!".

Use `Display().vvvv()` for diagnostic output at high verbosity.

Document all parameters and return values per Ansible plugin documentation standards.

---

## 5. Related documents

- [coding-style.md](coding-style.md)
- [../quality/code-review-and-linting.md](../quality/code-review-and-linting.md)
