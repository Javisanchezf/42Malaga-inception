# MariaDB on Alpine Linux
# Use Alpine Linux version 3.19 as the base image
FROM alpine:3.19

# Set the environment variable for the terminal
ENV TERM xterm

# Update the package repository and install MariaDB and its client
RUN apk update && apk add mariadb mariadb-client

# Run the MySQL installation script with the specified user
RUN mysql_install_db --user=mysql

# Copy MariaDB configuration files to the appropriate directory
COPY my.cnf /etc/mysql/my.cnf

# Define volumes for MariaDB data directory and log directory
VOLUME /var/lib/mysql
# VOLUME /var/log/mysql

# Create a directory for MariaDB backups and set permissions
RUN mkdir -p /var/backups/mysql
RUN chmod a+r /var/backups/mysql/

# Specify a volume for MariaDB backup directory
VOLUME /var/backups/mysql

# Expose the default MariaDB port
EXPOSE 3306

# Set the entry point to start MariaDB using 'mysqld_safe'
CMD ["mysqld_safe"]