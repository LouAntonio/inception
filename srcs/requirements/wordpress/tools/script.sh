#!/bin/bash

cd /var/www/wordpress

if [ ! -f "wp-config.php" ]; then
	echo "Downloading WordPress..:"
	wp core download --allow-root

	echo "Waiting for DB..."
	while ! mariadb -h mariadb -u ${SQL_USER} -p${SQL_PASSWORD} ${SQL_DATABASE} -e "SELECT 1;" >/dev/null2>&1; do
		sleep 2
	done
	echo "DB ready!"

	echo "Creating config file..."
	wp config create	--dbname=${SQL_DATABASE} \
						--dbuser=${SQL_USER} \
						--dbpass=${DB_PASSWORD} \
						--dbhost=mariadb \
						--allow-root

	echo "Instaling WordPress..."
	wp core install		--url=${DOMAIN_NAME} \
						--title=${WP_TITLE} \
						--admin_user=${WP_ADMIN_USER} \
						--admin_email="admin@lantonio.42.fr" \
						--skip-email \
						--allow-root

	echo "Creating a second user..."
	wp core create		--${WP_USER} "user@lantonio.42.fr" \
						--role=author \
						--user_pass=${WP_PASSWORD} \
						--allow-root

	echo "WordPress instalation concluded!"
else
	echo "Wordpress instaled and configured!"
fi

echo "Starting PHP_FPM in foreground..."

exec php-fpm8.2 -F
