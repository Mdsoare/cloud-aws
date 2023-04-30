#!/bin/bash

# Autor: Marcelo Soares
# Versão: 1.0
# Data: 28/03/2023 

echo "Script para remoção de usuários em lote"
echo "Modo de uso:"
echo "./remove_users.bash lista.txt"

# Função para imprimir mensagens de erro e sair do script
# $1 - mensagem de erro
function error() {
  echo "Erro: $1"
  exit 1
}

# Verifica se o arquivo de usuários foi passado como parâmetro corretamente
if [ $# -eq 0 ]; then 
  error "Informe o nome do arquivo de usuários como parâmetro"
elif [ $# -ne 1 ]; then
  error "Informe o nome do arquivo de usuários corretamente"
fi

# Verifica se o arquivo de usuários existe
if [ ! -f "$1" ]; then
  error "Arquivo de usuários não encontrado"
fi

# Loop para remover os usuários
while read -r nome_usuario || [[ -n "$nome_usuario" ]]; do
    # Removendo o usuário
    echo "Removendo o usuário $nome_usuario"
    if ! userdel -f "$nome_usuario"; then
        echo "Erro ao remover o usuário $nome_usuario"
        exit 1
    fi
    
    # Limpando os arquivos relacionados ao usuário
    echo "Limpando os vestígios de criação do usuário $nome_usuario"
    rm -rf "/home/$nome_usuario"
    sed -i "/$nome_usuario/d" /etc/passwd
    sed -i "/$nome_usuario/d" /etc/group
    sed -i "/$nome_usuario/d" /etc/shadow
done < "$1"
