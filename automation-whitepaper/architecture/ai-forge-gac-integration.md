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

**Run all Lola commands from the repository root** (`ai-auto-governance-as-code/`, where `lola-market.yml` lives). **Do not** run them inside `automation-whitepaper/` or any subfolder.

### Where Lola installs (explicit)

Lola **does not copy skills into `automation-whitepaper/`**. The white book stays human-authored markdown in git. Lola wires skills into your **AI assistant's native paths** for the current project.

| Content | Source in git | Written to `automation-whitepaper/`? | Where Lola / the assistant puts it |
|---------|---------------|--------------------------------------|-------------------------------------|
| White book (guides, ADRs, architecture) | `automation-whitepaper/` | **No** — already in git; read via `@` or prompts | Stays in your clone; not modified by Lola |
| GaC Agent Skills | `skills/` at repo root | **No** | Assistant skill dir (e.g. `.cursor/skills/` — gitignored) |
| `AGENTS.md` bootstrap rules | repo root | **No** | Referenced by skills; loaded by assistant |
| ai-forge SDLC (`/commit`, `/create-pr`, …) | **Not in this repo** — `@ansible-content/ansible-collection-sdlc` | **No** | Lola cache → translated into assistant format |
| CoP baseline | `automation-good-practices/` submodule | **No** | Submodule path in your clone (`make install` / `git submodule`) |
| Delivery Ansible code | `deliveries/automation/` submodule | **No** | Submodule path (`$AUTOMATION_REPO`) |

**Verify after install:**

```bash
cd ai-auto-governance-as-code    # repo root
lola list                        # modules installed for this project
ls .cursor/skills 2>/dev/null    # Cursor: GaC + ai-forge skills (gitignored)
```

**Common mistake:** expecting `/commit` or `automation-builder` to appear as files under `automation-whitepaper/`. They do not — you invoke them in the assistant chat; the white book is **referenced**, not **installed into**.

Full detail: [Where content lives vs how you invoke it](#where-content-lives-vs-how-you-invoke-it) below.

### For end users (AI assistant)

```bash
cd ai-auto-governance-as-code    # repo root — required
pip install lola-ai

lola market add gac \
  https://raw.githubusercontent.com/automationiberia/ai-auto-governance-as-code/main/lola-market.yml

lola install gac -a claude-code   # or: -a cursor
```

Installing `gac`:

1. Registers this repository as a Lola module (`path: .` in `lola-market.yml`).
2. Pulls **ai-forge SDLC** as a dependency (not into `automation-whitepaper/`).
3. Wires **GaC skills** from `skills/` into your assistant — still **not** into `automation-whitepaper/`.

### For GaC contributors

```bash
git clone --recurse-submodules \
  https://github.com/automationiberia/ai-auto-governance-as-code.git
cd ai-auto-governance-as-code    # repo root
make install
```

`make install` runs `lola sync` (ai-forge SDLC from `.lola-req` only) and `git submodule update --init --recursive` (CoP + delivery). It does **not** modify `automation-whitepaper/`.

After `make install`, run `lola install gac -a <assistant>` once per machine to wire GaC skills into your IDE.

---

## Usage examples

See also: [Where Lola installs (explicit)](#where-lola-installs-explicit).

GaC and ai-forge use **different invocation styles**. ai-forge exposes **slash commands** in the assistant; GaC exposes **Agent Skills** and **white book guides** that the human or AI **reads from the cloned repo** (not copied into `automation-whitepaper/` by Lola).

| Layer | How you invoke it | What it does |
|-------|-------------------|----------------|
| **ai-forge (SDLC)** | Slash commands in chat | Commit, PR, release, changelog |
| **GaC (governance)** | Agent Skills + prompts | Audit, build, document Ansible to org standards |
| **GaC (human manual)** | Read guides in `automation-whitepaper/guides/` | Same standards without AI |

### ai-forge skills (via Lola)

After `lola install gac -a <assistant>`, type these **in the assistant chat**:

```text
/commit                  # Conventional commit with validation (ai-forge)
/create-pr               # Open a PR with checks (ai-forge)
/changelog-fragment      # Add a changelog fragment (ai-forge)
/release                 # Release workflow (ai-forge)
```

These skills are **not** in this repo — they come from `@ansible-content/ansible-collection-sdlc` (ai-forge), installed by Lola as a dependency of the `gac` module.

### GaC governance (skills + white book)

GaC does **not** use slash commands for governance. Use **Agent Skills** (installed by Lola from `skills/`) and point the AI at files under `automation-whitepaper/` when needed.

**1 — Audit existing Ansible (Mode 1 — Auditor)**

```text
Read AGENTS.md. I am operating in Mode 1: The Auditor.
Use skill automation-auditor.
Audit deliveries/automation/roles/<rolename>/ against the white book and
the pinned CoP in automation-good-practices/.
```

**2 — Build new automation (Mode 2 — Builder)**

```text
Read AGENTS.md. I am operating in Mode 2: The Builder.
Use skill automation-builder and follow automation-whitepaper/guides/create-new-from-scratch.md.
Create a new role for <capability> with L/T/F/C documented before YAML.
```

**3 — Read architecture or migration context (no mode — reference)**

```text
Read automation-whitepaper/architecture/aap-puppet-coexistence-evolution.md.
Summarize Phase 1 coexistence constraints for our environment.
```

**4 — Human-only path (no AI)**

Open the guide directly — same content the Builder skill references:

| Goal | Guide |
|------|-------|
| First time in the repo | [getting-started.md](../guides/getting-started.md) |
| Review or fix existing code | [evaluate-and-update-existing.md](../guides/evaluate-and-update-existing.md) |
| Build something new | [create-new-from-scratch.md](../guides/create-new-from-scratch.md) |

More copy-paste prompts: [ai-prompt-examples.md](../guides/ai-prompt-examples.md).

### How the pieces connect

```text
You type a prompt or slash command
        │
        ├─ /commit, /create-pr …     → ai-forge (Lola → ai-forge SDLC module)
        │
        └─ "Use skill automation-builder" …
                    │
                    ├─ skills/automation-builder/SKILL.md   (installed by Lola)
                    ├─ AGENTS.md                            (modes, bootstrap rules)
                    ├─ automation-whitepaper/guides/…       (step-by-step standards)
                    ├─ automation-good-practices/           (pinned CoP submodule)
                    └─ deliveries/automation/                 ($AUTOMATION_REPO code)
```

**Rule of thumb:** slash commands = **ship** the change (SDLC). Skills + white book = **design and validate** the change (governance).

### Where content lives vs how you invoke it

```text
REPO (git — your clone)                    ASSISTANT (Lola install target)
─────────────────────────                  ─────────────────────────────────
automation-whitepaper/  ← READ only        .cursor/skills/  (Cursor, gitignored)
  guides/…              (human + AI @)       ├── automation-builder/  (from skills/)
  adrs/…                                     ├── automation-auditor/
  architecture/…                             └── … ai-forge SDLC skills
skills/                 ← SOURCE in git
AGENTS.md               ← SOURCE in git    Slash commands in chat:
automation-good-practices/  ← submodule        /commit  /create-pr  (ai-forge)
deliveries/automation/      ← submodule
```

| You want to… | Do this | Touches `automation-whitepaper/`? |
|--------------|---------|-----------------------------------|
| Commit / open PR (SDLC) | `/commit`, `/create-pr` in chat | **No** |
| Audit a role (governance) | `Use skill automation-auditor` + read white book | **Read only** |
| Build new automation | `Use skill automation-builder` + `automation-whitepaper/guides/create-new-from-scratch.md` | **Read only** |
| Learn standards without AI | Open `automation-whitepaper/guides/` in the browser/IDE | **Read only** |

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
