# dev_troubleshoot_packages

Installs the standard package set for automation debugging on **lab** hosts only. Not for production.

## Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `dev_troubleshoot_packages_list` | Yes | Package names to install |

## Example

```yaml
- hosts: dev_linux
  roles:
    - dev_troubleshoot_packages
```
