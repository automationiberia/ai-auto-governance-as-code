---
name: automation-governance
description: >-
  Stakeholders and RACI for automation in enterprise environments including
  Spanish IT teams, CAB, Security, CMDB. Use when planning involvement or change
  records. Light profile skips most governance; see light walkthrough example.
user-invocable: true
metadata:
  author: gac
  version: "1.0"
---

# Governance and Stakeholders

Docs: `automation-whitepaper/governance/`

## By profile

| | Light (lab) | Standard (prod) |
|-|-------------|-----------------|
| Ticket | Backlog | ITSM |
| CAB | Skip | Yes |
| Security | Skip | If privileged |
| CMDB | Skip | If applicable |

Walkthrough contrast (both use new `git init` repos): light vs standard example markdown files

Heavy / CAB detail: [glossary.md](../../../../automation-whitepaper/guides/glossary.md) · [example-enterprise-change-flow.md](../../../../automation-whitepaper/examples/example-enterprise-change-flow.md)

## Agent behavior

- Declare active mode per [AGENTS.md](../../../../AGENTS.md) (human RACI; not Librarian unless updating governance docs).
- Recommend minimal stakeholders for light; full list only for prod-bound work.
