FROM debian:bullseye-slim

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mariadb-server tini

# Copy startup script
COPY ./conf/setup-mariadb.sh /setup-mariadb.sh
RUN chmod +x /setup-mariadb.sh

HEALTHCHECK --interval=30s --timeout=3s \
  CMD mysqladmin ping -h localhost -u$MARIADB_USER -p$MARIADB_PASSWORD || exit 1

# run tini at startup to manage zombie processes
ENTRYPOINT ["/usr/bin/tini", "--"]
# Set the cmd to initialize the database and start the MariaDB server
CMD ["./setup-mariadb.sh"]