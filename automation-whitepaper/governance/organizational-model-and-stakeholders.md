# Organizational Model and Stakeholders

Automation in large Spanish enterprises sits at the intersection of **central IT**, **line-of-business applications**, and **regulated change processes**. This document defines who participates and when.

---

## 1. Automation department core

| Role | Responsibility |
|------|----------------|
| **Automation lead** | Standards, architecture alignment, prioritization with IT management |
| **Automation engineer** | Design, implement, test roles/playbooks/workflows |
| **Platform engineer** | Controller, execution environments, credentials, integrations |
| **Quality champion** | Lint profiles, review checklist, CI templates |

---

## 2. Traditional enterprise teams (Spain context)

Spanish organizations often mirror a **functional IT model** with strong **Change Management** and **information security** oversight. The table below maps typical departments to automation touchpoints.

### 2.1 Business and applications

| Team | Typical names | Automation involvement |
|------|---------------|------------------------|
| **Business owner** | Responsable de negocio, Product Owner | Defines outcomes, accepts automation scope, signs off UAT |
| **Application team** | Desarrollo, Mantenimiento aplicaciones | Provides app-specific variables, validation steps, deployment windows |
| **Project management (PMO)** | Oficina de proyectos | Coordinates cross-team timelines for landscape rollouts |

**When to involve:** Intake, design review for application-typed hosts, UAT, go-live communication.

### 2.2 Infrastructure and operations

| Team | Typical names | Automation involvement |
|------|---------------|------------------------|
| **Systems / Infrastructure** | Sistemas, Infraestructura | Owns OS standards, patching baselines, handover to operations |
| **Cloud / Virtualization** | Cloud, VMware, OpenStack | SSOT for VMs; network placement; quotas |
| **Network** | Redes | Firewall rules, VLANs, load balancers referenced in inventory or roles |
| **Storage / Backup** | Almacenamiento, Copias de seguridad | Backup policies before destructive changes |
| **Database** | DBA, Bases de datos | Schema/migration steps not blindly automated without DBA sign-off |

**When to involve:** Design (connectivity, naming), implementation (platform vars), production run approval.

### 2.3 Service management and operations support

| Team | Typical names | Automation involvement |
|------|---------------|------------------------|
| **Service Desk** | Mesa de servicio, CAU | User-facing incident communication when jobs affect services |
| **NOC / Monitoring** | NOC, Monitorización | Alerting on job failures; maintenance calendar |
| **CMDB / ITSM** | ServiceNow, Jira SM, GLPI | Authoritative To-Be attributes; change records |

**When to involve:** Before production jobs; linking automation job ID to change ticket; post-incident review.

### 2.4 Governance, risk, and compliance

| Team | Typical names | Automation involvement |
|------|---------------|------------------------|
| **Change Advisory Board (CAB)** | Comité de cambios | Approves production execution windows |
| **Information Security** | CISO, Seguridad informática, SOC | Reviews privileged playbooks, secrets handling, logging |
| **Compliance / Internal audit** | Cumplimiento, Auditoría | Evidence of who ran what, when (Controller audit trail) |
| **Data Protection (DPO)** | DPD, Privacidad | When automation processes personal data (logs, inventories) |

**When to involve:** Security review before first prod run; CAB for Normal/Standard changes per policy; DPO when inventories contain personal identifiers.

### 2.5 Supporting functions

| Team | Typical names | Automation involvement |
|------|---------------|------------------------|
| **Procurement / Vendor** | Compras, Proveedores | RHEL/AAP subscriptions, support entitlements |
| **HR / Identity** | RRHH, Identidad | Indirect—feeds IAM for technical accounts used by automation |
| **Legal** | Legal | Contracts for cloud APIs and third-party modules |

**When to involve:** Platform renewals; onboarding new SSOT integrations with external vendors.

---

## 3. Engagement model by lifecycle phase

| Phase | Required participants | Optional |
|-------|----------------------|----------|
| Intake | Business or Operations requester, Automation lead | PMO |
| Design | Automation engineer, Systems, Application (if app-specific) | Network, DBA, Security (early) |
| Build | Automation engineer | Application (variable validation) |
| Test | Automation engineer, Application or Systems (UAT) | Security (pen-test playbooks) |
| Release | Automation lead, CAB (prod), Security (high risk) | Service Desk (comms) |
| Operate | Operations, NOC | Business (reports) |
| Retire | Automation lead, CMDB owner, Application | Compliance (archive evidence) |

---

## 4. Communication patterns

1. **Single automation owner** per initiative (named in ticket).
2. **Design record** (short ADR or wiki page): landscape/type/functions, SSOTs, risks.
3. **Change record** mandatory for production Controller jobs affecting customer-facing or critical internal services.
4. **Runbook link** in job template description for Operations handover.

---

## 5. Anti-patterns

| Anti-pattern | Why it fails |
|--------------|--------------|
| Automation team deploys to prod without Operations awareness | No handover; incidents blame "scripts" |
| Skipping CAB because "it's only Ansible" | Violates audit and insurance requirements common in regulated sectors |
| CMDB updated manually after automation | As-Is/To-Be drift; next run may undo or conflict |
| Security review only at go-live | Rework and delays; secrets embedded in playbooks |

---

## 6. Related documents

- [roles-and-responsibilities.md](roles-and-responsibilities.md)
- [../lifecycle/intake-and-prioritization.md](../lifecycle/intake-and-prioritization.md)
- [../guides/glossary.md](../guides/glossary.md) · [../examples/example-enterprise-change-flow.md](../examples/example-enterprise-change-flow.md)
