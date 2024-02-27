# Netdata on Alpine Linux
FROM alpine:3.19

# Set the environment variable for the terminal
ENV TERM xterm

# Install the necessary packages
RUN apk update && apk upgrade && apk add --no-cache \
	netdata

# Clean up the package repository
RUN rm -f /var/cache/apk/*

# Expose the port
EXPOSE 19999

ENTRYPOINT ["netdata", "-D"]
