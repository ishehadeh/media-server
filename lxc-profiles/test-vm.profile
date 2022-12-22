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
    write_files:
      - content: |
          #!/bin/sh
          # *try* to gracefully open port 22 with the distro's firewall of choice
          if command -v firewall-cmd >/dev/null; then
            firewall-cmd --zone=public --permanent --add-service=ssh
            firewall-cmd --reload
          elif command -v ufw >/dev/null; then
            ufw allow ssh
          elif command -v iptables >/dev/null; then
            iptables -I INPUT -p tcp -m tcp --dport 22 -j ACCEPT
          fi
        path: /tmp/ssh-open-firewall.sh

    write_files:
      - content: |
          #!/bin/sh
          if command -v dnf >/dev/null; then
            dnf install -y openssh
          elif command -v yum >/dev/null; then
            yum install -y openssh
          elif command -v apt >/dev/null; then
            apt install -y openssh-server
          elif command -v apt-get >/dev/null; then
            apt-get install -y openssh-server
          elif command -v pacman >/dev/null; then
            pacman -S --noconfirm openssh
          fi
        path: /tmp/ssh-install.sh

    runcmd:
      - sh /tmp/ssh-open-firewall.sh
      - sh /tmp/ssh-install.sh
      - systemctl enable sshd

description: LXD profile for test virtual machines
name: media-server/test-vm
used_by:
