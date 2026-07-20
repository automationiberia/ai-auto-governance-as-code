# Changelog

All notable changes to the ai-auto-governance-as-code governance monorepo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Dev Spaces: enforce Python ≥ 3.13 for `.venv` / `lola-ai` via `uv` when the image ships 3.12
- Guide-first governance alignment: [whitebook-folder-map.md](automation-whitepaper/governance/whitebook-folder-map.md), optional [adrs/](automation-whitepaper/adrs/README.md) with example ADR-001…006
- Manual operating path documented alongside AI modes (Auditor / Builder / Librarian)
- Four-tier rule of precedence (CoP → white book → skills → mechanical gates)

### Changed

- `.devfile.yaml` / `base.yaml` / `with-ollama.yaml`: `PYTHON_MIN_VERSION=3.13`, `UV_PYTHON=3.13`
- `pre-commit` / `pyproject.toml` / `CONTRIBUTING.md`: Python 3.13 baseline
- Governance narrative: encode/sync (not compile); no `.mdc` pipeline; runtime rule clarifies pre-commit validates code only
- `governance-as-code-ai-enforcement.md`, `monorepo-layout.md`, `AGENTS.md`, and skills catalog aligned with architecture definition

### Added (earlier unreleased)

- ASL architecture alignment: human-as-Architect paradigm, six-stage lifecycle, rule of precedence, native-first mandate
- Mode 2 skill `automation-builder` (replaces `automation-architect`)
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

- Mode 2 renamed from Architect to **Builder** across white paper, skills, and `AGENTS.md`
- L/T/F/C inventory matrix definitions per enterprise white book (with artifact mapping)
- Public variable naming: role/function prefix required (e.g. `nginx_max_connections`)
- Runtime execution rule: agents declare mode and COP vs white book precedence evaluation
- Reorganized `README.md` with visual hierarchy, quick start section, and repository structure overview
- Shortened and enhanced `gac/README.md` with clearer mode distinctions and consolidated task skills
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
- Operating modes: Auditor, Builder, Librarian (human as Architect)

[Unreleased]: https://github.com/your-org/ai-auto-governance-as-code/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/your-org/ai-auto-governance-as-code/releases/tag/v0.1.0
