# GaC Architecture: ai-forge Integration

## Overview

**Governance as Code (GaC)** is a governance platform for Ansible automation that provides:

- Version-controlled Red Hat CoP compliance
- AAP architecture patterns and migration strategies
- AI agents (Auditor, Builder, Librarian)
- Organization-specific governance via `automation-whitepaper/`

GaC **absorbs** the [ai-forge](https://github.com/ansible-community/ai-forge) skills library as a pinned git submodule for generic SDLC workflows while maintaining its own governance-specific content. AI Forge is governed under the same model as CoP — version-controlled, auditable, offline-capable.

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
│  ├── AGENTS.md + gac/gac-*/module/ (rules → skills for AI)  │
│  ├── automation-whitepaper/guides/ (Operational workflows)  │
│  └── gac/gac-*/module/skills/  (Org-specific skills)        │
│                                                             │
│  Vendor submodules (pinned — governed by white book):        │
│  ├── skills/vendor/ai-forge/   (SDLC + standards + roles)   │
│  │   └── Lola marketplace served from local submodule       │
│  └── skills/vendor/aap-skills-library/ (AAP platform)       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Why this architecture?

### Problem

Previously, GaC consumed ai-forge as a remote Lola dependency:

- Two independent marketplaces with separate lifecycle
- Skills fetched from remote GitHub — version could drift between runs
- No audit trail of which ai-forge version was used when
- Required internet to resolve the dependency
- No unified governance model over SDLC content

### Solution

AI Forge absorbed as a **pinned git submodule** under GaC governance:

- **ai-forge** → Vendor submodule at `skills/vendor/ai-forge/` (pinned commit)
- **GaC** → Single governance platform; white book prevails over ai-forge defaults
- **Lola marketplace** → Served from local submodule, not remote GitHub
- Same pattern as `automation-good-practices/` — see [ADR-009](../adrs/ADR-009-ai-forge-submodule-governance.md)

---

## What comes from where

### From ai-forge (pinned submodule at `skills/vendor/ai-forge/`)

**SDLC skills (active):**

| Skill / command | Purpose |
|-----------------|---------|
| `/commit` | Conventional commits with FQCN scopes |
| `/create-pr` | PR creation with validation |
| `/release` | Release workflow |
| `/changelog-fragment` | Changelog management |

**Why a submodule:**

- Pinned to a specific commit — exact version in git history
- Audit trail: which ai-forge version was used when
- Offline access — no network dependency
- Single governance model under GaC
- Updates are deliberate: bump submodule via PR when ready

**Available modules (pending evaluation):**

- `ansible-collection-standards` — CoP review, scaffolding, `/ansible-zen`
- `ansible-role` — Role scaffolding tools
- `ansible-content-development` — Content authoring and testing
- `ansible-documentation` — Documentation generation

See [ai-forge-overrides.md](../governance/ai-forge-overrides.md) for activation status and enterprise overrides.

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

Implemented in `AGENTS.md` and `gac/gac-governance/module/skills/automation-{auditor,builder,librarian}/`.

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

## Key design decision: vendor submodule model

### Why GaC pins external sources as submodules

**GaC requirement:** Version-controlled, auditable governance over all consumed content.

This applies to **both** CoP and AI Forge:

| Concern | Remote fetch (rejected) | Git submodule (adopted) |
|---------|-------------------------|-------------------------|
| Version control | Content can change between runs | Pinned to specific commit |
| Audit trail | No record of version used | Exact version in git history |
| Offline access | Requires internet | Works offline |
| Governance | External lifecycle | White book prevails on conflict |

**Pinned vendor submodules:**

| Submodule | Path | Purpose |
|-----------|------|---------|
| `automation-good-practices` | `automation-good-practices/` | Red Hat CoP baseline |
| `ai-forge` | `skills/vendor/ai-forge/` | SDLC workflows and standards |
| `aap-skills-library` | `skills/vendor/aap-skills-library/` | AAP platform administration |

**Conclusion:** Submodules are **not** duplication — they are a governance requirement.

Details: [cop-overrides.md](../governance/cop-overrides.md) · [ai-forge-overrides.md](../governance/ai-forge-overrides.md) · [ADR-003](../adrs/ADR-003-enforcement-precedence.md) · [ADR-009](../adrs/ADR-009-ai-forge-submodule-governance.md)

---

## Installation

**Run all Lola commands from the repository root** (`ai-auto-governance-as-code/`, where `lola-market.yml` lives). **Do not** run them inside `automation-whitepaper/` or any subfolder.

### Where Lola installs (explicit)

Lola **does not copy skills into `automation-whitepaper/`**. The white book stays human-authored markdown in git. Lola wires skills into your **AI assistant's native paths** for the current project.

| Content | Source in git | Written to `automation-whitepaper/`? | Where Lola / the assistant puts it |
|---------|---------------|--------------------------------------|-------------------------------------|
| White book (guides, ADRs, architecture) | `automation-whitepaper/` | **No** — already in git; read via `@` or prompts | Stays in your clone; not modified by Lola |
| GaC Agent Skills | `gac/gac-*/module/skills/` | **No** | Assistant skill dir (e.g. `.cursor/skills/` — gitignored) |
| `AGENTS.md` bootstrap rules | repo root | **No** | Referenced by skills; loaded by assistant |
| ai-forge SDLC (`/commit`, `/create-pr`, …) | `skills/vendor/ai-forge/` submodule → Lola dependency | **No** | Lola cache → translated into assistant format |
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

# Initialize submodules (includes ai-forge)
git submodule update --init --recursive

# ansible-content marketplace (from local ai-forge submodule)
lola market add ansible-content \
  skills/vendor/ai-forge/lola-market.yml

# gac marketplace (governance module)
lola market add gac \
  https://raw.githubusercontent.com/automationiberia/ai-auto-governance-as-code/main/lola-market.yml

lola install gac -a claude-code   # or: -a cursor
```

Installing `gac`:

1. Registers the `gac` modules from `lola-market.yml` (`repository` + `path: gac/gac-*/module`).
2. Resolves the `ansible-collection-sdlc` dependency from the local ai-forge submodule.
3. Installs governance skills into the assistant's native paths (e.g. `.cursor/skills/`).

### For GaC contributors

```bash
git clone --recurse-submodules \
  https://github.com/automationiberia/ai-auto-governance-as-code.git
cd ai-auto-governance-as-code    # repo root
make install
```

`make install` initializes all git submodules (CoP, ai-forge, AAPSL, delivery), registers the local ai-forge marketplace, and runs `lola sync`. It does **not** modify `automation-whitepaper/`.

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

### ai-forge skills (pinned submodule → Lola)

After `lola install gac -a <assistant>`, type these **in the assistant chat**:

```text
/commit                  # Conventional commit with validation (ai-forge)
/create-pr               # Open a PR with checks (ai-forge)
/changelog-fragment      # Add a changelog fragment (ai-forge)
/release                 # Release workflow (ai-forge)
```

SDLC slash commands are provided by the `ansible-collection-sdlc` module from the pinned ai-forge submodule, installed automatically as a dependency of `gac`.

### GaC governance (skills + white book)

Governance uses **Agent Skills** (from `gac/gac-*/module/skills/`, installed by Lola) and the white book under `automation-whitepaper/`.

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
        ├─ /commit, /create-pr …     → ai-forge (pinned submodule → Lola)
        │
        └─ "Use skill automation-builder" …
                    │
                    ├─ gac/gac-governance/module/skills/automation-builder/SKILL.md (installed by Lola)
                    ├─ AGENTS.md                            (modes, bootstrap rules)
                    ├─ automation-whitepaper/guides/…       (step-by-step standards)
                    ├─ automation-good-practices/           (pinned CoP submodule)
                    ├─ skills/vendor/ai-forge/              (pinned SDLC submodule)
                    └─ deliveries/automation/                 ($AUTOMATION_REPO code)
```

**Rule of thumb:** slash commands = **ship** the change (SDLC). Skills + white book = **design and validate** the change (governance).

### Where content lives vs how you invoke it

```text
REPO (git — your clone)                    ASSISTANT (Lola install target)
─────────────────────────                  ─────────────────────────────────
automation-whitepaper/  ← READ only        .cursor/skills/  (Cursor, gitignored)
  guides/…              (human + AI @)       ├── automation-builder/  (from gac module)
  adrs/…                                     ├── automation-auditor/
  architecture/…                             └── … SDLC skills (from ai-forge submodule)
gac/gac-*/module/skills/ ← SOURCE in git
AGENTS.md               ← SOURCE in git    Slash commands in chat:
automation-good-practices/  ← submodule        /commit  /create-pr  (ai-forge submodule)
skills/vendor/ai-forge/     ← submodule
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

- One installation command (`make install`)
- All content from pinned, version-controlled sources — no external fetches
- Access to community SDLC skills (ai-forge submodule)
- Access to organization governance (GaC)
- Offline-capable from first clone

### For governance

- Single source of truth: GaC governs all consumed content
- Version-controlled CoP and SDLC (both pinned submodules)
- Audit trail (exact version of every dependency in git history)
- Controlled updates (bump submodule via PR when ready)
- One marketplace origin instead of two

### For maintainers

- No SDLC duplication (consume from ai-forge submodule)
- Focus on governance content (AAP, whitepaper, agents)
- Clear boundaries: ai-forge = SDLC, GaC = governance
- Enterprise overrides tracked in [ai-forge-overrides.md](../governance/ai-forge-overrides.md)

---

## Dependencies

```yaml
# .lola-req
@ansible-content/ansible-collection-sdlc   # From ai-forge (local submodule)
```

```text
# Git submodules
automation-good-practices/          # Red Hat CoP (version-controlled)
skills/vendor/ai-forge/             # AI Forge SDLC + standards (version-controlled)
skills/vendor/aap-skills-library/   # AAP platform skills (version-controlled)
```

See also: [lola-market.yml](../../lola-market.yml)

---

## Future considerations

### Module activation

Four ai-forge modules are pending evaluation — see [ai-forge-overrides.md](../governance/ai-forge-overrides.md):

- `ansible-collection-standards` — CoP review, scaffolding, `/ansible-zen`
- `ansible-role` — Role scaffolding with interactive builders
- `ansible-content-development` — Content authoring and Molecule testing
- `ansible-documentation` — Documentation generation

### Enterprise wrapping

- GaC may wrap ai-forge skills with organization-specific extensions (e.g. `org-commit` wraps `/commit` + JIRA integration)
- GaC agents may consume ai-forge skills internally
- GaC maintains independence for governance-critical functionality
- Override status tracked in [ai-forge-overrides.md](../governance/ai-forge-overrides.md)

---

## Summary

**GaC = governance platform**

- SDLC workflows via Lola dependency (`ansible-collection-sdlc`)
- Owns governance-specific content (white book → skills)
- Provides version-controlled compliance
- Extends with organization patterns

**Module roles:**

| Module | Source | Role |
|--------|--------|------|
| `ansible-collection-sdlc` | `skills/vendor/ai-forge/` submodule | SDLC slash commands |
| `gac` | `gac/gac-*/module/` (owned) | Governance, compliance, organization rules as Agent Skills |

**Result:** Community-maintained SDLC absorbed under governed, auditable, single-source-of-truth compliance.

---

## Related documents

- [ai-forge and GaC (quick reference)](../governance/ai-forge-and-gac.md)
- [ai-forge-overrides.md](../governance/ai-forge-overrides.md)
- [ADR-009](../adrs/ADR-009-ai-forge-submodule-governance.md)
- [Monorepo layout](monorepo-layout.md)
- [philosophy.md](../governance/philosophy.md)
- [cop-overrides.md](../governance/cop-overrides.md)
- [ai-forge upstream](https://github.com/ansible-community/ai-forge)
