# GaC Architecture: ai-forge Integration

## Overview

**Governance as Code (GaC)** is a governance platform for Ansible automation that provides:

- Version-controlled Red Hat CoP compliance
- AAP architecture patterns and migration strategies
- AI agents (Auditor, Builder, Librarian)
- Organization-specific governance via `automation-whitepaper/`

GaC **consumes** the [ai-forge](https://github.com/ansible-community/ai-forge) skills library for generic SDLC workflows while maintaining its own governance-specific content.

---

## Architecture diagram

```text
┌─────────────────────────────────────────────────────────────┐
│  GaC (Governance as Code Platform)                          │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Governance content (GaC-owned):                            │
│  ├── automation-good-practices/  (CoP submodule — pinned)   │
│  ├── automation-whitepaper/      (AAP governance)           │
│  ├── AGENTS.md + skills/         (Auditor/Builder/Librarian)│
│  ├── automation-whitepaper/guides/ (Operational workflows)  │
│  └── skills/automation-*/        (Org-specific skills)      │
│                                                             │
│  Consumes via Lola:                                         │
│  └── @ansible-content/ansible-collection-sdlc (ai-forge)    │
│      └── Skills: commit, create-pr, release, changelog      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Why this architecture?

### Problem

Previously, GaC and ai-forge had overlapping functionality:

- Both provided installation mechanisms
- Unclear separation of responsibilities
- Potential duplication of SDLC workflows

### Solution

Clear separation of concerns:

- **ai-forge** → Generic, reusable SDLC skills
- **GaC** → Governance platform with version-controlled compliance

---

## What comes from where

### From ai-forge (consumed via Lola)

**SDLC skills:**

| Skill / command | Purpose |
|-----------------|---------|
| `/commit` | Conventional commits with FQCN scopes |
| `/create-pr` | PR creation with validation |
| `/release` | Release workflow |
| `/changelog-fragment` | Changelog management |

**Why consume these:**

- Generic functionality applicable to any Ansible project
- Maintained by the community
- Updates available via Lola

**Optional reference** (not used for CoP compliance):

- `/ansible-zen` — philosophical guidance (complementary to CoP)

### From GaC (owned and maintained)

**Version-controlled CoP compliance:**

- `automation-good-practices/` git submodule
- Pinned to a specific CoP commit
- Provides audit trail and version control
- Works offline (compliance requirement)

**AAP governance:**

- `automation-whitepaper/` — strategic governance, architecture
- AAP–Puppet coexistence patterns
- Multi-phase migration strategies
- Deployment patterns

**AI agents:**

- **Auditor** — compliance validation using local CoP + white book
- **Builder** — content creation following governance
- **Librarian** — documentation and skill synchronization

Implemented in `AGENTS.md` and `skills/automation-{auditor,builder,librarian}/`.

**Operational guides:**

- [getting-started.md](../guides/getting-started.md)
- [evaluate-and-update-existing.md](../guides/evaluate-and-update-existing.md)
- [create-new-from-scratch.md](../guides/create-new-from-scratch.md) (8-step checklist)

**Why keep these in GaC:**

- Organization-specific
- Requires version control for compliance
- Needs offline access
- Audit trail requirements

---

## Key design decision: CoP handling

### Why GaC keeps the `automation-good-practices` submodule

**GaC requirement:** Version-controlled, auditable CoP compliance.

**ai-forge approach** (dynamic CoP fetch):

- Rules fetched from GitHub at runtime
- Rules can change between runs
- No version control in the consumer repo
- Requires internet

**GaC approach** (git submodule):

- Submodule pinned to a specific commit
- Exact version recorded in git history
- Audit trail: which CoP version was used when
- Offline access
- Compliance-ready

**Conclusion:** GaC's submodule is **not** duplication — it is a governance requirement.

Details: [cop-overrides.md](../governance/cop-overrides.md) · [ADR-003](../adrs/ADR-003-enforcement-precedence.md)

---

## Installation

### For end users (AI assistant)

```bash
pip install lola-ai

lola market add gac \
  https://raw.githubusercontent.com/automationiberia/ai-auto-governance-as-code/main/lola-market.yml

lola install gac -a claude-code
```

Installing `gac` pulls ai-forge SDLC skills via the dependency declared in `lola-market.yml`.

### For GaC contributors

```bash
git clone --recurse-submodules \
  https://github.com/automationiberia/ai-auto-governance-as-code.git
cd ai-auto-governance-as-code
make install
```

`make install` runs `lola sync` (SDLC from ai-forge) and `git submodule update --init --recursive` (CoP + delivery submodules).

---

## Usage examples

### Using ai-forge skills (via GaC / Lola)

```text
/commit                  # Conventional commit (ai-forge)
/create-pr               # Pull request with validation (ai-forge)
/changelog-fragment      # Changelog fragment (ai-forge)
/release                 # Release workflow (ai-forge)
```

These skills come from ai-forge, consumed by GaC via Lola.

### Using GaC governance

```text
# Review against version-controlled CoP
# (GaC Auditor mode + automation-good-practices submodule + white book)

# Reference AAP architecture
automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md

# Follow operational guides
automation-whitepaper/guides/create-new-from-scratch.md
```

---

## Benefits

### For developers

- One installation command (`lola install gac` or `make install`)
- Access to community SDLC skills (ai-forge)
- Access to organization governance (GaC)
- ai-forge SDLC updates via Lola

### For governance

- Version-controlled CoP (git submodule)
- Audit trail (exact rules version in git history)
- Offline capable
- Controlled updates (bump submodule when ready)

### For maintainers

- No SDLC duplication (consume from ai-forge)
- Focus on governance content (AAP, whitepaper, agents)
- Simpler installation (Lola handles SDLC)
- Clear boundaries: ai-forge = SDLC, GaC = governance

---

## Dependencies

```yaml
# .lola-req
@ansible-content/ansible-collection-sdlc   # From ai-forge
```

```text
# Git submodule
automation-good-practices/   # Red Hat CoP (version-controlled)
```

See also: [lola-market.yml](../../lola-market.yml)

---

## Future considerations

### Optional ai-forge consumption

GaC may optionally reference:

- `/ansible-zen` — philosophical guidance (complementary to CoP)
- Other ai-forge modules as they become relevant

### GaC evolution

- GaC may wrap ai-forge skills with organization-specific extensions (e.g. org-commit wraps `/commit` + JIRA integration)
- GaC agents may consume ai-forge skills internally
- GaC maintains independence for governance-critical functionality

---

## Summary

**GaC = governance platform**

- Consumes ai-forge for generic SDLC
- Owns governance-specific content
- Provides version-controlled compliance
- Extends with organization patterns

**Clean separation:**

| Layer | Role |
|-------|------|
| ai-forge | Generic, reusable SDLC skills |
| GaC | Governance, compliance, organization-specific rules |

**Result:** Community-maintained SDLC plus governed, auditable compliance.

---

## Related documents

- [ai-forge and GaC (quick reference)](../governance/ai-forge-and-gac.md)
- [Monorepo layout](monorepo-layout.md)
- [philosophy.md](../governance/philosophy.md)
- [cop-overrides.md](../governance/cop-overrides.md)
- [ai-forge upstream](https://github.com/ansible-community/ai-forge)
