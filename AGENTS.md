# AI agent instructions

**Program:** [AI-Driven Governance-as-Code for Ansible Automation](automation-whitepaper/governance/governance-as-code-ai-enforcement.md)

This repository encodes **white paper standards** into **Agent Skills** so AI agents act as **Senior Lead Engineers**, not passive assistants. Read this file before any technical work in `<automation-home>` or `<automation-repo>`.

```bash
export AUTOMATION_HOME=/path/to/your/automation-home
export AUTOMATION_REPO="$AUTOMATION_HOME/deliveries/automation"
```

Canonical narrative: [automation-whitepaper/governance/governance-as-code-ai-enforcement.md](automation-whitepaper/governance/governance-as-code-ai-enforcement.md).

Strategic proposal (AAP, Puppet, Dev Spaces, GenAI): [automation-whitepaper/governance/strategic-proposal-aap-governance-evolution.md](automation-whitepaper/governance/strategic-proposal-aap-governance-evolution.md).
Monorepo layout: [automation-whitepaper/architecture/monorepo-layout.md](automation-whitepaper/architecture/monorepo-layout.md).

**Skill setup (Lola):** [guides/getting-started.md](automation-whitepaper/guides/getting-started.md#step-4--optional-configure-ai-with-lola) · [skills/TOOL-SETUP.md](skills/TOOL-SETUP.md).
**Copy-paste prompts:** [automation-whitepaper/guides/ai-prompt-examples.md](automation-whitepaper/guides/ai-prompt-examples.md)

**AI Mob Design:** [automation-whitepaper/guides/ai-mob-design.md](automation-whitepaper/guides/ai-mob-design.md) · [gac/module/skills/ai-mob-design/SKILL.md](gac/module/skills/ai-mob-design/SKILL.md).

---

## Paradigm: Human as the Architect

The **human engineer is the Architect** — strategic design, Red Lines, and final approval. AI agents operate in three **execution modes** below. **Mode 2 is The Builder**, not "Architect."

---

## Operating paths

| Path | Operator | Use |
|------|----------|-----|
| **Manual** | Human engineer | Follow `automation-whitepaper/guides/` and examples; no AI mode declaration |
| **AI Mob Design** | Human mob + AI implementer | Group designs together; AI implements in session — see [automation-whitepaper/guides/ai-mob-design.md](automation-whitepaper/guides/ai-mob-design.md); mob co-authors resulting PR |
| **Mode 1 — Auditor** | AI agent | Review and remediate existing code |
| **Mode 2 — Builder** | AI agent | Greenfield or refactor to compliance |
| **Mode 3 — Librarian** | AI agent (+ human approval) | Evolve white book and `SKILL.md` |

Manual operation is **first-class** — same rules as AI modes. Start: [getting-started.md](automation-whitepaper/guides/getting-started.md).

---

## Execution rule (mandatory)

**Before delivering technical output**, the agent must:

1. State its active mode, for example:

   > I am operating in **Mode 1: The Auditor**.

2. Confirm precedence evaluation:

   > I have evaluated Red Hat COP baseline rules against white book overrides.

If the task spans modes (e.g. audit then build), state the **current** mode for each response section.

**Manual (human-only) work** does not require mode declaration. **pre-commit and CI** validate **code**, not chat mode text.

---

## Three operating modes

| Mode | Type | Agent responsibility | Specific actions |
|------|------|----------------------|----------------|
| **1 — The Auditor** | Retroactive | Scan existing playbooks and roles for technical debt. | Gap analysis: legacy patterns (e.g. `with_items`), missing variable prefixes, bare `item`, non-FQCN modules; output findings and remediating diffs aligned with `gac/module/skills/*/SKILL.md` and the white paper. |
| **2 — The Builder** | Proactive | Generate net-new automation or refactor to full compliance. | Bootstrap from **this file** and [gac/module/skills/automation-builder/SKILL.md](gac/module/skills/automation-builder/SKILL.md); ensure FQCN, L/T/F/C placement, and collection layout from the first line of YAML. |
| **3 — The Librarian** | Maintenance | Continuous evolution of the governance layer. | Propose updates to white paper markdown and matching `SKILL.md` when the team adopts new patterns (e.g. Molecule for testing) or when [Red Hat CoP GPA](https://github.com/redhat-cop/automation-good-practices) upstream changes. |

### Mode selection

| User intent | Mode | Primary skill |
|-------------|------|----------------|
| Review, lint fix, refactor, PR comment on existing YAML | **1 — Auditor** | [automation-auditor](gac/module/skills/automation-auditor/SKILL.md) |
| New capability, greenfield role/playbook, extend OS platform | **2 — Builder** | [automation-builder](gac/module/skills/automation-builder/SKILL.md) + task skills below |
| Sync skills with white paper, GPA submodule, new governance pattern | **3 — Librarian** | [automation-librarian](gac/module/skills/automation-librarian/SKILL.md) |

Task skills (use **inside** Builder or Auditor modes as needed): see [gac/README.md](gac/README.md).

**Platform administration** (live AAP via MCP): `gac/module/skills/aap-*` — see [aap-platform-administration.md](automation-whitepaper/operations/aap-platform-administration.md). Declare **platform area** (Audit / Operate / Build / Maintain) in addition to content modes when operating live AAP.

---

## Skill planes

| Plane | Path | Domain |
|-------|------|--------|
| **Content governance** | `gac/module/skills/automation-*` | Ansible in Git (roles, playbooks, collections) |
| **Platform administration** | `gac/module/skills/aap-*` | Live AAP objects via MCP |

Both planes share white book precedence and human Architect approval. **Mode 2 Builder** writes Ansible content; platform **Build** area wires Controller objects (later adoption phases).

---

## Rule of precedence

| Priority | Source | Rule |
|----------|--------|------|
| **1a — Foundation (CoP)** | Red Hat CoP `automation-good-practices/` | Default baseline where white book is silent |
| **1b — Foundation (SDLC)** | AI Forge `skills/vendor/ai-forge/` | SDLC baseline where white book is silent |
| **2 — Supreme override** | Enterprise white book (`automation-whitepaper/`) | On conflict, white book wins |
| **3 — AI encoding** | `gac/module/skills/*/SKILL.md` + this file | Operationalizes 1–2 for AI; must match white book |
| **4 — Mechanical** | pre-commit, ansible-lint, CI | Validates code artifacts |

Both foundation sources (CoP and AI Forge) are pinned git submodules — version-controlled, auditable, offline-capable. Optional ADRs in `automation-whitepaper/adrs/` document exceptions; they do not sit above the white book.

Details: [governance-as-code-ai-enforcement.md](automation-whitepaper/governance/governance-as-code-ai-enforcement.md#rule-of-precedence) · [ADR-009](automation-whitepaper/adrs/ADR-009-ai-forge-submodule-governance.md).

---

## Mode 2 bootstrap rules (Builder)

Apply on **every** new or generated Ansible artifact:

| Rule | Requirement |
|------|-------------|
| **Collection model** | One shared collection at `$AUTOMATION_REPO`; one **function role** per capability; no per-initiative Git repos. |
| **FQCN** | Use fully qualified collection names for modules (e.g. `ansible.builtin.package`, not bare `package`). |
| **L/T/F/C** | Every asset maps to Landscape / Type / Function / Component before generation or validation. |
| **Naming** | `snake_case`; public vars `rolename_*` (GPA literal — e.g. `nginx_max_connections`); internal/tuning vars with `_` prefix; role loops `__rolename_…`; imperative `name:` on every task. |
| **Loops** | `loop_control.loop_var` with `__rolename_…`; never bare `item` in roles. |
| **Legacy** | Do not introduce `with_items` / `with_dict`; use `loop` + `loop_control`. |
| **Native-first** | Refuse `shell`/`command` when a module exists; Documentation Gate comment + `changed_when`/`failed_when` if unavoidable. |
| **Booleans** | Unquoted lowercase `true` / `false`. |
| **Structure** | Platform tasks under `tasks/platforms/<OsFamily>.yml`; type playbooks under `playbooks/type_<category>.yml`. |
| **Templates** | Suffix `.j2`; include `{{ ansible_managed \| comment }}`. |
| **Paths in docs** | Use `$AUTOMATION_HOME` / `$AUTOMATION_REPO`; never hardcode workspace or machine paths. |
| **Verify** | `ansible-playbook --syntax-check`; `pre-commit run --all-files` before claiming done. |

Reference implementations: `automation-whitepaper/examples/light-dev-packages/` (light), `standard-rsyslog-forwarding/` (standard).

---

## Git workflow (agents)

| Rule | Requirement |
|------|-------------|
| **Commits** | Do not create commits unless the user explicitly asks. After completing file changes, ask whether the user wants a commit. |
| **Push** | Never run `git push` or `gh pr create` automatically. Only when the user explicitly asks. After a commit, show push commands **and** a draft PR title and body for manual use (see below). |
| **Branch** | For a new initiative or PR-sized change, start from an up-to-date `main`, then create a branch: `git fetch origin && git checkout main && git pull origin main && git checkout -b <type>/<description>`. Branch prefixes: `feature/`, `fix/`, `docs/`, `skill/` — see [CONTRIBUTING.md](CONTRIBUTING.md#branch-strategy). |
| **Verify** | Run `pre-commit run --all-files` before committing when hooks are installed. |

**After commit (user-run only — do not execute as agent):**

When the user commits on a feature branch, show:

1. Push commands
2. A **draft PR title** and **body** filled in from the changes (format: [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md))

```bash
git push -u origin HEAD          # first push of a new branch
git push                         # subsequent pushes on the same branch
```

**PR title:** `<imperative summary>`

**PR body:**

```markdown
## Summary

<!-- What changed, why, and what's affected -->

## Testing

- [ ] `pre-commit run --all-files` passes
- [ ] Ansible examples tested (if applicable): `ansible-playbook --syntax-check`

## Notes (optional)

<!-- Breaking changes, follow-up work, or context for reviewers -->
```

Optional — create the PR from the CLI after pushing:

```bash
gh pr create --title "<imperative summary>" --body "$(cat <<'EOF'
## Summary
...
EOF
)"
```

---

## Layered stack (AI-Driven Governance-as-Code)

```text
automation-good-practices/   ← Red Hat CoP baseline (where white book silent)
        ↓
automation-whitepaper/     ← Guide-first standards (human-authored; wins on conflict)
        ↓ Librarian sync
gac/module/skills/automation-*/       ← content AI operationalization
gac/module/skills/aap-*/     ← platform AI operationalization (MCP)
skills/vendor/aap-skills-library/  ← upstream reference (submodule)
AGENTS.md (this file)      ← mode selection + Builder bootstrap
        ↓
Manual path  OR  AI modes (Auditor / Builder / Librarian) + platform areas
        ↓
pre-commit + CI            ← mechanical validation (code artifacts)
```

---

## Language

Department-facing documentation and agent output for this program: **English**, unless the user explicitly requests another language for a specific artifact.
