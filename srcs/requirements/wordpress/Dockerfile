FROM debian:bookworm-slim

# Install packages

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl php php8.2-fpm php-mysql mariadb-client

# Copy startup script
COPY ./conf/setup-wordpress.sh /setup-wordpress.sh
RUN chmod +x ./setup-wordpress.sh

ENTRYPOINT ["./setup-wordpress.sh"]