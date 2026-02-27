FROM debian:bookworm

# update packages and install mariadb
RUN apt-get update && apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

# create the folders to sockets and PIDs
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# copy personalized conf
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# copy startup script and gives it exec permition
COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/script.sh"]
