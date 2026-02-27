FROM debian:bookworm

# Install PHP and extensions for WP, MariaDB client and dependencies
RUN apt-get update && apt-get install -y \
	php8.2-fpm \
	php8.2-mysqli \
	php8.2-curl \
	php8.2-dom \
	php8.2-exif \
	php8.2-fileinfo \
	php8.2-mbstring \
	php8.2-xml \
	php8.2-zip \
	mariadb-client \
	curl \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Creates the folder for PID and PHP-FPM and the site folder
RUN mkdir -p /run/php /var/www/wordpress \
    && chown -R www-data:www-data /var/www/wordpress

# cpy the personalized configs
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# cpy the init script amd gib«ves it exec permitions
COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

# Exposes the port
EXPOSE 9000

# Defines the main directory
WORKDIR /var/www/wordpress

# Startup via script
ENTRYPOINT ["/usr/local/bin/script.sh"]
