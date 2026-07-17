# Optional architectural decision records (ADRs)

**Normative rules** live in white book guides — see [whitebook folder map](../governance/whitebook-folder-map.md).

Use `adrs/` when you need formal traceability for:

- Approved **exceptions** to a standard rule
- **Major structural** or governance decisions
- Audit trail for contentious changes

ADRs **supplement** the white book; they do not replace Guide-first standards.

## When to write an ADR

| Type | Typical use |
|------|-------------|
| **STRUCTURAL** | Exceptions to L/T/F/C or repo layout |
| **CODING_STANDARD** | Org-wide rule adoption record |
| **SECURITY_POLICY** | Security deviations |
| **LIFECYCLE_POLICY** | Promotion or CI exceptions |
| **GOVERNANCE_RULE** | New Red Line or approval gate |
| **EVOLUTION_RULE** | Deprecations, GPA adoption, skill renames |
| **EXCEPTION_POLICY** | Controlled bypass of a standard |

## Example ADRs (reference)

| ADR | Topic |
|-----|-------|
| [ADR-001](ADR-001-whitebook-and-agent-skills.md) | White book + Agent Skills governance model |
| [ADR-002](ADR-002-ai-modes-and-manual-path.md) | AI modes and manual operating path |
| [ADR-003](ADR-003-enforcement-precedence.md) | Enforcement precedence hierarchy |
| [ADR-004](ADR-004-librarian-synchronization.md) | Librarian synchronization (not compilation) |
| [ADR-005](ADR-005-native-first-execution.md) | Native-first execution |
| [ADR-006](ADR-006-ltfc-mandatory.md) | L/T/F/C mandatory classification |
| [ADR-007](ADR-007-aap-platform-skills-plane.md) | AAP platform skills as second plane |
| [ADR-007 (mob design)](../docs/adrs/ADR-007-ai-mob-design.md) | AI Mob Design |

## Related

- [governance-as-code-ai-enforcement.md](../governance/governance-as-code-ai-enforcement.md)
- [landscape-type-function-component.md](../architecture/landscape-type-function-component.md)
