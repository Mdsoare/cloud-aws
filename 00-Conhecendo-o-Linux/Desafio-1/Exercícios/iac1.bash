#!/bin/bash

# Autor: Marcelo Soares
# Versão: 1.0
# Data: 28/03/2023 

echo "Script para provisionamento de infraestrutura como código"
echo "Modo de uso:"
echo "./iac1.bash"

set -e # Encerra a execução do script em caso de erro

# Verifica se o script está sendo executado como root
if [ $(id -u) -ne 0 ]; then
  echo "Este script precisa ser executado como root."
  exit 1
fi

# Define as variáveis
GRUPO_ADMINISTRATIVO="GRP_ADM"
GRUPO_VENDAS="GRP_VEN"
GRUPO_SECRETARIA="GRP_SEC"
SENHA_PADRAO=$(openssl passwd -crypt Senha123)

# Cria os diretórios
echo "Criando diretórios..."
mkdir -p /publico || { echo "Erro ao criar diretório /publico"; exit 1; }
mkdir -p /adm || { echo "Erro ao criar diretório /adm"; exit 1; }
mkdir -p /ven || { echo "Erro ao criar diretório /ven"; exit 1; }
mkdir -p /sec || { echo "Erro ao criar diretório /sec"; exit 1; }

# Cria os grupos de usuários
echo "Criando grupos de usuários..."
groupadd "$GRUPO_ADMINISTRATIVO" || { echo "Erro ao criar grupo $GRUPO_ADMINISTRATIVO"; exit 1; }
groupadd "$GRUPO_VENDAS" || { echo "Erro ao criar grupo $GRUPO_VENDAS"; exit 1; }
groupadd "$GRUPO_SECRETARIA" || { echo "Erro ao criar grupo $GRUPO_SECRETARIA"; exit 1; }

# Cria os usuários e os adiciona aos grupos correspondentes
echo "Criando usuários..."
useradd carlos -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_ADMINISTRATIVO" || { echo "Erro ao criar usuário carlos"; exit 1; }
useradd maria -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_ADMINISTRATIVO" || { echo "Erro ao criar usuário maria"; exit 1; }
useradd joao -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_ADMINISTRATIVO" || { echo "Erro ao criar usuário joao"; exit 1; }

useradd debora -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_VENDAS" || { echo "Erro ao criar usuário debora"; exit 1; }
useradd sebastiana -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_VENDAS" || { echo "Erro ao criar usuário sebastiana"; exit 1; }
useradd roberto -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_VENDAS" || { echo "Erro ao criar usuário roberto"; exit 1; }

useradd josefina -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_SECRETARIA" || { echo "Erro ao criar usuário josefina"; exit 1; }
useradd amanda -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_SECRETARIA" || { echo "Erro ao criar usuário amanda"; exit 1; }
useradd rogerio -m -s /bin/bash -p "$SENHA_PADRAO" -G "$GRUPO_SECRETARIA" || { echo "Erro ao criar usuário rogerio"; exit 1; }

# Define as permissões dos diretórios
echo "Especificando permissões dos diretórios...."
chown root:"$GRUPO_ADMINISTRATIVO" /adm
chown root:"$GRUPO_VENDAS" /ven
chown root:"$GRUPO_SECRETARIA" /sec

chmod 770 /adm /ven /sec
chmod 777 /publico

# Finaliza a execução do script
echo "Fim....."