#!/bin/bash

# Autor: Marcelo Soares
# Versão: 2.0
# Data: 28/03/2023 

set -e # Encerra a execução do script em caso de erro
# Verifica se o script está sendo executado como root
if [ $(id -u) -ne 0 ]; then
  echo "Este script precisa ser executado como root."
  exit 1
fi

# Define as variáveis locais
GRUPO_ADMINISTRATIVO="GRP_ADM"
GRUPO_VENDAS="GRP_VEN"
GRUPO_SECRETARIA="GRP_SEC"
SENHA_PADRAO=$(openssl passwd -crypt Senha123)

# Cria os diretórios necessários
echo "Criando diretórios..."
for diretorio in /publico /adm /ven /sec; do
  if [ ! -d "$diretorio" ]; then
    mkdir "$diretorio"
    echo "Diretório $diretorio criado com sucesso."
  fi
done

# Cria os grupos de usuários
echo "Criando grupos de usuários..."
for grupo in $GRUPO_ADMINISTRATIVO $GRUPO_VENDAS $GRUPO_SECRETARIA; do
  if ! getent group "$grupo" >/dev/null; then
    groupadd "$grupo"
    echo "Grupo $grupo criado com sucesso."
  fi
done

# Cria os usuários e os adiciona aos grupos correspondentes
echo "Criando usuários..."
for usuario in carlos maria joao debora sebastiana roberto josefina amanda rogerio; do
  if ! id "$usuario" >/dev/null 2>&1; then
    useradd "$usuario" -m -s /bin/bash -p "$SENHA_PADRAO"
    echo "Usuário $usuario criado com sucesso."
  fi
  case "$usuario" in
    carlos|maria|joao)
      usermod -aG "$GRUPO_ADMINISTRATIVO" "$usuario"
      ;;
    debora|sebastiana|roberto)
      usermod -aG "$GRUPO_VENDAS" "$usuario"
      ;;
    josefina|amanda|rogerio)
      usermod -aG "$GRUPO_SECRETARIA" "$usuario"
      ;;
  esac
done

# Define as permissões dos diretórios
echo "Especificando permissões dos diretórios...."
chown root:$GRUPO_ADMINISTRATIVO /adm
chown root:$GRUPO_VENDAS /ven
chown root:$GRUPO_SECRETARIA /sec

chmod 770 /adm /ven /sec
chmod 777 /publico

echo "Fim....."
