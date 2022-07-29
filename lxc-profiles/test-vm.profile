# make sure to use this profile with a /cloud image!!
config:
  security.secureboot: false
  user.user-data: |
    #cloud-config
    ssh_pwauth: yes
    users:
       - name: test
         # passwd: test
         passwd: "$1$6U1HyAd4$uSEuhfVAOmuDS1HB9m1ZW0"
         lock_passwd: false
         groups: lxd
         shell: /bin/bash
         sudo: ALL=(ALL) NOPASSWD:ALL
devices:
  config:
    source: cloud-init:config
    type: disk

description: LXD profile for test virtual machines
name: test-vm
used_by: