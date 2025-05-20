#!/bin/bash
# Crear carpeta y activar SSH

mkdir -p "$HOME/repositorio"
cp /usr/share/doc/bash/README* "$HOME/repositorio" 2>/dev/null

sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
