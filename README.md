*This project has been created as part of the 42 curriculum by lantonio.*

# Inception

## Description
This project aims to broaden knowledge of system administration by deploying a virtualization architecture using Docker. It consists of setting up a complete and functional small-scale internet infrastructure containing different services under strict rules inside a virtual machine. This includes virtualizing several Docker images inside dedicated containers to create an NGINX web server, a WordPress platform powered by php-fpm, and a MariaDB database backend.

## Project description
This architecture utilizes **Docker** to containerize our required services, avoiding heavy monolithic implementations and instead assigning a dedicated container for each component. The required sources provided in this project enforce the usage of custom Dockerfiles to build images independently over the penultimate stable version of either Alpine or Debian. An orchestrator `docker-compose.yml` ties the webserver, application, and database together under a custom internal network. The deployment process is fully automated by a root Makefile.

### Design Choices & Comparisons

- **Virtual Machines vs Docker:** 
  Virtual Machines rely on a hypervisor to emulate entirely functional hardware and an independent guest operating system, which guarantees maximum isolation but utilizes heavy system resources. Docker uses containerization at the OS level, meaning all containers share the host's Linux Kernel. This makes Docker containers drastically faster, more lightweight, and much more portable compared to Virtual Machines, while still providing robust application isolation.

- **Secrets vs Environment Variables:** 
  Environment Variables are flexible settings declared in memory to modify an application's behavior at runtime, usually sourced from a `.env` file. However, standard environment variables can be exposed to unintended processes or visible if an attacker inspects process arguments. Docker Secrets, on the other hand, are a much more secure feature to manage confidential data like passwords or API keys, as they are securely injected and mounted in-memory only into the containers that explicitly need access to them.

- **Docker Network vs Host Network:** 
  Docker Networks, such as bridge networks, create isolated Ethernet bridges specifically for inter-container communication, granting customized internal DNS resolution across container names without directly exposing them to the external physical network interfaces. A Host Network, bypassing this isolation entirely, attaches the container directly to the host machine's networking stack without network namespace isolation, losing Docker's inherent routing protection.

- **Docker Volumes vs Bind Mounts:** 
  Bind mounts tether a specific existing file or directory directly from the host system file tree into the running container path, directly tying security and dependency permissions to the host's structure. Docker Volumes are entirely decoupled from the host filesystem configuration and managed securely by Docker itself inside its own storage footprint. Docker Volumes provide much better performance on container deployments, seamless portability, and simplify backup mechanisms.

- **Alpine vs Debian as a base image:** 
  Alpine Linux is a security-oriented, minimal distribution built around musl libc and BusyBox, producing extremely small images (≈5 MB). Debian Bookworm is a full-featured distribution backed by the GNU C Library (glibc), offering the broadest package compatibility and the most mature ecosystem. This project uses **Debian Bookworm** because the required software stack (NGINX with OpenSSL, MariaDB, PHP 8.2-FPM and its extensions) is fully pre-packaged in Debian's APT repositories, eliminating the need to compile anything from source and reducing the risk of subtle runtime incompatibilities caused by musl/glibc differences.

## Instructions
**Compilation, Installation, and Execution:**
Running this project demands an active Virtual Machine with Docker installed.
1. Make sure to bind your loopback IP address `127.0.0.1` to the domain name mapping required in the subject via `/etc/hosts` file (e.g. `127.0.0.1 lantonio.42.fr`).
2. Configure your environment variables accurately in `srcs/.env` and securely populate your keys under the un-versioned `secrets` directory.
3. At the repository root, run the project automated builder:
   ```bash
   make
   ```
4. This initiates Docker Compose to build images from your `srcs/requirements/*/Dockerfile` entries and deploy containers into the custom network footprint. 

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Official Guide](https://nginx.org/en/docs/)
- **AI Usage:** Artificial Intelligence tools were used responsibly for content research for assistence in summarizing and drafting the initial content of README.md, USER_DOC.md, and DEV_DOC.md in markdown format directly from the project subject instructions. No raw unverified code was incorporated without fundamental checks nor understanding.
