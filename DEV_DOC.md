# Developer Documentation

This document describes how a developer can set up, orchestrate, and manage the technical deployment of the Inception project.

## Set up the environment from scratch
1. Clone the repository directly into your designated Virtual Machine running Alpine or Debian.
2. Ensure you have properly declared all prerequisites:
   - Provide a `.env` file within the `srcs` directory with environment variables containing the domain footprint (e.g. `DOMAIN_NAME=lantonio.42.fr`).
   - Create a local un-versioned setup (e.g., inside `.env` or using Docker Secrets locally) keeping confidential variables (`db_password`, `db_root_password`, `credentials.txt`) strictly obfuscated. Avoid accidentally pushing clear passwords to Git.
3. Because persistent storages rely on Docker named volumes mapping to host absolute paths, configure your host directories reliably. E.g., spawn the data root under `/home/lantonio/data`, ensuring child directory isolation for `wordpress` and `mariadb`.
4. Modify your virtual machine `/etc/hosts` file routing the physical loopback IP `127.0.0.1` against your assigned subject domain, i.e., `lantonio.42.fr`.

## Build and launch the project
The entire entry-point compilation is unified cleanly by our automated `Makefile`.
Build the custom service images and begin runtime deployment into Docker Compose networks navigating to the repository root and executing:
```bash
make
```
The above process signals `docker-compose` acting on `srcs/docker-compose.yml`. This rule links all our locally sourced Alpine/Debian Dockerfiles, sets up TLS configuration mapping on NGINX, integrates MariaDB to WordPress over a custom Bridge network exclusively, establishes persistent persistent volumes, and bootstraps daemons gracefully.

## Use relevant commands to manage containers and volumes
Operating the containers dynamically as a backend developer necessitates typical native Docker CLI commands:
- **Container status & discovery:** `docker ps` mapping current ports and daemon identifiers.
- **Accessing NGINX:** Test certificates interactively using `docker exec -it nginx sh`.
- **Querying Database:** Inject queries manually bypassing NGINX opening an ongoing bash inside `docker exec -it mariadb sh`.
- **Read runtime logs:** Audit any container deployment warnings with `docker compose -f srcs/docker-compose.yml logs -f`.
- **Destructive Volume commands:** Free up hard disk persistent storage correctly by locating `docker volume ls` and executing `docker volume rm <volume-name_or_hash>`.

## Identify where project data is stored and how it persists
Data persistence across failures or generic reboot stages relies entirely on robust **Docker Named Volumes** and categorically restricted bind mounts.
- Inside `srcs/docker-compose.yml`, mapped volume volumes guarantee safe-storage abstraction.
- Important **WordPress** codebase blocks are anchored locally under `/home/lantonio/data/wordpress`.
- Crucial **MariaDB** metadata databases mirror internally into static footprints mounted on `/home/lantonio/data/mariadb` avoiding any relational data dropouts if the SQL container crashes asynchronously.
