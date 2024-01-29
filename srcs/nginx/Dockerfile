# Use the Alpine Linux 3.19 base image
FROM alpine:3.19

# Install NGINX and OpenSSL
RUN apk update && apk add nginx openssl

# Create a directory to store TLS certificates
RUN mkdir -p /etc/nginx/certs

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY javiersa.42.fr.crt /etc/nginx/certs/javiersa.42.fr.crt
COPY javiersa.42.fr.key /etc/nginx/certs/javiersa.42.fr.key

# Expose port 443
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
