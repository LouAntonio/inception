#!/bin/bash

# check if db allrready exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Starting MariaDB for the first time..."


	# create the system tables of MariaDB
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	# start the service temporarilly in backgound to config the DB
	mysqld_safe --datadir=/var/lib/mysql &
	pid="$!"

	# wait for MariaDB get reay and recieve comands
	sleep 5

	# execute SQL comands to create DB, user and change root password
	mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
	mysql -u root -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@%' IDENTIFIED BY '${SQL_PASSWORD}';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
	mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
	mysql -u root -e "FLUSH PRIVILEGES;"

	echo "Database successfully created!"
	
	# turn off the service temporarelly with the new password
	mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
	
	# wait the bg proccess to end
	wait "$pid"
fi

echo "Starting MariaDB..."
exec mysqld_safe
