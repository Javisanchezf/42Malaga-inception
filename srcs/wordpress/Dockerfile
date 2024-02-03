# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

# Install NGINX and OpenSSL
RUN apk update && \
	apk upgrade && \
    apk add --no-cache php

# Download WordPress and untar it
RUN wget https://wordpress.org/latest.tar.gz
RUN tar xvf latest.tar.gz
RUN rm latest.tar.gz

COPY run.sh .
RUN chmod +x run.sh

# Start NGINX
CMD ["/run.sh"]

#define('WP_DEBUG_LOG', true);!!!!!!!!!!!!!!!!!!!!!!!!!!!!