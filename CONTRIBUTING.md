# Contributing to ai-auto-governance-as-code

Thank you for your interest in contributing to the AI-Driven Governance-as-Code for Ansible Automation project!

This repository implements a **governance monorepo** with AI Agent Skills that encode Ansible automation standards. Contributions help improve the white paper documentation, agent skills, and reference implementations.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Contribution Types](#contribution-types)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project adheres to professional standards of collaboration. Be respectful, constructive, and focused on improving the automation governance framework.

## Getting Started

### Prerequisites

- Git with SSH access to required submodules
- Python 3.12+
- Ansible Core 2.15+
- pre-commit 3.5.0+

### Initial Setup

```bash
git clone --recurse-submodules https://github.com/automationiberia/ai-auto-governance-as-code.git
cd ai-auto-governance-as-code
make install
pre-commit install
```

Set environment variables:

```bash
export AUTOMATION_HOME=$(pwd)
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

See [README.md](README.md) for full setup instructions.

## How to Contribute

### Reporting Issues

- Use GitHub Issues for bugs, feature requests, or documentation improvements
- Check existing issues before creating duplicates
- Provide clear descriptions with reproduction steps for bugs
- Tag issues appropriately (bug, enhancement, documentation, skill-update)

### Suggesting Enhancements

- Open an issue describing the enhancement
- Explain the use case and expected benefits
- Reference specific white paper sections or skills affected
- Consider whether it aligns with the [three operating modes](AGENTS.md#three-operating-modes)

## Contribution Types

### 1. White Paper Documentation (`automation-whitepaper/`)

The **authoritative source** for Ansible automation standards.

**When to contribute:**
- New architectural patterns adopted
- Quality gate improvements
- Lifecycle process updates
- Example walkthroughs

**Process:**
1. Update markdown in `automation-whitepaper/`
2. Ensure cross-references remain valid
3. Update related skills (see below)
4. Add examples if appropriate

### 2. Agent Skills (`gac/gac-*/module/skills/`)

AI-consumable **translation** of white paper standards into `SKILL.md` files. Skills encode human rules; they do not replace the white book.

**When to contribute:**
- White paper changes require skill updates
- New task skills needed
- Operating mode refinements

**Process:**
1. Update **white paper** first ([ADR-004](automation-whitepaper/adrs/ADR-004-librarian-synchronization.md))
2. Read [gac/README.md](gac/README.md), [gac/SKILL_GUIDELINES.md](gac/SKILL_GUIDELINES.md), and [AGENTS.md](AGENTS.md)
3. Create or update `gac/gac-<category>/module/skills/<name>/SKILL.md`
4. Keep skills under ~500 lines
5. Update [gac/README.md](gac/README.md) catalog
6. `lola install gac -a <assistant>` to refresh local assistant

### 3. Reference Examples (`automation-whitepaper/examples/`)

Runnable implementations demonstrating patterns.

**Profiles:**
- **Light**: Simple, single-role examples
- **Standard**: Production-grade with full lifecycle
- **Heavy**: Complex multi-role scenarios

**Process:**
1. Create under `automation-whitepaper/examples/<profile>-<name>/`
2. Include complete role/playbook structure
3. Add walkthrough documentation
4. Ensure ansible-lint and pre-commit pass
5. Use `$AUTOMATION_HOME` and `$AUTOMATION_REPO` variables

### 4. Tooling & Scripts

**Accepted contributions:**
- Validation scripts for skills or white paper consistency
- Setup automation improvements
- CI/CD enhancements
- Developer experience tools

**Not accepted:**
- Changes to submodule URLs in `.gitmodules` (`automation-good-practices`, `deliveries/automation`, `aap-skills-library`, `ai-forge`)
- Hardcoded absolute paths (use `$AUTOMATION_HOME`)

## Development Workflow

### Branch Strategy

- **`main`**: Stable, production-ready
- **Feature branches**: `feature/<description>`
- **Bug fixes**: `fix/<description>`
- **Documentation**: `docs/<description>`
- **Skills**: `skill/<skill-name>`

### Making Changes

1. **Create a branch**
   ```bash
   git checkout -b feature/my-improvement
   ```

2. **Make focused changes**
   - One logical change per commit
   - Keep commits atomic and reversible

3. **Test your changes**
   ```bash
   # Run pre-commit hooks
   pre-commit run --all-files

   # Validate YAML syntax
   ansible-playbook --syntax-check <playbook>.yml

   # Test in examples
   cd automation-whitepaper/examples/<example>/
   ansible-playbook playbooks/type_<category>.yml --check
   ```

4. **Commit with clear messages**
   ```bash
   git commit -m "Add automation-testing skill for Molecule integration"
   ```

### Commit Message Guidelines

Use imperative mood and be specific:

✅ **Good:**
- `Add automation-testing skill for Molecule integration`
- `Fix loop variable naming in rsyslog example`
- `Update architecture docs for execution environments`

❌ **Avoid:**
- `Updated stuff`
- `WIP`
- `Fixed bug`

## Style Guidelines

### Markdown

- Use ATX-style headers (`#`, `##`, not underlines)
- One sentence per line for version control clarity
- Code blocks must specify language
- Internal links use relative paths
- Use `$AUTOMATION_HOME` and `$AUTOMATION_REPO` for paths

### YAML/Ansible

All Ansible code must follow [automation-whitepaper/quality/](automation-whitepaper/quality/) standards:

- **FQCN**: Always use fully qualified collection names
  ```yaml
  # Good
  - name: Install package
    ansible.builtin.package:
      name: httpd

  # Bad
  - name: Install package
    package:
      name: httpd
  ```

- **Naming conventions**:
  - `snake_case` for all identifiers
  - `rolename_*` for public role variables
  - `_…` for internal variables (single leading underscore)
  - `__rolename_…` for `loop_control.loop_var` in roles
  - Imperative task names

- **Loop variables**:
  ```yaml
  # Good
  - name: Process items
    ansible.builtin.debug:
      msg: "{{ __rolename_item }}"
    loop: "{{ rolename_list }}"
    loop_control:
      loop_var: __rolename_item

  # Bad - bare 'item'
  - name: Process items
    ansible.builtin.debug:
      msg: "{{ item }}"
    loop: "{{ myfunction_list }}"
  ```

- **No legacy syntax**: Use `loop`, not `with_items` or `with_dict`

### Python

- Black formatting (line length 88)
- Pylint compliance
- Type hints preferred
- Docstrings for public functions

### Pre-commit Hooks

All commits must pass:
- `trailing-whitespace`
- `end-of-file-fixer`
- `check-yaml`
- `black` (Python)
- `pylint` (Python)
- `ansible-lint` (YAML in whitepaper)
- `yamllint`

## Pull Request Process

### Before Submitting

- [ ] Changes pass `pre-commit run --all-files`
- [ ] Documentation updated (white paper and/or skills)
- [ ] Examples tested if code changes included
- [ ] Commit messages are clear and descriptive
- [ ] Branch is up to date with `main`

### PR Requirements

1. **Title**: Clear, imperative summary (e.g., "Add Molecule testing skill")

2. **Description**: Include:
   - **Context**: Why is this change needed?
   - **Changes**: What was modified?
   - **Testing**: How was it validated?
   - **Impact**: What skills/docs/examples are affected?

3. **Link related issues**: Use `Fixes #123` or `Relates to #456`

4. **Request reviews**: Tag relevant maintainers

### Review Process

- Maintainers will review for:
  - Alignment with white paper standards
  - Skill-to-documentation consistency
  - Code quality and style compliance
  - Example completeness
  - Breaking changes flagged

- Address feedback with additional commits
- Squashing commits is not required (maintainers will squash on merge)

### After Approval

- Maintainers will merge when ready
- Delete your feature branch after merge

## Operating Modes (for Skill Contributors)

When contributing skills, understand the [three operating modes](AGENTS.md):

| Mode | Purpose | Skill Type |
|------|---------|------------|
| **1 — Auditor** | Retroactive review of existing code | Refactoring, debt scanning |
| **2 — Builder** | Proactive creation of new automation | Bootstrap, generate from scratch |
| **3 — Librarian** | Maintain governance layer | Sync skills with white paper |

Skills should declare which mode they support and provide mode-specific instructions.

## Questions?

- **General questions**: Open a GitHub Discussion
- **Bugs**: Create an issue with the `bug` label
- **Feature requests**: Create an issue with the `enhancement` label
- **Skill development**: Review [skills/TOOL-SETUP.md](skills/TOOL-SETUP.md)
- **White paper**: See [automation-whitepaper/README.md](automation-whitepaper/README.md)

## Additional Resources

- [AGENTS.md](AGENTS.md) - AI agent operating instructions
- [gac/README.md](gac/README.md) - Skill catalog and setup
- [automation-whitepaper/guides/ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md) - Prompt examples
- [Red Hat CoP Automation Good Practices](https://github.com/redhat-cop/automation-good-practices) - Pinned CoP baseline (`automation-good-practices/` submodule)
- [Ansible Community AI Forge](https://github.com/ansible-community/ai-forge) - SDLC skills consumed via Lola

---

Thank you for contributing to AI-driven Ansible governance!
