# Main Guide: Processes and Flows for Automation

This document is the **complete** reference for processes and flows. For a short onboarding path, use the summary guides:

| Goal | Start here |
|------|------------|
| First time in the repo | [guides/getting-started.md](guides/getting-started.md) |
| Review or fix existing code | [guides/evaluate-and-update-existing.md](guides/evaluate-and-update-existing.md) |
| Build something new | [guides/create-new-from-scratch.md](guides/create-new-from-scratch.md) |

---

## 1. Purpose and scope

The automation department delivers repeatable, auditable infrastructure and operations changes using **Ansible** and, where applicable, **Red Hat Ansible Automation Platform** (Controller, execution environments, workflows).

This guide applies to:

- New automation (greenfield)
- Changes to existing roles, playbooks, inventories, and workflows
- Retirement or replacement of legacy scripts

It does **not** replace vendor documentation; it defines **our** operating model on top of community good practices.

### Creating new automation?

Quick path: **[guides/create-new-from-scratch.md](guides/create-new-from-scratch.md)** · Full checklist: **[guides/create-new-automation-step-by-step.md](guides/create-new-automation-step-by-step.md)**
**Delivery code** lives in one **shared Ansible collection** at **`deliveries/automation/`** (each capability = one role) — see [../deliveries/README.md](../deliveries/README.md).
**Dev Spaces:** import the monorepo and use [guides/devspaces-workspace.md](guides/devspaces-workspace.md).
**Extending** a capability (new OS, servers): [guides/extending-existing-automation.md](guides/extending-existing-automation.md) — extend the **same function role** (`tasks/platforms/`), do not add `role_windows` clones or new per-initiative repos.
Examples (walkthrough + reference code): **light** [doc](examples/example-light-walkthrough-dev-packages.md) / [code](examples/light-dev-packages/) · **standard** [doc](examples/example-complete-walkthrough-rsyslog-forwarding.md) / [code](examples/standard-rsyslog-forwarding/)
AI support (**AI-Driven Governance-as-Code**): **[skills/TOOL-SETUP.md](../skills/TOOL-SETUP.md)** (pick tool) · **[AGENTS.md](../AGENTS.md)** · [ai-prompt-examples.md](guides/ai-prompt-examples.md)

---

## 2. Guiding principles (Zen of Ansible)

Before process detail, align decisions with these principles (from GPA):

| Principle | Practical meaning for the department |
|-----------|--------------------------------------|
| Clear is better than cluttered | Prefer readable roles and thin playbooks |
| Simple is better than complex | Avoid programming in YAML; use roles and modules |
| User experience beats purity | Optimize for operators and consumers, not authors only |
| Declarative over imperative | Describe desired state; minimize ad-hoc command tasks |
| Automation is a continuous journey | Plan for maintenance, not one-off delivery |

Full text and rationale: see [architecture/landscape-type-function-component.md](architecture/landscape-type-function-component.md).

---

## 3. Six-stage lifecycle

```mermaid
flowchart LR
  A[Intake] --> B[Design]
  B --> C[Implementation]
  C --> D[Quality]
  D --> E[Promotion]
  E --> F[Operation & improvement]
  F --> A
```

| Stage | Outcome | Detailed doc |
|-------|---------|----------------|
| **1 — Intake** | Approved backlog item with owner and success criteria | [lifecycle/intake-and-prioritization.md](lifecycle/intake-and-prioritization.md) |
| **2 — Design** | L/T/F/C placement, SSOT, target execution environments | [lifecycle/design-and-build.md](lifecycle/design-and-build.md), [architecture/](architecture/) |
| **3 — Implementation** | Roles, playbooks, inventory, collections in Git | [development/](development/) |
| **4 — Quality** | Pre-commit, ansible-lint, Molecule idempotency, peer review | [quality/](quality/), [lifecycle/test-and-promote.md](lifecycle/test-and-promote.md) |
| **5 — Promotion** | Versioned release dev → pre → prod via GitOps / AAP | [lifecycle/test-and-promote.md](lifecycle/test-and-promote.md) |
| **6 — Operation & improvement** | Job metrics, refactoring, technical debt removal | [lifecycle/operate-and-improve.md](lifecycle/operate-and-improve.md), [operations/](operations/) |

Overview: [lifecycle/automation-lifecycle-overview.md](lifecycle/automation-lifecycle-overview.md).

---

## 4. Organizational participation (overview)

Automation that touches production must involve **traditional enterprise teams** where it adds control and clarity—not bureaucracy for its own sake.

| Team (typical in Spanish enterprises) | When they engage | White paper section |
|--------------------------------------|------------------|---------------------|
| **Business / application owners** | Intake, acceptance criteria | [governance/organizational-model-and-stakeholders.md](governance/organizational-model-and-stakeholders.md) |
| **IT Operations / Systems** | Design, runbooks, operations handover | [lifecycle/operate-and-improve.md](lifecycle/operate-and-improve.md) |
| **Change Management (CAB)** | Production changes, maintenance windows | [glossary.md](guides/glossary.md) · [example-enterprise-change-flow.md](examples/example-enterprise-change-flow.md) |
| **Information Security (CISO/SOC)** | Risk review, secrets, logging | [lifecycle/test-and-promote.md](lifecycle/test-and-promote.md) |
| **Network** | Connectivity, firewall rules in automation | [development/inventories-and-variables.md](development/inventories-and-variables.md) |
| **Database (DBA)** | Data-layer changes, backup/restore coordination | [lifecycle/design-and-build.md](lifecycle/design-and-build.md) |
| **Service Desk / NOC** | User impact, communication | [lifecycle/operate-and-improve.md](lifecycle/operate-and-improve.md) |
| **CMDB / ITSM** | As-Is / To-Be data, SSOT | [operations/inventory-ssot-integration.md](operations/inventory-ssot-integration.md) |
| **Compliance / DPO** | Personal data, retention, audit | [governance/organizational-model-and-stakeholders.md](governance/organizational-model-and-stakeholders.md) |
| **Procurement / Vendor management** | Support contracts, platform licensing | [governance/roles-and-responsibilities.md](governance/roles-and-responsibilities.md) |

The automation department **facilitates** and **implements**; it does not unilaterally own production risk. See [governance/roles-and-responsibilities.md](governance/roles-and-responsibilities.md) for RACI.

---

## 5. Technical structure: what to build where

Use a consistent hierarchy so code stays reusable and navigable:

```
Landscape  →  Type  →  Function (role)  →  Component (task file / sub-role)
```

| Layer | Represents | Typical artifact |
|-------|------------|------------------|
| **Landscape** | Everything deployed together (e.g. three-tier app) | Controller workflow or playbook-of-playbooks |
| **Type** | One host category, one playbook | Type playbook (e.g. `web_frontend.yml`) |
| **Function** | Reusable capability | Ansible role (e.g. `base_os`, `nginx`) |
| **Component** | Maintainable slice inside a function | `tasks/dns.yml`, `tasks/ntp.yml` |

Rules and exceptions: [architecture/landscape-type-function-component.md](architecture/landscape-type-function-component.md).

Packaging and distribution: [architecture/collections-and-execution-environments.md](architecture/collections-and-execution-environments.md).

---

## 6. Recommended delivery flow (single automation initiative)

### 6.1 Intake

1. Request logged (ticket / internal portal) with problem statement, not solution.
2. Automation team assesses: repeatability, volume, risk, SSOT availability.
3. Prioritization with business and Operations.

### 6.2 Design

1. Map to landscape / type / function.
2. Identify inventory SSOTs (cloud API, Satellite, CMDB).
3. Define role interfaces (variables in `defaults/`, argument specs).
4. Security and Change preview for production impact.

### 6.3 Build

1. Scaffold role(s) from department template (`ansible-galaxy init` / collection layout).
2. Implement with idempotency and check mode in mind.
3. Keep playbooks thin: list of roles or `import_role` with clear tags.
4. Store inventory as structured directory; avoid host lists in variables.

### 6.4 Test

1. **`pre-commit run --all-files`** (mandatory — see [quality/pre-commit.md](quality/pre-commit.md))
2. `ansible-playbook --syntax-check`
3. `ansible-lint` (department profile, included in pre-commit)
4. Molecule or CI pipeline (target platforms)
5. Check mode on representative hosts (non-prod)

### 6.5 Release

1. Peer review (see [quality/code-review-and-linting.md](quality/code-review-and-linting.md))
2. Semantic version tag on collection/role repo
3. Promote execution environment and project sync on Controller
4. CAB approval for production (see example flow)

### 6.6 Operate

1. Job templates with documented extra vars policy (debug only in prod)
2. Monitoring integration (job success/failure, duration)
3. Periodic review: still needed? still idempotent? still accurate SSOT?

---

## 7. Maintenance flows

| Trigger | Actions |
|---------|---------|
| OS major version | Review provider vars, platform `vars/`, integration tests |
| Application upgrade | Bump collection version; regression test type playbook |
| SSOT schema change | Update dynamic inventory or group_vars mapping |
| Security advisory | Priority patch role; expedited CAB if needed |
| GPA / lint rule update | Quarterly hygiene sprint on affected repos |

Details: [lifecycle/operate-and-improve.md](lifecycle/operate-and-improve.md).

---

## 8. Quality gates (summary)

A **gate** is a mandatory checkpoint — mechanical (tools) or human (approval) — before merge or production. See [guides/glossary.md](guides/glossary.md).

All production-bound content must pass:

- [ ] **Pre-commit** hooks installed and `pre-commit run --all-files` green
- [ ] Named tasks; imperative task names
- [ ] Idempotent tasks; check mode supported or documented exception
- [ ] Role variables prefixed with role name; internal vars with `__`
- [ ] No production desired state in extra vars
- [ ] Inventory describes To-Be; facts used for As-Is only
- [ ] README / argument_specs for consumer-facing roles
- [ ] Review by second engineer; security touch for privileged operations

Expanded checklists: [quality/](quality/).

---

## 9. Where to go next

| If you need… | Read |
|--------------|------|
| **Step-by-step new automation** | [guides/create-new-automation-step-by-step.md](guides/create-new-automation-step-by-step.md) |
| Pre-commit setup | [quality/pre-commit.md](quality/pre-commit.md) |
| AI-Driven Governance-as-Code | [governance/governance-as-code-ai-enforcement.md](governance/governance-as-code-ai-enforcement.md), [../AGENTS.md](../AGENTS.md) |
| AI prompt examples | [guides/ai-prompt-examples.md](guides/ai-prompt-examples.md) |
| Agent skills setup | [../skills/TOOL-SETUP.md](../skills/TOOL-SETUP.md) · [../skills/README.md](../skills/README.md) |
| Who to involve and RACI | [governance/](governance/) |
| Phase-by-phase lifecycle | [lifecycle/](lifecycle/) |
| Monorepo layout (governance + delivery) | [architecture/monorepo-layout.md](architecture/monorepo-layout.md) |
| Strategic proposal (AAP, Puppet, GenAI) | [governance/strategic-proposal-aap-governance-evolution.md](governance/strategic-proposal-aap-governance-evolution.md) |
| AAP & Puppet three phases (§2) | [architecture/aap-puppet-coexistence-evolution.md](architecture/aap-puppet-coexistence-evolution.md) |
| How to structure repos | [architecture/](architecture/) |
| Role/playbook/inventory rules | [development/](development/) |
| Lint, review, idempotency | [quality/](quality/) |
| Controller, SSOT, operations | [operations/](operations/) |
| Worked examples | [examples/](examples/) |

---

## 10. Document control

| Field | Value |
|-------|-------|
| Audience | Automation engineers, architects, team leads |
| Maintainer | Automation department |
| Basis | Red Hat COP Automation Good Practices (GPA) |
| Language | English |
