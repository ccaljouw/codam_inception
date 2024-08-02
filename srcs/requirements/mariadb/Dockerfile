FROM debian:bookworm-slim

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mariadb-server

# Copy startup script
COPY ./conf/setup-mariadb.sh /setup-mariadb.sh
RUN chmod +x /setup-mariadb.sh

# Set the entrypoint to initialize the database and start the MariaDB server
ENTRYPOINT ["./setup-mariadb.sh"]