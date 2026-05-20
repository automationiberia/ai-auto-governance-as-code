# rsyslog_forward

Configure rsyslog to forward logs to a central relay.

| Item | Value |
|------|-------|
| Idempotent | Yes |
| Check mode | Supported |
| Replaces | `/etc/rsyslog.d/99-forward.conf` |
| Rollback | Restore `.bak` from template module |

## Example

```yaml
- hosts: linux_logging
  roles:
    - role: company.linux.rsyslog_forward
      vars:
        rsyslog_forward_relay_host: siem-relay.corp.example.com
```
