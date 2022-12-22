# LXD

Ansible scripts are tested by running them in LXD virtual machines.

## Setup

_first time only_: create and update the test profile

```sh
lxc profile create test-vm
lxc profile edit test-vm <lxc-profiles/test-vm.profile
```

Make sure lxd is allowed to create unprivilaged containers with

```sh
echo "root:1000000:1000000000" | sudo tee -a /etc/subuid /etc/subgid
```

([SOURCE](https://web.archive.org/web/20221119105834/https://linuxcontainers.org/lxd/docs/master/installing/))

## Start Test VMS

Example:

```sh
lxc launch images:ubuntu/22.04/cloud --profile default --profile test-vm ansible-test01
```

## Run Test Playbooks using `test-environment/inventory`

```sh
ansible-playbook -i test-environment/inventory roles/install_docker/tests/playbook.yml
```
