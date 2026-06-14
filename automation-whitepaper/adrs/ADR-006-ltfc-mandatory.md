# ADR-006: Define L/T/F/C inventory model as mandatory structural standard

**Status:** Accepted (example)  
**Type:** STRUCTURAL  
**Enforcement:** Builder + Auditor

## Context

Automation assets lack consistent classification, making reuse and governance tracking difficult.

## Decision

All automation artifacts **must** be classified using the L/T/F/C hierarchy:

- **Landscape**
- **Type**
- **Function**
- **Component**

No role or playbook may be created without a valid L/T/F/C mapping.

**Authoritative guide:** [architecture/landscape-type-function-component.md](../architecture/landscape-type-function-component.md). Approved exceptions → optional ADR in `adrs/`.

## Consequences

- Enables structured inventory governance
- Improves automation discoverability
- Adds classification overhead during design
