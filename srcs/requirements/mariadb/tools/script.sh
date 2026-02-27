#!/bin/bash

set -e

echo "Iniciando MariaDB em modo temporário..."

# Inicia o servidor em background
mariadbd-safe --datadir=/var/lib/mysql &
pid="$!"

# Aguarda até o servidor aceitar conexões
echo "Aguardando MariaDB ficar disponível..."
until mariadb-admin ping --silent; do
	sleep 1
done

echo "MariaDB iniciado com sucesso."

# Só configura se a base de dados ainda não existir
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
	echo "Configurando base de dados e utilizadores..."

	mariadb -u root <<EOF
	CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
	FLUSH PRIVILEGES;
EOF

	echo "Configuração concluída."
else
	echo "Base de dados já existe, ignorando configuração inicial."
fi

# Encerra a instância temporária
echo "Encerrando instância temporária..."
mariadb-admin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

wait "$pid"

echo "Iniciando MariaDB em foreground (PID 1)..."
exec mariadbd-safe --datadir=/var/lib/mysql

