# Redis Object Cache on Alpine Linux
FROM alpine:3.19

# Set the TERM environment variable to make sure that the terminal is set up correctly
ENV TERM xterm

# Install NGINX and OpenSSL
RUN apk update && apk upgrade && apk add --no-cache \
    redis

RUN sed -i 's/daemonize yes/daemonize no/' /etc/redis.conf && \
    sed -i 's/bind/# bind/' /etc/redis.conf && \
    sed -i 's/# maxmemory <bytes>/maxmemory 256mb/' /etc/redis.conf && \
    sed -i 's/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/' /etc/redis.conf && \
    sed -i 's/# requirepass foobared/requirepass 42Malaga/' /etc/redis.conf

# Clean up the package repository
RUN rm -f /var/cache/apk/*

# Expose the port that Redis server is listening on
EXPOSE 6379

# Start the Redis server in the foreground
ENTRYPOINT ["redis-server", "/etc/redis.conf"]