name = inception

all:
	@printf "Initializing infrastructure $(name)...\n"
	@mkdir -p /home/lantonio/data/wordpress
	@mkdir -p /home/lantonio/data/mariadb
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@printf "Stopping infrastructure $(name)...\n"
	@docker compose -f srcs/docker-compose.yml down

re: fclean all

clean: down
	@printf "Cleaning containers and images...\n"
	@docker system prune -a --force

fclean: clean
	@printf "Cleaning all local vulumes and data...\n"
	@sudo rm -rf /home/lantonio/data/mariadb/*
	@sudo rm -rf /home/lantonio/data/wordpress/*
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

.PHONY: all down re clean fclean
