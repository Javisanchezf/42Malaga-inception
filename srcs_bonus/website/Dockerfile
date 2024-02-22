# Static Website on Alpine Linux
FROM alpine:3.19

# Set the TERM environment variable to make sure that the terminal is set up correctly
ENV TERM xterm

ARG DOMAIN_NAME

# Install NGINX and OpenSSL
RUN apk update && apk upgrade && apk add --no-cache \
    wget

RUN wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains example.com --no-parent http://example.com

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Clean up the package repository
RUN rm -f /var/cache/apk/*

# Command to keep the container running in the foreground
ENTRYPOINT ["/run.sh"]