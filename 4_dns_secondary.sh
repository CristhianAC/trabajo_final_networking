#!/bin/bash
# DNS Secundario

sudo apt install -y bind9

sudo bash -c 'cat <<EOF > /etc/bind/named.conf.local
zone "networkinglinux.com" {
  type slave;
  masters { 192.168.1.10; };
  file "/var/cache/bind/db.networkinglinux.com";
};
EOF'

sudo systemctl restart bind9
