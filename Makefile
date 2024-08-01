all: run

run:
	docker compose -f ./srcs/docker-compose.yml up

mariadb:
	docker compose -f ./srcs/docker-compose.yml up mariadb

wordpress:
	docker compose -f ./srcs/docker-compose.yml up wordpress

nginx:
	docker compose -f ./srcs/docker-compose.yml up nginx

restart_nginx:
	docker-compose -f ./srcs/docker-compose.yml restart nginx

re: clean
	docker compose -f ./srcs/docker-compose.yml up

rebuild: clean
	docker compose --build -f ./srcs/docker-compose.yml up

clean:
	docker compose -f ./srcs/docker-compose.yml down 

fclean: clean
	- docker rmi mariadb
	- docker rmi wordpress
	- docker rmi nginx

clean_volumes:
	docker volume rm srcs_db_data
	docker volume rm srcs_wordpress_files
	docker volume rm srcs_nginx_config

prune: fclean
	docker system prune -af
	docker volume prune -f

.PHONY:	all clean fclean re rebuild run prune backend
