# MariaDB on Alpine Linux
FROM alpine:3.19

# Set the environment variable for the terminal
ENV TERM xterm

# Update the package repository and install MariaDB and its client
RUN apk update && apk upgrade && apk add --no-cache \
	mariadb \
	mariadb-common \
	mariadb-client \
	openrc


# Allow remote connections to the database
RUN sed -i 's/#bind-address/bind-address/' /etc/my.cnf.d/mariadb-server.cnf && \
	sed -i 's/skip-networking/#skip-networking/' /etc/my.cnf.d/mariadb-server.cnf

# Start services manager
RUN openrc && touch /run/openrc/softlevel

# Create a directory for the database and set the owner to the mysql user
RUN mkdir -p /run/mysqld && \
	chown -R mysql /run/mysqld && \
	/etc/init.d/mariadb setup && \
	chown -R mysql /var/lib/mysql

# Copy the database initialization script to the container
COPY run.sh .
RUN chmod +x run.sh

# Clean up the package repository
RUN rm -f /var/cache/apk/*

# Expose the port for the database
EXPOSE 3306

ENTRYPOINT ["./run.sh" ]
