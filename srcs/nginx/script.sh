#!/bin/bash

echo "
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    server {
        listen 443 ssl http2;
        server_name javiersa.42.fr;

        ssl_certificate /etc/nginx/certs/javiersa.42.fr.crt;
        ssl_certificate_key /etc/nginx/certs/javiersa.42.fr.key;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';

        location / {
            return 200 '¡Hola, mundo!';
        }
    }
}" > /etc/nginx/nginx.conf

nginx -g "daemon off;"