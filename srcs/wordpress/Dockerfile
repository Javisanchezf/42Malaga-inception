# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

RUN apk update && \
	apk upgrade && \
    apk add --no-cache php82 php82-phar php82-curl php82-mysqli php82-tokenizer php82-fpm php82-iconv php82-mbstring php82-openssl php82-xml php82-opcache php82-json \
    curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp

RUN ln -fs /usr/bin/php82 /usr/bin/php
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm

COPY run.sh .
RUN chmod +x run.sh

CMD ["/run.sh"]