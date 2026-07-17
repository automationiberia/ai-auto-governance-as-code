# Red Hat CoP override mapping

CoP **baseline** is the pinned **`automation-good-practices/`** git submodule — auditable and version-controlled. This document records where **automation-whitepaper** supersedes CoP.

## Hierarchy

Per [ADR-003](../adrs/ADR-003-enforcement-precedence.md):

1. **automation-whitepaper** — primary authority
2. **`automation-good-practices/`** — CoP baseline where white book is silent
3. **On conflict** — white book wins

## Override index

| Topic | CoP (GPA submodule) | White book override | Reference |
|-------|---------------------|---------------------|-----------|
| L/T/F/C | Not in GPA | Mandatory classification | [ADR-006](../adrs/ADR-006-ltfc-mandatory.md) |
| Native-first | GPA recommends modules | Documented exceptions + ADR | [ADR-005](../adrs/ADR-005-native-first-execution.md) |
| AI-generated code | N/A | Same rules as manual; mode declaration | [ADR-002](../adrs/ADR-002-ai-modes-and-manual-path.md) |

Add organization-specific overrides as your enterprise profile requires.

## SDLC vs CoP

| Concern | Source |
|---------|--------|
| **CoP compliance rules** | `automation-good-practices/` submodule |
| **SDLC workflows** (commit, PR, release) | ai-forge via Lola — see [ai-forge-and-gac.md](ai-forge-and-gac.md) |

## Related

- [ai-forge and GaC](ai-forge-and-gac.md)
- [philosophy.md](philosophy.md)
