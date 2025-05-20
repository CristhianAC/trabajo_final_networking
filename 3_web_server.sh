#!/bin/bash
# Apache con sitios virtuales y SSL

sudo apt install -y apache2 openssl

# Crear estructura web
sudo mkdir -p /var/www/www.networkinglinux.com/html
sudo mkdir -p /var/www/intranet.networkinglinux.com/html

echo "<h1>Bienvenido a www.networkinglinux.com</h1>" | sudo tee /var/www/www.networkinglinux.com/html/index.html
echo "<h1>Bienvenido a intranet.networkinglinux.com</h1>" | sudo tee /var/www/intranet.networkinglinux.com/html/index.html

# Crear certificado autofirmado
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/networkinglinux.key \
  -out /etc/ssl/certs/networkinglinux.crt \
  -subj "/CN=www.networkinglinux.com"

# Configurar VirtualHosts
sudo bash -c 'cat <<EOF > /etc/apache2/sites-available/www.networkinglinux.com.conf
<VirtualHost *:80>
    ServerName www.networkinglinux.com
    Redirect permanent / https://www.networkinglinux.com/
</VirtualHost>

<VirtualHost *:443>
    ServerName www.networkinglinux.com
    DocumentRoot /var/www/www.networkinglinux.com/html
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/networkinglinux.crt
    SSLCertificateKeyFile /etc/ssl/private/networkinglinux.key
</VirtualHost>
EOF'

sudo bash -c 'cat <<EOF > /etc/apache2/sites-available/intranet.networkinglinux.com.conf
<VirtualHost *:80>
    ServerName intranet.networkinglinux.com
    DocumentRoot /var/www/intranet.networkinglinux.com/html
</VirtualHost>
EOF'

# Activar sitios y módulos
sudo a2enmod ssl
sudo a2ensite www.networkinglinux.com.conf
sudo a2ensite intranet.networkinglinux.com.conf
sudo systemctl reload apache2
