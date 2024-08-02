#!/bin/bash

echo "waiting for mariadb to start..."
sleep 6

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

# download wordpress files
wp core download --allow-root
if [ $? -eq 0 ]; then
  echo "Setting up WordPress..."
  # create wp-config.php
  wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
  # install wordpress
  wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
  #create a new user
  wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
  echo "Wordpress installation and configuration completed."
else
  echo "Skipping wordpress setup."
fi

# modify the listen directive in the php-fpm configuration file
LISTEN_ADDRESS="${PHP_FPM_LISTEN:-9000}"
PHP_FPM_CONF="/etc/php/8.2/fpm/pool.d/www.conf"
sed -i "s|^listen = .*|listen = ${LISTEN_ADDRESS}|" "$PHP_FPM_CONF"

# start php-fpm service in the foreground
echo "Starting php-fpm"
/usr/sbin/php-fpm8.2 -F
