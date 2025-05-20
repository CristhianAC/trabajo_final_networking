#!/bin/bash

REPO="192.168.1.10:/home/usuario/repositorio"
LOCAL_DIR="$HOME/cliente_files"

mkdir -p "$LOCAL_DIR"

function listar_archivos() {
  ssh usuario@192.168.1.10 "ls ~/repositorio"
}

function copiar_a_repo() {
  read -p "Archivo a enviar: " archivo
  if [ -f "$archivo" ]; then
    scp "$archivo" usuario@192.168.1.10:~/repositorio/
  else
    echo -e "\e[31mArchivo no existe\e[0m"
  fi
}

function copiar_de_repo() {
  read -p "Archivo a descargar: " archivo
  scp usuario@192.168.1.10:~/repositorio/"$archivo" "$LOCAL_DIR"
}

function estado_servicios() {
  for servicio in apache2 bind9 isc-dhcp-server ssh; do
    estado=$(systemctl is-active "$servicio" 2>/dev/null)
    if [ "$estado" == "active" ]; then
      echo -e "$servicio ... \e[32mACTIVO\e[0m"
    else
      echo -e "$servicio ... \e[31mINACTIVO\e[0m"
    fi
  done
}

function mostrar_menu() {
  echo "1) Listar archivos en repositorio"
  echo "2) Subir archivo a repositorio"
  echo "3) Descargar archivo del repositorio"
  echo "4) Ver estado de los servicios"
  echo "5) Ayuda"
  echo "0) Salir"
}

function ayuda() {
  echo "#client_script - Script cliente para conectarse al servidor"
  echo "Uso interactivo con menú. Realiza operaciones SSH/SCP y verifica estado de servicios."
}

while true; do
  mostrar_menu
  read -p "Elige una opción: " op
  case $op in
    1) listar_archivos ;;
    2) copiar_a_repo ;;
    3) copiar_de_repo ;;
    4) estado_servicios ;;
    5) ayuda ;;
    0) break ;;
    *) echo "Opción inválida" ;;
  esac
done
