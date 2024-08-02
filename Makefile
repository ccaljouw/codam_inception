all: run

run:
	docker compose -f ./srcs/docker-compose.yml up

mariadb:
	docker compose -f ./srcs/docker-compose.yml up mariadb

clean_mariadb: clean
	- rm -r ./srcs/requirements/mariadb/data
	- mkdir ./srcs/requirements/mariadb/data
	- docker rmi mariadb
	- docker volume rm srcs_db_data

wordpress:
	docker compose -f ./srcs/docker-compose.yml up wordpress

clean_wordpress: clean
	rm -r ./srcs/requirements/wordpress/files
	mkdir ./srcs/requirements/wordpress/files
	docker rmi wordpress
	docker volume rm srcs_wordpress_files

nginx:
	docker compose -f ./srcs/docker-compose.yml up nginx

restart_nginx:
	docker-compose -f ./srcs/docker-compose.yml restart nginx

fclean_nginx: clean
	docker rmi nginx
	docker volume rm srcs_nginx_config

re: clean clean_wordpress_data
	docker compose -f ./srcs/docker-compose.yml up --build

clean:
	docker compose -f ./srcs/docker-compose.yml down 

clean_images: clean
	docker compose -f ./srcs/docker-compose.yml down
	- docker rmi mariadb
	- docker rmi wordpress
	- docker rmi nginx

clean_wordpress_data:
	-	rm -r ./srcs/requirements/wordpress/files
	-	mkdir ./srcs/requirements/wordpress/files
	-	rm -r ./srcs/requirements/mariadb/data
	-	mkdir ./srcs/requirements/mariadb/data

fclean: clean_images clean_wordpress_data
	- docker volume rm srcs_db_data
	- docker volume rm srcs_wordpress_files
	- docker volume rm srcs_nginx_config

.PHONY:	all clean fclean re rebuild run prune backend
