#!/bin/bash

sleep 6
echo "Starting up wordpress..."

# Check if the admin_username contains admin
if [[ $(echo $WP_ADMIN_N | tr '[:upper:]' '[:lower:]') =~ "admin" ]]; then
  echo "Error: Admin username cannot contain 'admin' or 'administrator' (case-insensitive)."
  exit 1
fi
echo "Admin username is valid."

# get wp-cli and set permissions
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# go to wordpress directory and change permissions
cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress


# Install WordPress if not already installed
if [ ! -f /var/www/wordpress/wp-config.php  ]; then
  echo "Setting up WordPress..."

  # download wordpress files
  wp core download --allow-root

  # create wp-config.php
  wp core config \
    --dbhost="$MARIADB_HOST" \
    --dbname="$MARIADB_NAME" \
    --dbuser="$MARIADB_USER" \
    --dbpass="$MARIADB_PASSWORD" \
    --allow-root

  # install wordpress
  wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_NAME" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root \
    --skip-email
  
  #create a new user
  wp user create \
    "$WP_USER_NAME" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASSWORD" \
    --role="$WP_USER_ROLE" \
    --allow-root
  echo "Wordpress installation and configuration completed."
else
  echo "Skipping wordpress setup."
fi

# change the listen directive in the php-fpm configuration file
sed -i "s|^listen = .*|listen = 9000|" "/etc/php/7.4/fpm/pool.d/www.conf"

# create a directory for php-fpm
mkdir -p /run/php

# start php-fpm service in the foreground
echo "Starting php-fpm"
/usr/sbin/php-fpm7.4 -F
