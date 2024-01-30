# MariaDB on Alpine Linux
# Use Alpine Linux version 3.19 as the base image
FROM alpine:3.19

# Set the environment variable for the terminal
ENV TERM xterm

# Update the package repository and install MariaDB and its client
RUN apk update && \
	apk upgrade && \
	apk add --no-cache mariadb mariadb-common mariadb-client openrc

RUN openrc && touch /run/openrc/softlevel

COPY my.cnf /etc/mysql/my.cnf
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Set the entry point to start MariaDB using 'mysqld_safe'
CMD ["/run.sh" ]
