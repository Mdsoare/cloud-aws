#!/bin/bash

# Autor: Marcelo Soares
# Versão: 3.0
# Data: 28/03/2023 

echo "Script para provisionamento de infraestrutura como código"
echo "Modo de uso:"
echo "./iac3.bash"

# Define as variáveis
GRUPO_ADMINISTRATIVO="GRP_ADM"
GRUPO_VENDAS="GRP_VEN"
GRUPO_SECRETARIA="GRP_SEC"
SENHA_PADRAO=$(openssl passwd -crypt Senha123)

# Função para imprimir mensagem de erro e finalizar o script
error() {
  echo "Erro: $1"
  exit 1
}

# Verifica se o script está sendo executado como root
if [ $(id -u) -ne 0 ]; then
  error "Este script precisa ser executado como root."
fi

# Cria os diretórios
echo "Criando diretórios..."
for dir in "/publico" "/adm" "/ven" "/sec"; do
  mkdir -p $dir || error "Erro ao criar diretório $dir"
done

# Cria os grupos de usuários
echo "Criando grupos de usuários..."
for group in "$GRUPO_ADMINISTRATIVO" "$GRUPO_VENDAS" "$GRUPO_SECRETARIA"; do
  groupadd $group || error "Erro ao criar grupo $group"
done

# Cria os usuários e os adiciona aos grupos correspondentes
echo "Criando usuários..."
while IFS= read -r line; do
  fields=($line)
  username=${fields[0]}
  groupname=${fields[1]}
  useradd $username -m -s /bin/bash -p "$SENHA_PADRAO" -G "$groupname" || error "Erro ao criar usuário $username"
done <<EOF
carlos $GRUPO_ADMINISTRATIVO
maria $GRUPO_ADMINISTRATIVO
joao $GRUPO_ADMINISTRATIVO
debora $GRUPO_VENDAS
sebastiana $GRUPO_VENDAS
roberto $GRUPO_VENDAS
josefina $GRUPO_SECRETARIA
amanda $GRUPO_SECRETARIA
rogerio $GRUPO_SECRETARIA
EOF

# Define as permissões dos diretórios
echo "Especificando permissões dos diretórios...."
for dir in "/adm" "/ven" "/sec"; do
  chown root:$dir $dir || error "Erro ao definir permissões do diretório $dir"
  chmod 770 $dir || error "Erro ao definir permissões do diretório $dir"
done
chmod 777 /publico || error "Erro ao definir permissões do diretório /publico"

# Finaliza a execução do script
echo "Fim....."
