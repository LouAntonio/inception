#!/bin/bash

set -e

echo "Starting MariaDB..."

# Start the server in fg
mariadbd-safe --datadir=/var/lib/mysql &
pid="$!"

# Wait untill server is up
echo "Waiting for MariaDB to be ready..."
until mariadb-admin ping --silent; do
	sleep 1
done

echo "MariaDB started successfully."

# Configs if database doesn't exist
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
	echo "Config Database and Users..."

	mariadb -u root <<EOF
	CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
	FLUSH PRIVILEGES;
EOF

	echo "Configs applied."
else
	echo "Database already exists."
fi

# Shutdown the server
echo "Shutting down MariaDB..."
mariadb-admin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

wait "$pid"

echo "Starting MariaDB in foreground (PID 1)..."
exec mariadbd-safe --datadir=/var/lib/mysql
