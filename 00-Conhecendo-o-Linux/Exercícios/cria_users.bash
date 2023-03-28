#!/bin/bash

# Autor: Marcelo Soares
# Versão: 1.0
# Data: 28/03/2023 

echo "Script para criação de usuários em lote"
echo "Modo de uso:"
echo "./cria_users.bash lista.txt"

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

# Loop para adicionar os usuários
while read -r nome_usuario || [[ -n "$nome_usuario" ]]; do
  # Adicionando o usuário
  echo "Adicionando o usuário $nome_usuario"
  
  # Criando diretório home/"$nome_usuario" e setando o shell bash
  useradd -m -s /bin/bash "$nome_usuario"
  
  # Definindo uma senha padrão
  senha_padrao=$(openssl passwd -crypt Senha123)
  echo "$nome_usuario:$senha_padrao" | chpasswd
  
  # Forçando a troca de senha no primeiro login
  # passwd "$nome_usuario" -e
  chage -d 0 "$nome_usuario" 
  
  # Adicionando o usuário aos grupos "sudo" e "adm"
  # gpasswd -a "$nome_usuario" sudo,adm
  usermod -aG sudo,adm "$nome_usuario"
done < "$1"
