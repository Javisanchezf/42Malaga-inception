# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

# Install NGINX and OpenSSL
RUN apk update && \
	apk upgrade && \
    apk add --no-cache php php-phar php-curl php-mysqli php-tokenizer curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp

COPY run.sh .
RUN chmod +x run.sh

CMD ["/run.sh"]