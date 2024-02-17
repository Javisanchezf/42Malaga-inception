# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

ENV WORDPRESS_CLI_VERSION 2.10.0
ENV PHP_VERSION 82

ARG DOMAIN_NAME

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

RUN curl -o /usr/local/bin/wp -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar" && \
    chmod +x /usr/local/bin/wp

RUN sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/user = nobody/user = www-data/" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/group = nobody/group = www-data/" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/;listen.owner = nobody/listen.owner = www-data/" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s/;listen.group = nobody/listen.group = www-data/" /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    ln -fs /usr/bin/php${PHP_VERSION} /usr/bin/php && \
    ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm && \
    adduser -D -H -S -G www-data www-data && \
    rm -f /var/cache/apk/*

COPY run.sh .
RUN chmod +x run.sh

EXPOSE 9000

CMD ["/run.sh"]