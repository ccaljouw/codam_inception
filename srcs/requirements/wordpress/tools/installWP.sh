#!/bin/bash


# create directory to use in nginx container later and also to setup the wordpress conf
mkdir /var/www/
mkdir /var/www/html

cd /var/www/html

rm -rf *

wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz

mv /wp-config-sample.php  /var/www/html/wp-config.php
