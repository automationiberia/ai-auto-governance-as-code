# Pre-commit Hooks Guide

This guide explains how to set up and use pre-commit hooks for this repository.

## What are Pre-commit Hooks?

Pre-commit hooks are automated checks that run before you commit code. They help catch issues early:
- Trailing whitespace
- YAML syntax errors
- Python formatting issues
- Ansible lint violations
- Security vulnerabilities (private keys, secrets)

## Quick Start

### 1. Install Dependencies

```bash
# From the repository root
pip install -r requirements-dev.txt
```

This installs:
- `pre-commit` - Hook framework
- `ansible-lint` - Ansible best practices
- `yamllint` - YAML linting
- `black` - Python formatter
- `pylint` - Python linter

### 2. Install Pre-commit Hooks

```bash
pre-commit install
```

This sets up git hooks that run automatically before each commit.

## Usage

### Automatic (Recommended)

Once installed, hooks run automatically when you commit:

```bash
git add .
git commit -m "Your commit message"
```

If any hook fails:
- The commit is **blocked**
- Issues are displayed in the terminal
- Some hooks **auto-fix** issues (trailing whitespace, end-of-file)
- Review changes and commit again

### Manual Execution

Run hooks manually on all files:

```bash
pre-commit run --all-files
```

Run a specific hook:

```bash
pre-commit run trailing-whitespace --all-files
pre-commit run yamllint --all-files
pre-commit run ansible-lint --all-files
```

Run on specific files:

```bash
pre-commit run --files path/to/file.yml
```

## Common Hooks in This Repository

### 1. Trailing Whitespace
**Auto-fixes:** ✅ Yes

Removes trailing spaces at the end of lines.

```bash
# Run manually
pre-commit run trailing-whitespace --all-files
```

### 2. End of File Fixer
**Auto-fixes:** ✅ Yes

Ensures files end with a newline.

### 3. YAML Check
**Auto-fixes:** ❌ No

Validates YAML syntax.

**Fix manually:** Check the error message for line/column numbers.

### 4. YAMLLint
**Auto-fixes:** ❌ No

Enforces YAML style rules (line length, indentation, etc.).

Configuration: `automation-whitepaper/.yamllint`

**Common issues:**
- Line too long (max 82 characters)
- Too many spaces in brackets
- Use `true`/`false` instead of `yes`/`no`

**Fix example:**
```yaml
# ❌ Bad (line too long)
- label: This is a very long label that exceeds the maximum line length limit

# ✅ Good (use YAML multiline)
- label: >-
    This is a very long label that exceeds
    the maximum line length limit
```

### 5. Ansible-lint
**Auto-fixes:** ❌ No (some rules)

Validates Ansible best practices.

Configuration: `automation-whitepaper/.ansible-lint`

**Common issues:**
- Missing FQCN (use `ansible.builtin.copy` not `copy`)
- Use `true`/`false` not `yes`/`no`
- Missing `name:` on tasks

### 6. Black (Python)
**Auto-fixes:** ✅ Yes (with `--all-files`)

Formats Python code.

```bash
# Check formatting
black --check .

# Auto-format
black .
```

### 7. Pylint (Python)
**Auto-fixes:** ❌ No

Python code quality checks.

Configuration: `pyproject.toml`

### 8. Detect Private Key
**Auto-fixes:** ❌ No

Prevents committing private keys.

**Excluded directories:**
- `.github/workflows/` (contains grep patterns)

## Troubleshooting

### Hook Installation Failed

```bash
# Update pre-commit
pip install --upgrade pre-commit

# Clean and reinstall
pre-commit clean
pre-commit install
```

### Hooks Not Running

```bash
# Verify installation
pre-commit --version

# Check if hooks are installed
ls -la .git/hooks/pre-commit

# Reinstall
pre-commit install
```

### Skip Hooks (Emergency Only)

```bash
# Skip all hooks (NOT RECOMMENDED)
git commit --no-verify -m "Emergency commit"
```

⚠️ **Warning:** Only use `--no-verify` in emergencies. CI will still catch issues.

### Update Hooks

```bash
# Update to latest versions
pre-commit autoupdate
```

### Clear Cache

```bash
# Clear pre-commit cache
pre-commit clean
```

## CI Integration

GitHub Actions runs the same hooks on every push and PR:

- **Pre-commit job:** Runs `pre-commit run --all-files`
- **YAML validation:** Additional yamllint and ansible-lint checks
- **Python validation:** Black and pylint

**Local pre-commit passes = CI passes** ✅

## Configuration Files

- `.pre-commit-config.yaml` - Hook definitions and versions
- `automation-whitepaper/.yamllint` - YAMLLint rules
- `automation-whitepaper/.ansible-lint` - Ansible-lint rules
- `pyproject.toml` - Python tooling (black, pylint)
- `requirements-dev.txt` - Development dependencies

## Best Practices

1. **Run before pushing:**
   ```bash
   pre-commit run --all-files
   ```

2. **Fix auto-fixable issues first:**
   - Trailing whitespace
   - End-of-file fixes
   - Black formatting

3. **Review manual fixes carefully:**
   - YAMLLint suggestions
   - Ansible-lint recommendations

4. **Don't skip hooks unless absolutely necessary**

5. **Update hooks periodically:**
   ```bash
   pre-commit autoupdate
   ```

## Getting Help

- Check error messages carefully - they usually indicate the exact issue
- Review the configuration files for rule details
- See `CONTRIBUTING.md` for contribution guidelines
- Open an issue if you encounter persistent problems

## Quick Reference

```bash
# Install
pip install -r requirements-dev.txt
pre-commit install

# Run all hooks
pre-commit run --all-files

# Run specific hook
pre-commit run <hook-id> --all-files

# Update hooks
pre-commit autoupdate

# Skip (emergency)
git commit --no-verify

# Uninstall
pre-commit uninstall
```
