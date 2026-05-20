# Example: Role Interface and Platform Variables

Combines GPA patterns for **facade role**, **naming**, **platform vars**, and **argument_specs**.

---

## 1. Facade role (`timesync.run`)

Consumer playbook stays stable when internal roles change.

```yaml
---
- name: Configure time synchronization on all servers
  hosts: linux_servers
  gather_facts: false
  become: true
  tasks:
    - name: Apply time sync role bundle
      ansible.builtin.include_role:
        name: company_linux.timesync_run
      vars:
        actions:
          - name: configure_chrony
            vars:
              timesync_servers:
                - ntp1.corp.example.com
                - ntp2.corp.example.com
```

**Avoid** exposing `include_role: company_linux.chrony` + `include_role: company_linux.ntp` order to consumers.

---

## 2. Naming in `timesync_chrony` role

**`defaults/main.yml`:**

```yaml
timesync_chrony_servers: []
timesync_chrony_allow_networks: []
timesync_chrony_provider: "{{ timesync_chrony_provider_os_default | default(omit) }}"
```

**`vars/RedHat_8.yml`:**

```yaml
timesync_chrony_packages:
  - chrony
timesync_chrony_service: chronyd
```

**Internal (`vars/main.yml` or set_fact):**

```yaml
__timesync_chrony_config_path: /etc/chrony.conf
```

---

## 3. Platform variable loading (`tasks/set_vars.yml`)

```yaml
---
- name: Ensure ansible_facts used by role
  ansible.builtin.setup:
    gather_subset: min
  when: ansible_facts.keys() | list | intersect(__timesync_chrony_required_facts) != __timesync_chrony_required_facts

- name: Set platform/version specific variables
  ansible.builtin.include_vars: "{{ __timesync_chrony_vars_file }}"
  loop:
    - "{{ ansible_facts['os_family'] }}.yml"
    - "{{ ansible_facts['distribution'] }}.yml"
    - "{{ ansible_facts['distribution'] }}_{{ ansible_facts['distribution_major_version'] }}.yml"
  loop_control:
    loop_var: __timesync_chrony_vars_candidate
  vars:
    __timesync_chrony_vars_file: "{{ role_path }}/vars/{{ __timesync_chrony_vars_candidate }}"
  when: __timesync_chrony_vars_file is file
```

**`tasks/main.yml`:**

```yaml
---
- name: Set platform/version specific variables
  ansible.builtin.include_tasks: set_vars.yml

- name: chrony | Ensure packages installed
  ansible.builtin.package:
    name: "{{ timesync_chrony_packages }}"
    state: present

- name: chrony | Deploy configuration
  ansible.builtin.template:
    src: chrony.conf.j2
    dest: "{{ timesync_chrony_config_path }}"
    backup: true
  notify: Restart chronyd
```

Note task prefix `chrony |` from sub-task file convention.

---

## 4. Provider selection

```yaml
# tasks/select_provider.yml
- name: Set OS default provider fact
  ansible.builtin.set_fact:
    timesync_chrony_provider_os_default: chrony

- name: Use running provider if unset
  ansible.builtin.set_fact:
    timesync_chrony_provider: "{{ ansible_facts.services['ntpd.service'] is defined | ternary('ntpd', timesync_chrony_provider_os_default) }}"
  when: timesync_chrony_provider is not defined
```

---

## 5. Argument specification

**`meta/argument_specs.yml`:**

```yaml
---
argument_specs:
  main:
    short_description: Configure chrony-based time synchronization
    options:
      timesync_chrony_servers:
        type: list
        elements: str
        required: true
        description: List of NTP server hostnames or IPs
      timesync_chrony_allow_networks:
        type: list
        elements: str
        default: []
        description: Networks allowed to query this host
```

---

## 6. Template header

**`templates/chrony.conf.j2`:**

```jinja2
# {{ ansible_managed | comment }}
# Role: timesync_chrony — do not edit manually

{% for server in timesync_chrony_servers %}
server {{ server }} iburst
{% endfor %}
```

No `Last modified: {{ ansible_date_time.iso8601 }}` — would force change every run.

---

## 7. README excerpt (consumer doc)

| Item | Value |
|------|-------|
| Outcome | Chrony configured and running |
| Idempotent | Yes |
| Check mode | Supported |
| Replaces file | `/etc/chrony.conf` |
| Rollback | Restore from `.bak` created by module backup |

---

## 8. Related documents

- [../development/roles.md](../development/roles.md)
- [../quality/idempotency-and-check-mode.md](../quality/idempotency-and-check-mode.md)
