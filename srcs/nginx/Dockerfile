# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

# Set the TERM environment variable to make sure that the terminal is set up correctly
ENV TERM xterm

# Install NGINX and OpenSSL
RUN apk update && \
	apk upgrade && \
    apk add --no-cache nginx openssl

# Copy the script that will configurate and start NGINX
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
