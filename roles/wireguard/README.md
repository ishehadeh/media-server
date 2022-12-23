# ansible-role-wireguard

Install and configure wireguard.

## Usage

```yml
---
- hosts: (...)
  become: true
  roles:
    - role: '../../'
      wireguard_devices:
        wg0:
            addresses: 192.168.1.2/24
            state: present
```

### Tags

- `wireguard_install`: tasks involving install the kernel module
- `wireguard_devices`: tasks for creating/removing wireguard devices
