# Adminer on Alpine Linux
FROM alpine:3.19

# Set the environment variable for the terminal
ENV TERM xterm

# Set the environment variables for the the PHP version
ENV PHP_VERSION 82

# Update the package repository and install the required packages
RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-pdo_pgsql \
    php${PHP_VERSION}-pdo_sqlite \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-fpm \
    wget

# Configure the PHP-FPM service
RUN adduser -D -H -S -G www-data www-data && \
    sed -i 's/^listen = .*/listen = 0.0.0.0:9001/' /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/user = nobody/user = www-data/" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/group = nobody/group = www-data/" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php${PHP_VERSION}/php.ini && \
    ln -fs /usr/bin/php${PHP_VERSION} /usr/bin/php && \
    ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm

# Copy the run.sh script to the container
COPY run.sh .
RUN chmod +x run.sh

# Clean up the package repository
RUN rm -f /var/cache/apk/*

# Expose the port for Adminer
EXPOSE 9001

ENTRYPOINT ["./run.sh" ]
