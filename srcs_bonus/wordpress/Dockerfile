# Wordpress + PHP on Alpine Linux
FROM alpine:3.19

# Set the TERM environment variable to make sure that the terminal is set up correctly
ENV TERM xterm

# Set the environment variables for the WordPress CLI version and the PHP version
ENV WORDPRESS_CLI_VERSION 2.10.0
ENV PHP_VERSION 82

# Update the package repository and install the required packages
RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-json \
    mariadb-client \
    curl

# Install the WordPress CLI
RUN curl -o /usr/local/bin/wp -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar" && \
    chmod +x /usr/local/bin/wp

# Configure the PHP-FPM service
RUN adduser -D -H -S -G www-data www-data && \
    sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
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

# Expose the port for the PHP-FPM service
EXPOSE 9000

ENTRYPOINT ["/run.sh"]