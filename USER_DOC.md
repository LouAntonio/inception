# User Documentation

This document explains in clear and simple terms how an end user or administrator can interact with the Inception project stack architecture.

## Understand what services are provided by the stack
This infrastructure provides the following core services, each running within an isolated Docker container:
- **NGINX**: A performant web server acting as the single entrypoint to the website on port 443 strictly using the secure TLSv1.2 or TLSv1.3 protocol.
- **WordPress**: A widely used Content Management System (CMS) platform running alongside php-fpm to serve website content dynamically.
- **MariaDB**: An open-source relational database containing the WordPress tables and configuration payload.

## Start and stop the project
You can control the project's lifecycle from the root repository directory through the implementation provided in the `Makefile`.
- **To Start:** Run `make` to initiate the Docker Compose configuration, building the required images, and successfully launching internal networking and volumes. 
- **To Stop:** Run the designated Makefile shutdown block, commonly `make down` (depending on the internal make rule), to cleanly stop and remove all services without deleting persistent volumes.
- **To Fully Rebuild/Clean:** Run `make fclean` or `make re` to force the teardown of persistent volumes, prune custom images, and fully rebuild everything from scratch.

## Access the website and the administration panel
1. Ensure your local host machine has valid DNS mapping for the login-driven project domain. Add a new record in your host config mapping (e.g., in `/etc/hosts`, add `127.0.0.1 lantonio.42.fr`).
2. Open your preferred web browser and navigate directly to `https://lantonio.42.fr`. Due to the TLSv1.2/1.3 protocol configuration on port 443, you must connect securely. This drops you into the main WordPress landing page.
3. To access the administration panel for WordPress, navigate to `https://lantonio.42.fr/wp-admin` and login using the credentials properly configured for the non-default administrator account.

## Locate and manage credentials
- Essential credentials, such as API keys or system passwords, are securely stored locally inside your environment and ignored by Git source-control for maximum security policies.
- Ensure the presence of the hidden `.env` file within the `srcs/` directory. It maps general-purpose environment variables for project configurations (e.g. the domain identifier).
- Sensitive details like MariaDB Root, Database passwords or independent login records can be managed within distinct secrets (like `db_password.txt`) nested in a `secrets/` directory if deployed with Docker secrets according to valid setup guidelines.

## Check that the services are running correctly
Administrators can use default Docker CLI commands from the host terminal to ensure the proper active state of the application stack.
- Execute `docker compose -f srcs/docker-compose.yml ps` or `docker ps` to view real-time process monitoring for the NGINX, WordPress, and MariaDB containers. They must display an **"Up"** status under their lifecycle metrics.
- Assess log output live debugging for specific services utilizing `docker logs -f <container_name>` locally.
