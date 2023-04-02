#!/bin/bash

# Autor: Marcelo Soares
# Versão: 1.0
# Data: 02/04/2023 

# Script para atualização e instalação de dependências do servidor
# e cópia dos arquivos de uma aplicação

echo "Script para provisionamento de Web Server Apache"
echo "Modo de uso:"
echo "script-iac2.bash"

# Atualização do servidor
echo "Atualizando o servidor..."
apt-get update && apt-get upgrade -y

# Instalação de dependências
echo "Instalando dependências..."
apt-get install apache2 unzip -y

# Baixando e copiando os arquivos da aplicação
echo "Baixando e copiando os arquivos da aplicação..."
cd /tmp
wget https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
unzip main.zip
cd linux-site-dio-main
cp -R * /var/www/html/

# Fim do script
echo "Script finalizado."
