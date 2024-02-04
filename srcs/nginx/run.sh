#!/bin/sh

mkdir -p /etc/nginx/certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/$DOMAIN_NAME.key -out /etc/nginx/certs/$DOMAIN_NAME.crt -subj "/C=$CRT_COUNTRY/L=$CRT_LOCATION/O=$CRT_ORG/OU=$CRT_ORG_UNITY/CN=$DOMAIN_NAME"

echo "
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    server {
        listen 443 ssl http2;
        server_name $DOMAIN_NAME;

        ssl_certificate /etc/nginx/certs/$DOMAIN_NAME.crt;
        ssl_certificate_key /etc/nginx/certs/$DOMAIN_NAME.key;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';

        location / {
            return 200 '¡Hola, mundo!';
        }
    }
}" > /etc/nginx/nginx.conf

nginx -g "daemon off;"