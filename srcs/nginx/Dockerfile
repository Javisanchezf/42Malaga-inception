# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}
ENV TERM xterm

# Install NGINX and OpenSSL
RUN apk update && \
	apk upgrade && \
    apk add --no-cache nginx
# Create a directory to store TLS certificates
RUN mkdir -p /etc/nginx/certs

# Copy configuration files
COPY script.sh /script.sh
COPY $DOMAIN_NAME.crt /etc/nginx/certs/$DOMAIN_NAME.crt
COPY $DOMAIN_NAME.key /etc/nginx/certs/$DOMAIN_NAME.key

RUN chmod +x /run.sh

# Expose port 443
EXPOSE 443

# Start NGINX
CMD ["/script.sh"]
