#!/bin/bash
# Servidor DNS primario

sudo apt install -y bind9

sudo bash -c 'cat <<EOF > /etc/bind/named.conf.local
zone "networkinglinux.com" {
  type master;
  file "/etc/bind/db.networkinglinux.com";
  allow-transfer { 192.168.1.11; };
};
EOF'

sudo cp /etc/bind/db.local /etc/bind/db.networkinglinux.com

sudo sed -i 's/localhost./networkinglinux.com./' /etc/bind/db.networkinglinux.com
sudo sed -i 's/127.0.0.1/192.168.1.10/' /etc/bind/db.networkinglinux.com
sudo bash -c 'echo -e "www\tIN\tA\t192.168.1.10\nintranet\tIN\tA\t192.168.1.10" >> /etc/bind/db.networkinglinux.com'

sudo systemctl restart bind9
