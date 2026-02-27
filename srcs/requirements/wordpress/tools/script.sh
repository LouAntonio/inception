#!/bin/bash

cd /var/www/wordpress

# Start PHP-FPM in background first to accept connections from nginx
echo "Starting PHP-FPM in background..."
php-fpm8.2 -F &
php_fpm_pid=$!

if [ ! -f "wp-config.php" ]; then
	echo "Downloading WordPress..:"
	wp core download --allow-root

	echo "Waiting for DB..."
	while ! mariadb -h mariadb -u ${SQL_USER} -p${SQL_PASSWORD} ${SQL_DATABASE} -e "SELECT 1;" >/dev/null 2>&1; do
		sleep 2
	done
	echo "DB ready!"

	echo "Creating config file..."
	wp config create	--dbname=${SQL_DATABASE} \
						--dbuser=${SQL_USER} \
						--dbpass=${SQL_PASSWORD} \
						--dbhost=mariadb \
						--allow-root

	echo "Instaling WordPress..."
	wp core install		--url=${DOMAIN_NAME} \
						--title=${WP_TITLE} \
						--admin_user=${WP_ADMIN_USER} \
						--admin_password=${WP_ADMIN_PASSWORD} \
						--admin_email="admin@lantonio.42.fr" \
						--skip-email \
						--allow-root

	echo "Creating a second user..."
	wp user create		${WP_USER} "user@lantonio.42.fr" \
						--role=author \
						--user_pass=${WP_PASSWORD} \
						--allow-root

	echo "WordPress instalation concluded!"
else
	echo "Wordpress instaled and configured!"
fi

echo "WordPress setup complete. Keeping container alive..."

# Keep the container running by waiting for PHP-FPM process
wait $php_fpm_pid
