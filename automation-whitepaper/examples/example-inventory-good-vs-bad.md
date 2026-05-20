# Example: Inventory Patterns — Good vs Bad

Based on GPA inventory examples in `automation-good-practices/inventories/inventory_loop_hosts/`.

---

## 1. Problem

Provision VMs via a "manager" host using variables—common with RHV, vCenter, or Satellite workflows.

---

## 2. Bad pattern: host list in variables

**Inventory groups:**

```ini
[managers]
manager_a
manager_b

[all:children]
managers
```

**`host_vars/manager_a/provision.yml`:**

```yaml
provision_hosts:
  - name: host1
    provision_value: uno
  - name: host2
    provision_value: dos
```

**Playbook loops the list:**

```yaml
- hosts: managers
  tasks:
    - name: Provision each host in list
      ansible.builtin.file:
        path: "/tmp/bad_{{ __provision_host.name }}"
        state: touch
      loop: "{{ provision_hosts }}"
      loop_control:
        loop_var: __provision_host
```

### Problems

- No `ansible-playbook --limit host1`
- No automatic parallelism across hosts
- Duplicates data already needed in inventory
- Second cluster needs duplicate group names or more lists

---

## 3. Good pattern: inventory drives the play

**Inventory groups:**

```ini
[managers]
manager_a
manager_b

[managed_hosts_a]
host1
host2

[managed_hosts_b]
host3

[all:children]
managers
managed_hosts_a
managed_hosts_b
```

**`host_vars/host1/provision.yml`:**

```yaml
provision_value: uno
```

**`group_vars/managed_hosts_a/provision.yml`:**

```yaml
manager_hostname: manager_a
```

**Playbook targets managed hosts:**

```yaml
- hosts: managed_hosts_a:managed_hosts_b
  strategy: free
  tasks:
    - name: Provision host via manager API (simulated)
      ansible.builtin.file:
        path: "/tmp/good_{{ inventory_hostname }}"
        state: touch
      delegate_to: "{{ manager_hostname }}"
```

### Benefits

```bash
# Parallel execution; limit subset
ansible-playbook -i inventory_good playbook_good.yml --limit host1
```

---

## 4. Cluster roles: avoid hardcoded groups

If a role must target cluster members, use:

```yaml
# defaults/main.yml
cluster_members: []

# tasks/main.yml
- name: Validate cluster members provided
  ansible.builtin.assert:
    that: cluster_members | length > 0
```

Set in inventory:

```yaml
# host_vars/node01/cluster.yml
cluster_members:
  - node01
  - node02
  - node03
```

See `automation-good-practices/roles/dont_use_groups/` for full playbook variants.

---

## 5. Variable file naming (structured inventory)

Match role defaults:

```
group_vars/middleware/
└── jboss.yml          # variables for role jboss

host_vars/host1.example.com/
├── ansible.yml        # connection
└── jboss.yml          # host-specific override
```

---

## 6. Related documents

- [../development/inventories-and-variables.md](../development/inventories-and-variables.md)
- [../operations/inventory-ssot-integration.md](../operations/inventory-ssot-integration.md)
