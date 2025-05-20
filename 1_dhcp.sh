#!/bin/bash
# DHCP Server Setup

sudo apt update
sudo apt install -y isc-dhcp-server

sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak

cat <<EOF | sudo tee /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;
option domain-name "networkinglinux.com";
option domain-name-servers 192.168.1.10;
authoritative;
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.200;
  option routers 192.168.1.1;
  option domain-name-servers 192.168.1.10;
}
EOF

# Interfaz a usar (ajustar según el nombre de tu interfaz)
sudo sed -i 's/INTERFACESv4=""/INTERFACESv4="enp0s3"/' /etc/default/isc-dhcp-server

sudo systemctl restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server
