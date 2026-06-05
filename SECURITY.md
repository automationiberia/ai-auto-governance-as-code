# Security Policy

## Overview

This repository contains **governance documentation, AI agent skills, and reference examples** for Ansible automation. While it does not directly execute infrastructure automation, security practices are critical since:

- AI-generated automation code may be deployed to production environments
- Skills guide AI agents in creating privileged operations
- Examples demonstrate patterns that could be adapted for enterprise use
- Pre-commit hooks validate code that may access sensitive systems

## Supported Versions

| Version | Supported          | Notes |
| ------- | ------------------ | ----- |
| main    | :white_check_mark: | Current development branch |
| Released tags | :white_check_mark: | Stable versions with semantic versioning |

This project does not yet have formal releases. The `main` branch is the current stable version.

## Reporting a Vulnerability

### Where to Report

**Do NOT open a public GitHub issue for security vulnerabilities.**

Instead, report security issues privately:

1. **Email**: Contact the repository maintainers directly (check repository settings for security contact)
2. **GitHub Security Advisories**: Use the "Security" tab > "Report a vulnerability" (if available)

### What to Include

When reporting a vulnerability, please provide:

- **Description**: Clear explanation of the security issue
- **Impact**: What could an attacker achieve?
- **Affected components**: Which files, skills, or examples are impacted?
- **Reproduction steps**: How to demonstrate the vulnerability
- **Suggested fix**: If you have a remediation approach
- **Disclosure timeline**: Any constraints on public disclosure

### Response Timeline

- **Acknowledgment**: Within 48 hours of receipt
- **Initial assessment**: Within 5 business days
- **Fix timeline**: Depends on severity (see below)
- **Public disclosure**: Coordinated after fix is available

### Severity Levels

| Severity | Description | Response Time |
|----------|-------------|---------------|
| **Critical** | Leads to credential exposure, remote code execution in examples, or malicious AI-generated code | 24-48 hours |
| **High** | Security bypass in validation scripts, unsafe patterns in skills, or privilege escalation in examples | 5-7 days |
| **Medium** | Information disclosure, incomplete input validation, or weak cryptographic recommendations | 14-30 days |
| **Low** | Best practice violations, missing security controls in examples | 30-60 days |

## Security Considerations by Component

### 1. AI Agent Skills (`skills/`)

**Risks:**
- Skills that guide AI to generate insecure Ansible code
- Missing security validation instructions
- Overly permissive recommendations

**Mitigations:**
- Skills must reference secure patterns from white paper
- Include security checklist in task skills
- Recommend least-privilege access controls
- Mandate secret management (Ansible Vault, external secret managers)

**Examples of security issues:**
- Skill recommends storing passwords in plain text
- Missing validation for user input in Jinja2 templates
- Guidance to disable SSH host key checking
- Encouraging `become: yes` without justification

### 2. White Paper Documentation (`automation-whitepaper/`)

**Risks:**
- Insecure code patterns in examples
- Missing security guidance
- Outdated security recommendations

**Mitigations:**
- Security review for all code examples
- Explicit warnings for dangerous operations
- Reference current Ansible security best practices
- Document threat model for enterprise automation

**Examples of security issues:**
- Example hardcodes credentials
- Template injection vulnerability in examples
- Missing authentication in API calls
- Unsafe file permissions in configuration examples

### 3. Reference Examples (`automation-whitepaper/examples/`)

**Risks:**
- Examples adapted directly to production
- Test credentials committed to repository
- Unsafe defaults in playbooks

**Mitigations:**
- Clear warnings that examples are demonstrations
- Use placeholder values (e.g., `REPLACE_WITH_VAULT_SECRET`)
- Pre-commit hook blocks private keys and secrets
- Document hardening steps before production use

**Examples of security issues:**
- Private keys in example inventories
- Default/weak passwords in test fixtures
- Unsafe `shell` module usage
- Missing `no_log: true` for sensitive tasks

### 4. Pre-commit Hooks & Tooling

**Risks:**
- Hooks fail to detect security issues
- Malicious code in dependencies
- Insufficient validation coverage

**Mitigations:**
- `detect-private-key` hook enabled
- ansible-lint security rules active
- Regular dependency updates
- Lock file verification (future)

## Security Best Practices for Contributors

### When Contributing Skills

- [ ] Recommend `no_log: true` for sensitive tasks
- [ ] Encourage Ansible Vault or external secret management
- [ ] Validate that skills don't suggest disabling security features
- [ ] Include input validation guidance for Jinja2 templates
- [ ] Recommend least-privilege for `become` and `delegate_to`

### When Contributing Examples

- [ ] Never commit real credentials, tokens, or private keys
- [ ] Use `{{ vault_password }}` placeholders for secrets
- [ ] Document security assumptions and hardening steps
- [ ] Enable `no_log` for tasks handling secrets
- [ ] Use secure defaults (e.g., `validate_certs: true`)
- [ ] Document firewall and network access requirements

### When Contributing White Paper Documentation

- [ ] Security sections reviewed by maintainers
- [ ] No recommendations to disable security controls without justification
- [ ] Include threat modeling where relevant
- [ ] Reference current CVEs if discussing vulnerabilities
- [ ] Link to official Ansible security documentation

## Known Security Considerations

### AI-Generated Code Risks

AI agents may generate code based on training data that includes:
- Legacy patterns with known vulnerabilities
- Deprecated Ansible modules
- Insecure configurations

**Mitigation:**
- Skills encode current security best practices
- Pre-commit hooks validate generated code
- Examples demonstrate secure patterns
- Human review required before production deployment

### Dependency Security

This repository depends on:
- Ansible Core (2.15+)
- ansible-lint
- Python linting tools
- Git submodules (external repositories)

**Mitigation:**
- Regular updates via `requirements-dev.txt`
- Pre-commit hook version pinning
- Submodule integrity checks
- Future: Dependabot alerts

### Secrets in Git History

**Risk**: Committed secrets remain in Git history even after removal.

**Mitigation**:
- Pre-commit `detect-private-key` hook
- Regular git-secrets or Gitleaks scans (future)
- Documented secret rotation process if exposure occurs

## Incident Response

If a security vulnerability is confirmed:

1. **Containment**: Determine scope and affected versions
2. **Fix development**: Create patch in private branch
3. **Testing**: Validate fix does not introduce regressions
4. **Disclosure**: Coordinate public disclosure with reporter
5. **Release**: Merge fix and tag new version
6. **Notification**: Update SECURITY.md and notify users
7. **Post-mortem**: Document lessons learned

## Security Contacts

For urgent security issues, contact repository maintainers through:
- GitHub Security Advisories (preferred)
- Repository issue with `security` label (for non-critical issues)
- Direct email to maintainers (check repository settings)

## Additional Resources

- [Ansible Security Automation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_security.html)
- [OWASP Ansible Security Best Practices](https://owasp.org/)
- [Red Hat Ansible Security Guide](https://access.redhat.com/documentation/en-us/red_hat_ansible_automation_platform/)
- [CIS Benchmarks for Configuration Management](https://www.cisecurity.org/)

---

Last updated: 2026-06-01
