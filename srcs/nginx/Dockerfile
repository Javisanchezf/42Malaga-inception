# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

# Set the TERM environment variable to make sure that the terminal is set up correctly
ENV TERM xterm

# Install NGINX and OpenSSL
RUN apk update && apk upgrade && apk add --no-cache \
    nginx \
    openssl \
    envsubst

# Create the directory for the SSL certificate
RUN mkdir -p /etc/nginx/ssl

# Configure NGINX with the www-data user
RUN adduser -D -H -S -G www-data www-data && \
    sed -i 's/user nginx;/user www-data;/' /etc/nginx/nginx.conf

# Copy the script that will configurate and start NGINX
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Copy the NGINX template configuration file
COPY nginx_template.conf .


# Expose the ports for NGINX
EXPOSE 443

CMD ["/run.sh"]
