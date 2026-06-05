# Changelog

All notable changes to the ai-auto-skills governance monorepo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `CONTRIBUTING.md` with comprehensive contribution guidelines covering white paper, skills, and examples
- `SECURITY.md` with vulnerability reporting process and security considerations
- `Makefile` providing common tasks: setup, validate, test, clean, info
- GitHub Actions CI workflow (`.github/workflows/ci.yml`) with:
  - Pre-commit hooks validation
  - YAML and Ansible linting
  - SKILL.md structure validation
  - Documentation checks
  - Python code validation
  - Security scanning for secrets and private keys
- GitHub issue templates for bugs, features, and skill updates
- GitHub pull request template with white paper alignment checklist
- Issue template configuration linking to discussions and security advisories

### Changed

- Reorganized `README.md` with visual hierarchy, quick start section, and repository structure overview
- Shortened and enhanced `skills/README.md` with clearer mode distinctions and consolidated task skills
- Improved `automation-whitepaper/README.md` with quick navigation table and grouped sections
- Streamlined `automation-whitepaper/examples/README.md` with concise validation section
- Overall README content reduced by 27 lines while improving clarity and navigation

## [0.1.0] - 2026-05-31

### Added

- Initial AI-Driven Governance-as-Code layer
- Tool-agnostic agent documentation (AGENTS.md)
- White paper foundation (automation-whitepaper/)
- AI Agent Skills catalog (skills/)
- Reference examples: light-dev-packages, standard-rsyslog-forwarding
- Git submodule integration for automation-good-practices
- Git submodule integration for deliveries/automation
- Pre-commit configuration with ansible-lint, yamllint, black, pylint
- Dev Spaces support with .devfile.yaml
- Operating modes: Auditor, Architect, Librarian

[Unreleased]: https://github.com/your-org/ai-auto-skills/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/your-org/ai-auto-skills/releases/tag/v0.1.0
