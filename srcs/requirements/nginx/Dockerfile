FROM debian:13

# Update and install NGINX and OpenSSL
RUN apt-get update && apt-get install -y nginx openssl \
	&& rm -rf /var/lib/apt/lists/*

# Creates the folder to keep the SSL certificates
RUN mkdir -p /etc/nginx/ssl

# generates the auto-signed SSL certificate
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj \
"/C=AO/ST=Luanda/L=Luanda/O=42/OU=42/CN=lantonio.42.fr/UID=lantonio"

# Crestes the folder for PID and NGINX
RUN mkdir -p /var/run/nginx

# cpy the personalized configs
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# Startup in foreground
CMD [ "nginx", "-g", "daemon off;" ]

