FROM debian:bullseye-slim

# Install packages
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y \
  curl \
  php \
  php7.4-fpm \
  php-mysql \
  mariadb-client \
  tini

# Copy startup script
COPY ./conf/setup-wordpress.sh /setup-wordpress.sh
RUN chmod +x ./setup-wordpress.sh

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD pgrep -f 'php-fpm' || exit 1

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["./setup-wordpress.sh"]