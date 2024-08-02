#!/bin/bash

service mariadb start
sleep 5 # wait for mariadb to start

# CONFIG
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MARIADB_NAME}\`;"
mariadb -e "CREATE USER IF NOT EXISTS \`${MARIADB_USER}\`@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${MARIADB_NAME}.* TO \`${MARIADB_USER}\`@'%';"
mariadb -e "FLUSH PRIVILEGES;"

# RESTART TO LOAD NEW CONFIG
mysqladmin -u root -p$MARIADB_ROOT_PASSWORD shutdown
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'