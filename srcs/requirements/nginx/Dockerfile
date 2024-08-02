FROM debian:bullseye-slim

# Install Nginx
# By default, apk add downloads the package index before installing packages. 
# Using --no-cache, apk will not store the downloaded index files, 
# preventing unnecessary cache from being saved in the Docker image.
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
  nginx \
  openssl \
  curl \
  tini

# Create necessary directories
#TODO: set non root user
RUN mkdir -p /etc/nginx/ssl

# # Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out /etc/nginx/ssl/myinception.crt -keyout \
    /etc/nginx/ssl/myinception.key -subj '/C=NL/O=Codam/CN=ccaljouw.42.fr/UID=ccaljouw'

# Copy Nginx configuration file
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 443

# manage PID 1 responsibilities
# Use Tini as the entry point to manage the application process and reap zombies
ENTRYPOINT ["/usr/bin/tini", "--"]

# Command to run Nginx in the foreground 
# By default, Nginx runs as a daemon, which means it starts, forks a new process, 
# and the original process exits. The directive daemon off; tells Nginx not to daemonize, 
# meaning it will run in the foreground, keeping the Docker container alive as long as Nginx is running.
CMD ["nginx", "-g", "daemon off;"]