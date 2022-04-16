#!/bin/sh
set -e

ANSIBLE_INVENTORY=${ANSIBLE_INVENTORY:-"$PWD/inventory.yml"}
get_host_to_nebula_ips() {
    ansible-inventory -i "$ANSIBLE_INVENTORY" --list | jq -r '._meta.hostvars | to_entries | .[] | select(.value.nebula_ip != null) | "\(.key) \(.value.nebula_ip)"'
}

mkdir -p certs
cd certs
get_host_to_nebula_ips | while read -r host nebula_ip; do
    [ -f "./$host.crt" ] && [ -f "./$host.key" ] || nebula-cert sign -name "$host" -ip "$nebula_ip/24"
done