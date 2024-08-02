COLOR_RESET=\033[0m
COLOR_GREEN=\033[32m
COLOR_RED=\033[31m
COLOR_BLUE=\033[34m

# Function to print messages in color
define color_output
  @output=`$(1) 2>&1`; \
  if [ $$? -eq 0 ]; then \
    echo -e "$(COLOR_GREEN)$(1): $$output$(COLOR_RESET)"; \
  else \
    echo -e "$(COLOR_RED)$(1): $$output$(COLOR_RESET)"; \
  fi
endef

all:
	@echo -e "$(COLOR_BLUE) **** CREATE FOLDERS AND UP ****$(COLOR_RESET)"	
	$(call color_output, mkdir -p ./srcs/requirements/mariadb/data)
	$(call color_output, mkdir -p ./srcs/requirements/wordpress/files)
	docker compose -f ./srcs/docker-compose.yml up

build:
	@echo -e "$(COLOR_BLUE) **** REBUILDING IMAGES BEFORE UP ****$(COLOR_RESET)"	
	$(call color_output, mkdir -p ./srcs/requirements/mariadb/data)
	$(call color_output, mkdir -p ./srcs/requirements/wordpress/files)
	docker compose -f ./srcs/docker-compose.yml up --build

re: fclean all

up:
	docker compose -f ./srcs/docker-compose.yml up

down:
	docker compose -f ./srcs/docker-compose.yml down

start:
	docker compose -f ./srcs/docker-compose.yml start

stop:
	docker compose -f ./srcs/docker-compose.yml stop

clean: down
	@echo -e "$(COLOR_BLUE) **** REMOVE FILES AND DATA ****$(COLOR_RESET)"	
	$(call color_output, rm -rf ./srcs/requirements/mariadb/data)
	$(call color_output, rm -rf ./srcs/requirements/wordpress/files)

fclean: clean
	@echo -e "$(COLOR_BLUE) **** NGINX ****$(COLOR_RESET)"	
	@$(call color_output, docker rmi srcs-nginx)
	@echo -e "$(COLOR_BLUE) **** MARIADB ****$(COLOR_RESET)"	
	@$(call color_output, docker volume rm -f srcs_db_data)
	@$(call color_output, docker rmi srcs-mariadb)
	@echo -e "$(COLOR_BLUE) **** WORDPRESS ****$(COLOR_RESET)"	
	@$(call color_output, docker volume rm -f srcs_wordpress_files)
	@$(call color_output, docker rmi srcs-wordpress)

prune:
	docker system prune -af
	docker volume prune -af

.PHONY: all start stop up down build clean fclean re prune